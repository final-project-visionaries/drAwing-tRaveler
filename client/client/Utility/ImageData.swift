import SwiftUI

@MainActor
class ImageData: ObservableObject {
    // Album
    @Published var AllAlbums:[ApiAlbum]  = []
    @Published var AllUIAlbums:[UIImage] = []
    @Published var SelectedAlbums:[Bool] = []
    // Image
    @Published var AllImages:[ApiImage]  = [] // [[], [], []]
    @Published var AllUIImages:[UIImage] = [] // base64 -> UIImage
    @Published var SelectedImages:[Bool] = [] // [0,1,2,3,4,5] -> select [1,3,4] -> [F,T,F,T,T,F]
    // AR
    @Published var ArModels:[UIImage]    = [] // [1 UIImage, 3 UIImage, 4 UIImage]
    @Published var SelectedModels:[Bool] = [] // select 3 -> [F,T,F]
    
    func convertBase64ToImage(_ base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String) else { return nil }
        return UIImage(data: imageData)
    } // base64 -> UIImage
    
    func SetImages(){
        Task{
            self.AllImages = await apiImageGetRequest()
            self.SelectedImages = Array(repeating: false, count: self.AllImages.count)
            self.AllUIImages = []
            print("GET images count : \(self.AllImages.count)")
            for i in 0 ..< self.AllImages.count {
                let result = convertBase64ToImage(self.AllImages[i].image_data)!
                self.AllUIImages.append(result)
            }
        }
    } // 画像データのGET（初期化）
    
    func SetAlbums(){
        Task{
            self.AllAlbums = await apiAlbumGetRequest()
            self.SelectedAlbums = Array(repeating: false, count: self.AllAlbums.count)
            self.AllUIAlbums = []
            print("GET albums count : \(self.AllAlbums.count)")
            for i in 0 ..< self.AllAlbums.count {
                let result = convertBase64ToImage(self.AllAlbums[i].album_data)!
                self.AllUIAlbums.append(result)
            }
        }
    } // アルバムデータのGET（初期化）
    
    func SetArModels(){
        ArModels = []
        SelectedModels = []
        for i in 0 ..< AllImages.count {
            if SelectedImages[i] == true {
                ArModels.append(AllUIImages[i])
                SelectedModels.append(false)
            }
        }
        print("ArModels -> \(ArModels.count)")
        print("SelectedModels -> \(SelectedModels.count)")
    } // 選択したARモデルのGET（初期化）
    
    func resizeImageToBase64(image: UIImage) -> String {
        let targetSize = CGSize(width: 500, height: 500)
        let size = image.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let ratio = min(widthRatio, heightRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let imageDataFromBack = newImage?.jpegData(compressionQuality: 1.0)
        let base64String = imageDataFromBack?.base64EncodedString()
        return base64String ?? "resize error"
      } // UIImage -> resize -> compress -> encode -> base64
}

import CoreLocation
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocation?
    private var locationManager = CLLocationManager()
    override init() {
        super.init()
        setupLocationManager()
    }
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        DispatchQueue.global().async {  // ←【追加】
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location
            print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error.localizedDescription)")
    }
}

class ImageSaver: NSObject, ObservableObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Saved to iPhone Album! - Error : \(String(describing: error))")
    }
}
