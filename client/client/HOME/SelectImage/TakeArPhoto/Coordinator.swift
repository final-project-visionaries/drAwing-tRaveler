import Foundation
import RealityKit
import SwiftUI

class Coordinator: NSObject {
    weak var view: ARView?
    
    //TakeArPhotoViewからステート管理しているimageData.ArModelsをもらうための変数を定義、初期化
    var arData : [UIImage]
    init(arData : [UIImage]) {
            self.arData = arData
        }
    
    //TakeArPhotoViewをタップした後に出現させるモデルとアンカーを定義する関数
    @MainActor @objc func handleTap(_ recognizer: UITapGestureRecognizer) {

        guard let view = self.view else { return }
        let tapLocation = recognizer.location(in: view)
        let results = view.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .any)
        if let result = results.first {
            let anchorEntity = AnchorEntity(raycastResult: result)
            let modelEntity = ModelEntity(mesh: MeshResource.generateBox(width: 0.6, height: 0.2, depth: 0.0))
            modelEntity.generateCollisionShapes(recursive: true)
            modelEntity.model?.materials = [createTexture(drawing:arData[0].cgImage)]
            anchorEntity.addChild(modelEntity)
            view.scene.addAnchor(anchorEntity)
            view.installGestures(.all, for: modelEntity)
        }
    }
    
    //出現させるARモデルの表面の写真を定義する関数
    func createTexture(drawing: CGImage?) -> SimpleMaterial{
        if drawing == nil {
            return SimpleMaterial(color: .white, roughness: .float(0), isMetallic: false)
        }
        else
        {
            let texture = try! TextureResource.generate(from: drawing!, options: .init(semantic: .normal))
            var material = SimpleMaterial()
            material.color = .init(texture: .init(texture))
            material.roughness = .float(0)
            material.metallic = .float(0)
            
            return material
        }
    }
}
