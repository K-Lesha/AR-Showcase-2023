import Foundation
import SwiftUI
import ARKit
import RealityKit
import FocusEntity


struct ARSetObjectContentView: View {
    @State var choosedModel: ObjectsType
    
    var buttonsStack: some View {
        HStack {
            createButton(.none)
            createButton(.chair)
            createButton(.fender)
            createButton(.hub)
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ARSetObjectViewContainer(choosedModel: $choosedModel)
                .edgesIgnoringSafeArea(.all)
            buttonsStack
        }
    }
    
    func createButton(_ type: ObjectsType) -> some View {
        Button {
            choosedModel = type
        } label: {
            Image(type.rawValue)
                .resizable()
                    .frame(maxWidth: 50, maxHeight: 50)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 2))
        }

    }
}

enum ObjectsType: String {
    case none
//    case cosmos
    case chair
    case fender
    case hub
}

struct ARSetObjectViewContainer: UIViewRepresentable {
    
    @Binding var choosedModel: ObjectsType
    
    func makeUIView(context: Context) -> ARView {
        let arView = createARView(context: context)
        
        context.coordinator.view = arView
        return arView
    }
    
    func createARView(context: Context) -> ARView {
        let worldTrackingConfiguration = ARWorldTrackingConfiguration()
        worldTrackingConfiguration.isLightEstimationEnabled = true
        worldTrackingConfiguration.planeDetection = [.horizontal]
        
        let arView = ARView(frame: .zero)
        arView.session.run(worldTrackingConfiguration, options: [])
        arView.session.delegate = context.coordinator
        
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = arView.session
        coachingOverlay.goal = .horizontalPlane
        
        arView.addSubview(coachingOverlay)
        
        arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap)))
        return arView
    }
    
    
    
    func updateUIView(_ uiView: ARView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(choosedModelBinding: $choosedModel)
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        weak var view: ARView?
        var focusEntity: FocusEntity?
        @Binding var choosedModel: ObjectsType

        init(choosedModelBinding: Binding<ObjectsType>) {
            self._choosedModel = choosedModelBinding
        }
        
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            guard let view else { return }
            
            self.focusEntity = FocusEntity(on: view,
                                           style: .classic(color: .orange))
        }
        
        @objc func handleTap() {
            setAnObject()
        }
        
        func setAnObject() {
            guard let view,
                  let focusEntity
            else {
                return
            }
            let anchor = AnchorEntity()
            view.scene.anchors.append(anchor)
                        
            switch choosedModel {
                case .none:
                    break
                case .chair:
                    let chairEntity = ObjectsEntityFactory.loadChairModel()!
                    chairEntity.position = focusEntity.position
                    anchor.addChild(chairEntity)
                case .fender:
                    let fenderEntity = ObjectsEntityFactory.loadFenderModel()!
                    fenderEntity.position = focusEntity.position
                    anchor.addChild(fenderEntity)
                case .hub:
                    let hubEntity = ObjectsEntityFactory.loadHabModel()!
                    hubEntity.position = focusEntity.position
                    anchor.addChild(hubEntity)
                }
        }
    }
}
