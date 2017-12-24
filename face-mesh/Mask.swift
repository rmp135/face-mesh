import ARKit
import SceneKit

protocol MaskDelegate: class {
    var isWireframe: Bool { get set }
    var isPhysicalLighting: Bool { get set }
}

class Mask: SCNNode, MaskDelegate {
    var isWireframe: Bool = false {
        didSet {
            material.fillMode = isWireframe ? .lines : .fill
        }
    }
    
    var isPhysicalLighting: Bool = true {
        didSet {
            material.lightingModel = isPhysicalLighting ? .physicallyBased : .blinn
        }
    }

    var material: SCNMaterial
    
    init(geometry: ARSCNFaceGeometry) {
        material = geometry.firstMaterial!

        material.diffuse.contents = UIColor.lightGray
        material.fillMode = .fill
        material.lightingModel = .physicallyBased
        
        super.init()
        self.geometry = geometry
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    func update(withFaceAnchor anchor: ARFaceAnchor) {
        let faceGeometry = geometry as! ARSCNFaceGeometry
        faceGeometry.update(from: anchor.geometry)
    }
}
