import SwiftUI
import RealityKit
import ARKit

struct TakePhotoView : View {
    @StateObject var imageSaver = ImageSaver()
    @EnvironmentObject var imageData : ImageData
    @State private var isSaved  = false
    @State private var isSaved2 = false
    @State private var count = 2
    
    var body: some View {
        ZStack{
            ARViewContainer_()
                .ignoresSafeArea()
                .onDisappear{
                    ARVariables_.dismantleUIView(ARVariables_.arView, coordinator: ())
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
                        isSaved.toggle()
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {timer in
                            self.count -= 1
                            if self.count == 0 {
                                timer.invalidate()
                                self.isSaved.toggle()
                                self.count = 2
                            }
                        }
                    } label: {
                        Image(systemName: "camera")
                            .frame(width:60, height:60).font(.title)
                            .background(.white.opacity(0.75)).cornerRadius(30).padding()
                    } // Save to Album DB
                    Spacer()
                    Button {
                        ARVariables_.arView.snapshot(saveToHDR: false) { (image) in
                            let compressedImage = UIImage(data: (image?.pngData())!)
                            imageSaver.writeToPhotoAlbum(image: compressedImage ?? UIImage())
                        }
                        PlaySound.instance.playSound(filename: "camera")
                        isSaved2.toggle()
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {timer in
                            self.count -= 1
                            if self.count == 0 {
                                timer.invalidate()
                                self.isSaved2.toggle()
                                self.count = 2
                            }
                        }
                    } label: {
                        Image(systemName: "iphone.circle")
                            .frame(width:60, height:60).font(.title)
                            .background(.white.opacity(0.75)).cornerRadius(30).padding()
                    } // Save to iPhone Album
                    Spacer()
                }
            }
            
            if isSaved == true {
                ZStack{
                    Rectangle()
                        .ignoresSafeArea()
                        .foregroundColor(.black).opacity(0.5)
                        .frame(maxWidth: UIScreen.main.bounds.size.width, maxHeight: UIScreen.main.bounds.size.height)
                    Text("しゃしんをほぞんしたよ！").foregroundStyle(.white).font(.title)
                }
            }
            
            if isSaved2 == true {
                ZStack{
                    Rectangle()
                        .ignoresSafeArea()
                        .foregroundColor(.blue).opacity(0.5)
                        .frame(maxWidth: UIScreen.main.bounds.size.width, maxHeight: UIScreen.main.bounds.size.height)
                    Text("iPhoneにほぞんするよ！").foregroundStyle(.white).font(.title)
                }
            }
            
        } // ZStack
        .customBackButton()
    }
}

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
