import SwiftUI
import RealityKit
import ARKit

struct TakeArPhotoView : View {
    @StateObject var imageSaver = ImageSaver()
    @EnvironmentObject var imageData : ImageData
    @EnvironmentObject var locationManager : LocationManager
    @State private var isPlacing = false
    @State private var Selected:   UIImage? = nil
    @State private var Confirmed1: UIImage? = nil
    @State private var Confirmed2: UIImage? = nil
    @State private var Confirmed3: UIImage? = nil
    @State private var Confirmed4: UIImage? = nil
    @State private var isSaved  = false
    @State private var isSaved2 = false
    @State private var count = 2
    
    var body: some View {
        ZStack{
            ARViewContainer(confirmed1: self.$Confirmed1, confirmed2: self.$Confirmed2,
                            confirmed3: self.$Confirmed3, confirmed4: self.$Confirmed4)
            .ignoresSafeArea()
            .onDisappear{
                ARVariables.dismantleUIView(ARVariables.arView, coordinator: ())
            }

            if self.isPlacing { // 配置モード
                VStack{ Spacer()
                    HStack{
                        Button(action: {
                            PlaySound.instance.playSound(filename: "top")
                            self.isPlacing.toggle()
                            self.Selected = nil
                        }, label: {
                            Image(systemName: "xmark").frame(width: 60, height: 60).font(.title)
                                .background(.white.opacity(0.35)).cornerRadius(30).padding(5)
                        })
                    }
                } // Cancel
                VStack{
                    HStack{
                        Button(action: {
                            PlaySound.instance.playSound(filename: "top")
                            self.Confirmed1 = self.Selected
                            self.isPlacing.toggle()
                            self.Selected = nil
                        }, label: {
                            Image(systemName: "square.dashed").resizable().frame(width: 120, height: 120).font(.title).opacity(0.5)
                                .background(.white.opacity(0.25)).cornerRadius(30).padding(5)
                        })
                        Spacer()
                    }
                    Spacer()
                } // Confirm1 left-up
                VStack{ Spacer()
                    HStack{
                        Button(action: {
                            PlaySound.instance.playSound(filename: "top")
                            self.Confirmed2 = self.Selected
                            self.isPlacing.toggle()
                            self.Selected = nil
                        }, label: {
                            Image(systemName: "square.dashed").resizable().frame(width: 120, height: 120).font(.title).opacity(0.5)
                                .background(.white.opacity(0.25)).cornerRadius(30).padding(5)
                        })
                        Spacer()
                    }
                } // Confirm2 left-down
                VStack{
                    HStack{ Spacer()
                        Button(action: {
                            PlaySound.instance.playSound(filename: "top")
                            self.Confirmed3 = self.Selected
                            self.isPlacing.toggle()
                            self.Selected = nil
                        }, label: {
                            Image(systemName: "square.dashed").resizable().frame(width: 120, height: 120).font(.title).opacity(0.5)
                                .background(.white.opacity(0.25)).cornerRadius(30).padding(5)
                        })
                    }
                    Spacer()
                } // Confirm3 right-up
                VStack{ Spacer()
                    HStack{ Spacer()
                        Button(action: {
                            PlaySound.instance.playSound(filename: "top")
                            self.Confirmed4 = self.Selected
                            self.isPlacing.toggle()
                            self.Selected = nil
                        }, label: {
                            Image(systemName: "square.dashed").resizable().frame(width: 120, height: 120).font(.title).opacity(0.5)
                                .background(.white.opacity(0.25)).cornerRadius(30).padding(5)
                        })
                    }
                } // Confirm4 right-down
                Image(uiImage:self.Selected ?? UIImage()).resizable().scaledToFit().frame(height:80).opacity(0.5) // center
            } else { // 選択モード
                VStack{ Spacer()
                    ScrollView(.horizontal, showsIndicators:false){
                        HStack(spacing: 20){
                            ForEach(0 ..< imageData.ArModels.count, id: \.self){i in
                                Button {
                                    PlaySound.instance.playSound(filename: "selectImage")
                                    self.Selected = imageData.ArModels[i]
                                    self.isPlacing.toggle()
                                } label: {
                                    Image(uiImage: imageData.ArModels[i]).resizable()
                                        .scaledToFill().frame(maxWidth: 80 ,maxHeight: 80)
                                        .aspectRatio(1/1, contentMode: .fit).background(.white).cornerRadius(12)
                                }
                            }
                        }
                    }
                    .padding(10).background(.black.opacity(0.5))
                } // Scroll
                HStack{ Spacer()
                    VStack{ Spacer()
                        Button {
                            ARVariables.arView.snapshot(saveToHDR: false) { (image) in
                                let compressedImage = UIImage(data: (image?.pngData())!)
                                var sendData: [String:Any] = [:]
                                sendData["album_name"] = "From AR_check"
                                sendData["album_data"] = imageData.resizeImageToBase64(image: compressedImage ?? UIImage())
                                if let location = locationManager.userLocation {
                                    sendData["album_latitude"]  = location.coordinate.latitude
                                    sendData["album_longitude"] = location.coordinate.longitude
                                } else { // Default - Tokyo
                                    sendData["album_latitude"]  =  35.6809591
                                    sendData["album_longitude"] = 139.7673068
                                }
                                Task {
                                    let res = await apiAlbumPostRequest(reqBody: sendData)
                                    print("AR POST res : \(res)")
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
                            ARVariables.arView.snapshot(saveToHDR: false) { (image) in
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
            
        }
        .customBackButton()
        .onAppear {
            locationManager.setupLocationManager()
        }
    }
}

struct ARVariables{
    static var arView: ARView!
    static func dismantleUIView(_ uiView: ARView, coordinator: ()) {
        uiView.session.pause()
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var confirmed1: UIImage?
    @Binding var confirmed2: UIImage?
    @Binding var confirmed3: UIImage?
    @Binding var confirmed4: UIImage?
    
    func makeUIView(context: Context) -> ARView {
        ARVariables.arView = ARView(frame: .zero)
        return ARVariables.arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        let modelEntity = ModelEntity(mesh: MeshResource.generateBox(width: 0.5, height: 0.3, depth: 0.1))
        // let modelEntity = ModelEntity(mesh:.generateSphere(radius: 0.3))
        modelEntity.generateCollisionShapes(recursive: true)
        
        if let uiImage = self.confirmed1 {
            modelEntity.model?.materials = [createTexture(drawing: uiImage.cgImage)]
            let anchorEntity1 = AnchorEntity(world: SIMD3(x:-0.65,y:0.2,z:-1.3))
            anchorEntity1.addChild(modelEntity.clone(recursive: true))
            uiView.scene.addAnchor(anchorEntity1)
            DispatchQueue.main.async {
                self.confirmed1 = nil
            }
        }
        if let uiImage = self.confirmed2 {
            modelEntity.model?.materials = [createTexture(drawing: uiImage.cgImage)]
            let anchorEntity2 = AnchorEntity(world: SIMD3(x:-0.65,y:-0.2,z:-1.3))
            anchorEntity2.addChild(modelEntity.clone(recursive: true))
            uiView.scene.addAnchor(anchorEntity2)
            DispatchQueue.main.async {
                self.confirmed2 = nil
            }
        }
        if let uiImage = self.confirmed3 {
            modelEntity.model?.materials = [createTexture(drawing: uiImage.cgImage)]
            let anchorEntity3 = AnchorEntity(world: SIMD3(x:0.65,y:0.2,z:-1.3))
            anchorEntity3.addChild(modelEntity.clone(recursive: true))
            uiView.scene.addAnchor(anchorEntity3)
            DispatchQueue.main.async {
                self.confirmed3 = nil
            }
        }
        if let uiImage = self.confirmed4 {
            modelEntity.model?.materials = [createTexture(drawing: uiImage.cgImage)]
            let anchorEntity4 = AnchorEntity(world: SIMD3(x:0.65,y:-0.2,z:-1.3))
            anchorEntity4.addChild(modelEntity.clone(recursive: true))
            uiView.scene.addAnchor(anchorEntity4)
            DispatchQueue.main.async {
                self.confirmed4 = nil
            }
        }
    }
    //ARモデルの表面のテクスチャを描画する関数
    func createTexture(drawing: CGImage?) -> SimpleMaterial{
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
