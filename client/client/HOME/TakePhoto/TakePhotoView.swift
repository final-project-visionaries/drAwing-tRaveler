import SwiftUI

struct TakePhotoView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        picker.navigationController?.isNavigationBarHidden = true
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // ここで撮影した画像を取得できます
            if let image = info[.originalImage] as? UIImage {
                // 画像を使用する処理を書く
                let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 200, height: 200))
                            // 画像をBase64にエンコード
                            if let imageData = resizedImage.jpegData(compressionQuality: 1.0) {
                                let base64String = imageData.base64EncodedString()
                                // base64Stringを使用する処理を書く
                                let imageName = String(base64String.prefix(10))
                                var sendData: [String:String] = [:]
                                sendData["image_name"] = imageName
                                sendData["image_data"] = base64String
//                                print("sendData : \(sendData)")
                                Task {
                                    let res = await apiImagePostRequest(reqBody: sendData)
                                    print("res : \(res)")
                                }
                                
                            }
            }
            picker.dismiss(animated: true)
        }
        func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
                let size = image.size
                let widthRatio  = targetSize.width  / size.width
                let heightRatio = targetSize.height / size.height
                let ratio = min(widthRatio, heightRatio)
                let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
                let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
                
                UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
                image.draw(in: rect)
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                return newImage ?? UIImage()
            }
    }
}


