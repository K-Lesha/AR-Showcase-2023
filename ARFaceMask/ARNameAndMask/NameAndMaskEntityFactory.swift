import Foundation
import ARKit
import RealityKit

final class NameAndMaskEntityFactory {
    
    static func loadGlasses1Model() -> Entity? {
        let modelName = "glasses1"
        let modelEntity = try? ModelEntity.load(named: modelName)
        
        modelEntity?.position = SIMD3(0, 0.01, -0.011)
        modelEntity?.scale = SIMD3(1.1, 1.1, 1.1)
        
        return modelEntity
    }
    
    static func loadDogModel() -> Entity? {
        let modelName = "dog"
        let modelEntity = try? ModelEntity.load(named: modelName)
        
        modelEntity?.position = SIMD3(0.008, 0.01, -0.02)
        modelEntity?.scale = SIMD3(1.1, 1.15, 1.3)
        
        return modelEntity
    }
    
    static func loadBatmanModel() -> Entity? {
        let modelName = "batman"
        let modelEntity = try? ModelEntity.load(named: modelName)
        
        modelEntity?.position = SIMD3(0, 0.015, -0.025)
        modelEntity?.scale = SIMD3(1.2, 1.2, 1.2)
        
        return modelEntity
    }
    
    static func loadHatModel() -> Entity? {
        let modelName = "hat"
        let modelEntity = try? ModelEntity.load(named: modelName)
        
        modelEntity?.position = SIMD3(0, 0.00, -0.06)
        modelEntity?.scale = SIMD3(1.15, 1.0, 1.15)
        
        return modelEntity
    }
    
    static func createTextEntity(name: String) -> ModelEntity {
        let textMesh = MeshResource.generateText(name, extrusionDepth: 0.01, font: .systemFont(ofSize: 0.05), containerFrame: .zero, alignment: .center, lineBreakMode: .byCharWrapping)
        let material = SimpleMaterial(color: .green, isMetallic: true)
        let textEntity = ModelEntity(mesh: textMesh, materials: [material])
        textEntity.position = SIMD3(-0.08, 0.2, -0.03)
        return textEntity
    }
}
