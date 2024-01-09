import SwiftUI
import RealityKit
import ARKit

struct TakeArPhotoView : View {
    @EnvironmentObject var imageData : ImageData
    @State private var isPlacing = false
    @State private var Selected: UIImage? = nil
    @State private var Confirmed1: UIImage? = nil
    @State private var Confirmed2: UIImage? = nil
    @State private var Confirmed3: UIImage? = nil
    @State private var Confirmed4: UIImage? = nil
    
    var body: some View {
        ZStack{
            ARViewContainer_(confirmed1: self.$Confirmed1, confirmed2: self.$Confirmed2, confirmed3: self.$Confirmed3, confirmed4: self.$Confirmed4)
            if self.isPlacing { // 選択モードの表示内容
                VStack{ Spacer()
                    HStack{
                        Button(action: { // Cancel Button
                            PlaySound.instance.playSound(filename: "top")
                            self.isPlacing.toggle()
                            self.Selected = nil
                        }, label: {
                            Image(systemName: "xmark").frame(width: 60, height: 60).font(.title)
                                .background(.white.opacity(0.35)).cornerRadius(30).padding(5)
                        })
                        
                        Button(action: { // Confirm1 Button 左上
                            PlaySound.instance.playSound(filename: "bell")
                            self.Confirmed1 = self.Selected
                            self.isPlacing.toggle()
                            self.Selected = nil
                        }, label: {
                            Image(systemName: "checkmark").resizable().frame(width: 120, height: 120).font(.title)
                                .background(.white.opacity(0.75)).cornerRadius(30).padding(5)
                        })
                        
                        Button(action: { // Confirm2 Button 左下
                            PlaySound.instance.playSound(filename: "bell")
                            self.Confirmed2 = self.Selected
                            self.isPlacing.toggle()
                            self.Selected = nil
                        }, label: {
                            Image(systemName: "square.dashed").resizable().frame(width: 120, height: 120).font(.title)
                                .background(.white.opacity(0.75)).cornerRadius(30).padding(5)
                        })
                        
                        Button(action: { // Confirm3 Button 右上
                            PlaySound.instance.playSound(filename: "bell")
                            self.Confirmed3 = self.Selected
                            self.isPlacing.toggle()
                            self.Selected = nil
                        }, label: {
                            Image(systemName: "arkit").resizable().frame(width: 120, height: 120).font(.title)
                                .background(.white.opacity(0.75)).cornerRadius(30).padding(5)
                        })
                        
                        Button(action: { // Confirm4 Button 右下
                            PlaySound.instance.playSound(filename: "bell")
                            self.Confirmed4 = self.Selected
                            self.isPlacing.toggle()
                            self.Selected = nil
                        }, label: {
                            Image(systemName: "arrowshape.turn.up.left").resizable().frame(width: 120, height: 120).font(.title)
                                .background(.white.opacity(0.75)).cornerRadius(30).padding(5)
                        })
                    }
                }
                Image(uiImage:self.Selected ?? UIImage()).resizable().scaledToFit().frame(height:80).opacity(0.5)//透明の画像
            } else { // 配置モードの表示内容
                VStack{ Spacer()
                    ScrollView(.horizontal, showsIndicators:false){
                        HStack(spacing: 20){
                            ForEach(0 ..< imageData.ArModels.count, id: \.self){i in
                                Button {
                                    PlaySound.instance.playSound(filename: "car")
                                    self.Selected = imageData.ArModels[i]
                                    self.isPlacing.toggle()
                                } label: {
                                    Image(uiImage: imageData.ArModels[i]).resizable().frame(height: 80)
                                        .aspectRatio(1/1, contentMode: .fit).background(.white).cornerRadius(12)
                                }
                            }
                        }
                    }
                    .padding(10).background(.black.opacity(0.5))
                }
            }
            VStack{ Spacer()
                HStack{ Spacer()
                    Button {//Camera Button
                        ARVariables_.arView.snapshot(saveToHDR: false) { (image) in
                            let compressedImage = UIImage(data: (image?.pngData())!)
                            var sendData: [String:Any] = [:]
                            sendData["album_name"] = "From AR_check"
                            sendData["album_data"] = imageData.resizeImageToBase64(image: compressedImage ?? UIImage())
                            sendData["album_latitude"]  = 35.1706431  // Dummy Data
                            sendData["album_longitude"] = 136.8816945 // Dummy Data
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
            }
        }
        .customBackButton()
    }
}

struct ARVariables_{ static var arView: ARView! }

struct ARViewContainer_: UIViewRepresentable {
    @Binding var confirmed1: UIImage?
    @Binding var confirmed2: UIImage?
    @Binding var confirmed3: UIImage?
    @Binding var confirmed4: UIImage?
    
    func makeUIView(context: Context) -> ARView {
        ARVariables_.arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        ARVariables_.arView.session.run(config)
        return ARVariables_.arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let uiImage = self.confirmed1 {
            let modelEntity = ModelEntity(mesh: MeshResource.generateBox(width: 0.3, height: 0.3, depth: 0.1))
            modelEntity.generateCollisionShapes(recursive: true)
            modelEntity.model?.materials = [createTexture_(drawing: uiImage.cgImage)]
            let anchorEntity1 = AnchorEntity(world: SIMD3(x:-0.65,y:0.2,z:-1.3))
            anchorEntity1.addChild(modelEntity.clone(recursive: true))
            uiView.scene.addAnchor(anchorEntity1)
            DispatchQueue.main.async {
                self.confirmed1 = nil
            }
        }
        if let uiImage = self.confirmed2 {
            let modelEntity = ModelEntity(mesh: MeshResource.generateBox(width: 0.3, height: 0.3, depth: 0.1))
            modelEntity.generateCollisionShapes(recursive: true)
            modelEntity.model?.materials = [createTexture_(drawing: uiImage.cgImage)]
            let anchorEntity2 = AnchorEntity(world: SIMD3(x:-0.65,y:-0.2,z:-1.3))
            anchorEntity2.addChild(modelEntity.clone(recursive: true))
            uiView.scene.addAnchor(anchorEntity2)
            DispatchQueue.main.async {
                self.confirmed2 = nil
            }
        }
        if let uiImage = self.confirmed3 {
            let modelEntity = ModelEntity(mesh: MeshResource.generateBox(width: 0.3, height: 0.3, depth: 0.1))
            modelEntity.generateCollisionShapes(recursive: true)
            modelEntity.model?.materials = [createTexture_(drawing: uiImage.cgImage)]
            let anchorEntity3 = AnchorEntity(world: SIMD3(x:0.65,y:0.2,z:-1.3))
            anchorEntity3.addChild(modelEntity.clone(recursive: true))
            uiView.scene.addAnchor(anchorEntity3)
            DispatchQueue.main.async {
                self.confirmed3 = nil
            }
        }
        if let uiImage = self.confirmed4 {
            let modelEntity = ModelEntity(mesh: MeshResource.generateBox(width: 0.3, height: 0.3, depth: 0.1))
            // let modelEntity = ModelEntity(mesh:.generateSphere(radius: 0.3))
            modelEntity.generateCollisionShapes(recursive: true)
            modelEntity.model?.materials = [createTexture_(drawing: uiImage.cgImage)]
            let anchorEntity4 = AnchorEntity(world: SIMD3(x:0.65,y:-0.2,z:-1.3))
            anchorEntity4.addChild(modelEntity.clone(recursive: true))
            uiView.scene.addAnchor(anchorEntity4)
            DispatchQueue.main.async {
                self.confirmed4 = nil
            }
        }
    }
    //ARモデルの表面のテクスチャを描画する関数
    func createTexture_(drawing: CGImage?) -> SimpleMaterial{
        if drawing == nil {
            return SimpleMaterial(color: .white, roughness: .float(0), isMetallic: false)
        } else {
            let texture = try! TextureResource.generate(from: drawing!, options: .init(semantic: .none))
            var material = SimpleMaterial()
            material.color = .init(texture: .init(texture))
            material.roughness = .float(0)
            material.metallic = .float(0)
            return material
        }
    }
}
