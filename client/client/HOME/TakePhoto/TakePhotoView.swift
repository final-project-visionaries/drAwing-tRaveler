import SwiftUI
import RealityKit
import ARKit

struct TakePhotoView : View {
    @EnvironmentObject var imageData : ImageData
    
    var body: some View {
        ZStack{
            ARViewContainer_()
                .ignoresSafeArea()
                .onDisappear{
                    ARVariables_.dismantleUIView(ARVariables_.arView, coordinator: ())//ARセッション停止
                }
            
            HStack{ Spacer()
                VStack{ Spacer()
                    Button {
                        ARVariables_.arView.snapshot(saveToHDR: false) { (image) in
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
                    Spacer()
                }
            }
        } // ZStack
        .customBackButton()
    }
}

//snapshot（スクショ）を撮影するためにstructを定義
struct ARVariables_{
    static var arView: ARView!
    static func dismantleUIView(_ uiView: ARView, coordinator: ()) {
        uiView.session.pause()
    }
}

struct ARViewContainer_: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        ARVariables_.arView = ARView(frame: .zero)
        return ARVariables_.arView
    }
    func updateUIView(_ uiView: ARView, context: Context) {}
}
