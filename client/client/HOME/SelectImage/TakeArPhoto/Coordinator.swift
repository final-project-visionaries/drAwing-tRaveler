import RealityKit
import SwiftUI
import UIKit

class Coordinator: NSObject {
    weak var view: ARView?
    
    //TakeArPhotoViewからステート管理しているimageData.ArModelsをもらうための変数を定義、初期化
    let arModels : [UIImage]
    let selectedModels : [Bool]
    init(arModels : [UIImage], selectedModels : [Bool]) {
        self.arModels = arModels
        self.selectedModels = selectedModels
    }
    
    //TakeArPhotoViewをタップした後に出現させるモデルとアンカーを定義する関数
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        var placingModel = UIImage()
        for i in 0 ..< selectedModels.count{
            if selectedModels[i] == true {
                placingModel = arModels[i]
            }
        }
        guard let view = self.view else { return }
        let tapLocation = recognizer.location(in: view)
        let results = view.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .any)//.any)
        if let result = results.first {
            print("result.worldTransform : \(result.worldTransform)")
            let anchorEntity = AnchorEntity(raycastResult: result)
            print("anchorEntity.position : \(anchorEntity.position)")
            let modelEntity = ModelEntity(mesh: MeshResource.generateBox(width: 0.6, height: 0.2, depth: 0.0))
            modelEntity.generateCollisionShapes(recursive: true)
            modelEntity.model?.materials = [createTexture(drawing: arModels[0].cgImage)]//選択したモデルの0番目を表示
            anchorEntity.addChild(modelEntity)
            view.scene.addAnchor(anchorEntity)
            view.installGestures(.all, for: modelEntity)
        }
    }
    
    //出現させるARモデルの表面の写真を定義する関数
    func createTexture(drawing: CGImage?) -> SimpleMaterial{
        if drawing == nil {
            return SimpleMaterial(color: .white, roughness: .float(0), isMetallic: false)
        } else {
            let texture = try! TextureResource.generate(from: drawing!, options: .init(semantic: .normal))
            var material = SimpleMaterial()
            material.color = .init(texture: .init(texture))
            material.roughness = .float(0)
            material.metallic = .float(0)
            return material
        }
    }
}
