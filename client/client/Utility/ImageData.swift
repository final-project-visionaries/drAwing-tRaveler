import SwiftUI

@MainActor
class ImageData: ObservableObject {
    @Published var AllImages:[ApiImage] = [] // [[], [], []]
    @Published var AllUIImages:[UIImage] = [] // base64 -> UIImage
    @Published var SelectedImages: [Bool] = [] // [0,1,2,3,4,5] -> [1,3,4] を選択すると [F,T,F,T,T,F] となる
    @Published var ArModels:[UIImage] = [] // [1のUIImage, 3のUIImage, 4のUIImage]
    
    //base64からUIImageに変換する関数
    func convertBase64ToImage(_ base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String) else { return nil }
        return UIImage(data: imageData)
    }
    
    func SetImages(){
        Task{
            self.AllImages = try await apiImageGetRequest()
            self.SelectedImages = Array(repeating: false, count: self.AllImages.count)
            self.AllUIImages = []
            print("GET images count : \(self.AllImages.count)")
            for i in 0 ..< self.AllImages.count {
                let result = convertBase64ToImage(self.AllImages[i].image_data)!
                self.AllUIImages.append(result)
            }
        }
    }
    
    func SetArModels(){
        ArModels = []
        for i in 0 ..< AllImages.count {
            if SelectedImages[i] == true {
                ArModels.append(AllUIImages[i])
            }
        }
        print("ArModels-> \(ArModels.count)")
    }
    
    //UIImageをもらってリサイズして圧縮してエンコードしてbase64をリターンする
    func resizeImageToBase64(image: UIImage) -> String {
        let targetSize = CGSize(width: 200, height: 200)
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
        return base64String ?? "post error"
      }
}

