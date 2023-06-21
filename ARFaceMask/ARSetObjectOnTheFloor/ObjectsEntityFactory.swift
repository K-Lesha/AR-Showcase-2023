import Foundation
import ARKit
import RealityKit

final class ObjectsEntityFactory {
    
    static func loadCosmosModel() -> Entity? {
        let modelName = "cosmos"
        let modelEntity = try? ModelEntity.load(named: modelName)
        
        modelEntity?.position = SIMD3(0, 0.01, -0.011)
        modelEntity?.scale = SIMD3(1.1, 1.1, 1.1)
        
        return modelEntity
    }
    
    static func loadChairModel() -> Entity? {
        let modelName = "chair"
        let modelEntity = try? ModelEntity.load(named: modelName)
        
        modelEntity?.position = SIMD3(0.008, 0.01, -0.02)
        modelEntity?.scale = SIMD3(1.1, 1.15, 1.3)
        
        return modelEntity
    }
    
    static func loadFenderModel() -> Entity? {
        let modelName = "fender"
        let modelEntity = try? ModelEntity.load(named: modelName)
        
        modelEntity?.position = SIMD3(0, 0.015, -0.025)
        modelEntity?.scale = SIMD3(1.2, 1.2, 1.2)
        
        return modelEntity
    }
    
    static func loadHabModel() -> Entity? {
        let modelName = "hab"
        let modelEntity = try? ModelEntity.load(named: modelName)
        
        modelEntity?.position = SIMD3(0, 0.00, -0.06)
        modelEntity?.scale = SIMD3(1.15, 1.0, 1.15)
        
        return modelEntity
    }
    
    static func loadTreeModel() -> Entity? {
        let modelName = "tree"
        let modelEntity = try? ModelEntity.load(named: modelName)
        
        modelEntity?.position = SIMD3(0, -4.00, -0.06)
        modelEntity?.scale = SIMD3(6.15, 6.0, 6.15)
        
        return modelEntity
    }

}
