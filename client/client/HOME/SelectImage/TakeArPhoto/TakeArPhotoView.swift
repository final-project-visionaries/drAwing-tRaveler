import SwiftUI
import RealityKit
import ARKit

struct TakeArPhotoView : View {
    @EnvironmentObject var imageData : ImageData
    var body: some View {
        HStack{
            ARViewContainer().edgesIgnoringSafeArea(.all)
            Spacer()
            VStack{
                VStack(spacing:0){ // 画面右側のミニ画像
                    ForEach(0 ..< imageData.ArModels.count, id: \.self){ i in
                        Image(uiImage: imageData.ArModels[i] )
                            .resizable().scaledToFit().frame(maxWidth: 60,maxHeight:60)
                    }
                }
                Spacer()
                Button {//写真撮影ボタンを押してスクショを撮り、album_tableにPOST
                    ARVariables.arView.snapshot(saveToHDR: false) { (image) in
                        let compressedImage = UIImage(data: (image?.pngData())!)
                        var sendData: [String:String] = [:]
                        sendData["album_name"] = "post from AR View"
                        sendData["album_data"] = imageData.resizeImageToBase64(image: compressedImage ?? UIImage())
                        //            sendData["album_latitude"] = 35.1706431//緯度
                        //            sendData["album_longitude"] = 136.8816945//経度
                        Task {
                            let res = await apiAlbumPostRequest(reqBody: sendData)
                            print(res)
                        }
                    }
                    SoundManager.instance.playSound(sound: "camera", withExtension: "mp3")
                } label: {
                    Image(systemName: "camera")
                        .frame(width:60, height:60).font(.title)
                        .background(.white.opacity(0.75)).cornerRadius(30).padding()
                }
            }
            .background(//画面右側のミニ画像の背景色を設定
                LinearGradient(
                    gradient: Gradient(colors: [Color.cyan,Color.blue]),
                    startPoint: .init(x: 0.3, y: 0.3),
                    endPoint: .init(x: 0.55, y: 0.55)
                ))
            .customBackButton()
            .onAppear{
                SoundManager.instance.playSound(sound: "bell", withExtension: "mp3")
            }
        }
    }
}

//snapshot（スクショ）を撮影するためにstructを定義
struct ARVariables{
    static var arView: ARView!
}

struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var imageData : ImageData
    
    func makeUIView(context: Context) -> ARView {
        ARVariables.arView = ARView(frame: .zero)
        ARVariables.arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap)))
        
        context.coordinator.view = ARVariables.arView
        return ARVariables.arView
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(arData:imageData.ArModels)
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}

//#Preview {
//    TakeArPhotoView().environmentObject(ImageData())
//}
