import SwiftUI
import RealityKit

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
                            .resizable().scaledToFit().frame(height:40).cornerRadius(10)
                            .onTapGesture {
                                PlaySound.instance.playSound(filename: "car")
                                imageData.SelectedModels = Array(repeating: false, count: imageData.ArModels.count)
                                imageData.SelectedModels[i].toggle()//ARモデルがひとつだけ選択可能
                                print("現在選択されているモデル : \(i)番目")
                            }
                            .clipped().shadow(color: Color.black, radius: 5, x: 5, y: 5)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.pink, lineWidth: imageData.SelectedModels[i] ? 5 : 0)
                            )
                            .scaleEffect(imageData.SelectedModels[i] ? 1.2 : 1.0)
                            .padding(.vertical, 5)
                    }
                    
                }
                Spacer()
                Button {//カメラボタンを押してスクショを撮り、album_tableにPOST
                    ARVariables.arView.snapshot(saveToHDR: false) { (image) in
                        let compressedImage = UIImage(data: (image?.pngData())!)
                        var sendData: [String:Any] = [:]
                        sendData["album_name"] = "post from AR View"
                        sendData["album_data"] = imageData.resizeImageToBase64(image: compressedImage ?? UIImage())
                        sendData["album_latitude"] = 35.1706431//緯度(ダミーデータ)
                        sendData["album_longitude"] = 136.8816945//経度(ダミーデータ)
                        Task {
                            let res = await apiAlbumPostRequest(reqBody: sendData)
                            print("AR POST res : \(res)")
                        }
                    }
                    PlaySound.instance.playSound(filename: "camera")
                } label: {
                    Image(systemName: "camera")
                        .frame(width:60, height:60).font(.title)
                        .background(.white.opacity(0.75)).cornerRadius(30).padding()
                }
            }
            .background(//画面右側のミニ画像の背景色
                LinearGradient(gradient: Gradient(colors: [.cyan, .blue]), startPoint: .top, endPoint: .bottom)
            )
            .customBackButton()
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
        Coordinator(arModels: imageData.ArModels, selectedModels: imageData.SelectedModels)
        //ArModelsとSelectedModelsをCoordinatorに渡す
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}
