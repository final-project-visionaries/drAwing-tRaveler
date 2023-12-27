import SwiftUI
import RealityKit
import ARKit

struct TakePhotoView : View {
    
    @EnvironmentObject var imageData : ImageData
    
    var body: some View {
        HStack{
            ARViewContainer2().edgesIgnoringSafeArea(.all)
            Spacer()
            VStack{
                Spacer()
                Button {
                    ARVariables2.arView.snapshot(saveToHDR: false) { (image) in
                        let compressedImage = UIImage(data: (image?.pngData())!)
                        var sendData: [String:String] = [:]
                        sendData["image_name"] = "post from Camera View"
                        sendData["image_data"] = imageData.resizeImageToBase64(image: compressedImage ?? UIImage())
                        Task {
                            let res = await apiImagePostRequest(reqBody: sendData)
                            print("Camera POST res : \(res)")
                        }
                    }
                    PlaySound.instance.playSound(filename: "camera")
                } label: {
                    Image(systemName: "camera")
                        .frame(width:60, height:60).font(.title)
                        .background(.white.opacity(0.75)).cornerRadius(30).padding()
                }
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [.yellow, .orange]), startPoint: .top, endPoint: .bottom)
            )
            .customBackButton()
            .onDisappear{
                ARVariables2.dismantleUIView(ARVariables2.arView, coordinator: ())//HomeViewに戻った際にARセッションを止めてエラー回避
            }
        }
    }
}

//snapshot（スクショ）を撮影するためにstructを定義
struct ARVariables2{
    static var arView: ARView!
    static func dismantleUIView(_ uiView: ARView, coordinator: ()) {
        uiView.session.pause() // Do I need it???
    }
}

struct ARViewContainer2: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        ARVariables2.arView = ARView(frame: .zero)
        return ARVariables2.arView
    }
    func updateUIView(_ uiView: ARView, context: Context) {}
}
