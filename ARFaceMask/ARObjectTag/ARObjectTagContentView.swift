import Foundation
import SwiftUI
import ARKit
import RealityKit
import FocusEntity

struct ARObjectTagContentView: View {
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ARObjectTagViewContainer()
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ARObjectTagViewContainer: UIViewRepresentable {
    var arView = ARView(frame: .zero)
    
    func makeCoordinator() -> Coordinator {
        Coordinator(arView: arView)
    }

    func makeUIView(context: Context) -> ARView {
        guard let trackImage = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            print("error")
            return arView
        }
        
        let config = ARImageTrackingConfiguration()
        config.maximumNumberOfTrackedImages = 1
        config.isAutoFocusEnabled = true

        config.trackingImages = trackImage
        arView.session.delegate = context.coordinator
        arView.session.run(config)
        
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
    }

    class Coordinator: NSObject, ARSessionDelegate {
        var arView: ARView

        init(arView: ARView) {
            self.arView = arView
        }
        
        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
            for anchor in anchors {
                if let imgAnchor = anchor as? ARImageAnchor {
                    if imgAnchor.isTracked {
                        print("imgAnchor DO tracked")
                    } else {
                        print("imgAnchor NOT tracked")
                    }
                }
            }
        }
        
        
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
                for anchor in anchors {
                    if let imgAnchor = anchor as? ARImageAnchor {
                        let anchorEntity = AnchorEntity(anchor: imgAnchor)
                        guard let entity = ObjectsEntityFactory.loadChairModel() else { return }
                        anchorEntity.addChild(entity)
                        arView.scene.addAnchor(anchorEntity)
                    }
                }
            }
    }
}
