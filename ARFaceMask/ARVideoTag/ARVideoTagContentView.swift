import Foundation
import SwiftUI
import ARKit
import RealityKit
import FocusEntity


struct ARVideoTagContentView: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ARVideoTagViewContainer()
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ARVideoTagViewContainer: UIViewRepresentable {
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
        var avPlayer: AVPlayer?
        
        init(arView: ARView) {
            self.arView = arView
        }
        
        func setNotification() {
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: avPlayer?.currentItem, queue: nil) { (_) in
                self.avPlayer?.seek(to: CMTime.zero)
                self.avPlayer?.play()
            }
        }
        
        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
            for anchor in anchors {
                if let imgAnchor = anchor as? ARImageAnchor {
                    if imgAnchor.isTracked {
                        if avPlayer?.rate == 0 {
                            avPlayer?.play()
                            avPlayer?.isMuted = false
                        }
                    } else {
                        if (avPlayer?.rate ?? 0) > 0 {
                            avPlayer?.pause()
                            avPlayer?.isMuted = true
                        }
                    }
                }
            }
        }
        
        
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            for anchor in anchors {
                if let imgAnchor = anchor as? ARImageAnchor {
                    let anchorEntity = AnchorEntity(anchor: imgAnchor)
                    let width = Float(imgAnchor.referenceImage.physicalSize.width * 1.05)
                    let height = Float(imgAnchor.referenceImage.physicalSize.height * 1.05)
                    
                    guard let videoURL = URL(string: "https://proddapp.b-cdn.net/SK-voiceover/presenter/Tony.mp4") else {
                        print("video URL ERROR")
                        return
                    }
                    
                    let playerItem = AVPlayerItem(url: videoURL)
                    avPlayer = AVPlayer(playerItem: playerItem)
                    let videoMaterial = VideoMaterial(avPlayer: avPlayer!)
                    avPlayer?.automaticallyWaitsToMinimizeStalling = false
                    avPlayer?.play()
                    setNotification()
                    
                    let mesh: MeshResource = .generatePlane(width: width, depth: height)
                    let plainEntity = ModelEntity(mesh: mesh, materials: [videoMaterial])
                    
                    anchorEntity.addChild(plainEntity)
                    
                    arView.scene.addAnchor(anchorEntity)
                }
            }
        }
    }
}
