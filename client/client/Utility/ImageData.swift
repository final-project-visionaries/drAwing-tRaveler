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
    
    //base64 -> UIImage
    func convertBase64ToImage(_ base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String) else { return nil }
        return UIImage(data: imageData)
    }
    
    func SetImages(){//画像データのGET（初期化）
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
    }
    
    func SetAlbums(){//アルバムデータのGET（初期化）
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
    }
    
    func SetArModels(){//選択したARモデルのGET（初期化）
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
    }
    
    // UIImage -> resize -> compress -> encode -> base64
    func resizeImageToBase64(image: UIImage) -> String {
        let targetSize = CGSize(width: 2000, height: 2000)
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
      }
}

