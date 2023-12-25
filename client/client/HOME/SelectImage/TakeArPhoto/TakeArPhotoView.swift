import SwiftUI
import RealityKit
import ARKit

struct TakeArPhotoView : View {
    @EnvironmentObject var imageData : ImageData
    
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
        HStack{
            HStack(spacing:0){ // 画面下部のミニ画像
                ForEach(0 ..< imageData.ArModels.count, id: \.self){ i in
                    Image(uiImage: imageData.ArModels[i]).resizable().scaledToFit().frame(height: 40).padding(10)
                }
            }
            .background(Color.pink.opacity(0.1))
            .cornerRadius(10)
            Spacer()
            Button(action: {
                print("AR camera!")
                SoundManager.instance.playSound(sound: "camera", withExtension: "mp3")
            }, label:{Image(systemName: "camera.fill")})
        }
        .customBackButton()
        .onAppear{
            SoundManager.instance.playSound(sound: "bell", withExtension: "mp3")
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var imageData : ImageData
    
    let arView = ARView(frame: .zero)
    
    func setupARView() {
        let box = ModelEntity(mesh: .generateBox(size: simd_make_float3(0.2, 0.2, 0)))
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("temp.png")
        var imageMaterial = UnlitMaterial()
        Task {
            let uiImage = imageData.ArModels[0]
            if let pngData = uiImage.pngData(),
               ((try? pngData.write(to: url)) != nil),
               let texture = try? TextureResource.load(contentsOf: url) {
                imageMaterial.baseColor = MaterialColorParameter.texture(texture)
                box.model?.materials = [imageMaterial]
                anchor.children.append(box)
            }
            arView.scene.anchors.append(anchor)
        }
    }
    
    func makeUIView(context: Context) -> ARView {
        setupARView()
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}

//#Preview {
//    TakeArPhotoView().environmentObject(ImageData())
//}
