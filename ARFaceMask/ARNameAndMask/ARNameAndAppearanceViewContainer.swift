import Foundation
import SwiftUI
import ARKit
import RealityKit
import FocusEntity

struct ARNameAndAppearanceContentView: View {
    @State private var name: String = "_____"
    @State private var isShowingNameEditingSet: Bool = false {
        didSet {
            if isShowingNameEditingSet {
                name = ""
            }
        }
    }
    @FocusState private var textFieldFocus: String?
    
    @State var selectedMaskType: MaskType = .none
    @State var isShowingChangeMaskSet: Bool = false
    
    var arContainer: some View {
        ARNameAndAppearanceViewContainer(name: $name, maskType: $selectedMaskType)
            .edgesIgnoringSafeArea(.all)
    }
    
    var nameEditButton: some View {
        Button {
            isShowingNameEditingSet = true
            textFieldFocus = "nameTextField"
        } label: {
            Rectangle()
                .frame(width: 200, height: 50)
                .foregroundColor(.blue)
                .overlay (
                    Text("Change name")
                        .foregroundColor(.white)
                )
        }
    }
    
    var nameEditingSet: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    textFieldFocus = nil
                    isShowingNameEditingSet = false

                }, label: {
                    Rectangle()
                        .frame(width: 200, height: 50)
                        .foregroundColor(.green)
                        .overlay (
                            Text("Save")
                                .foregroundColor(.white)
                        )
                })
                .padding()
            }
            Spacer()
            TextField("Enter Name", text: $name)
                .focused($textFieldFocus, equals: "nameTextField")
                .frame(maxWidth: 0)
        }
    }
    
    var maskButton: some View {
        Button {
            isShowingChangeMaskSet.toggle()
        } label: {
            Rectangle()
                .frame(width: 200, height: 50)
                .foregroundColor(.blue)
                .overlay (
                    Text("Change mask")
                        .foregroundColor(.white)
                )
        }
    }
    
    var maskEditingSet: some View {
        ZStack(alignment: .topTrailing) {
            Button {
                isShowingChangeMaskSet = false
            } label: {
                Rectangle()
                    .frame(width: 200, height: 50)
                    .foregroundColor(.green)
                    .overlay (
                        Text("Save")
                            .foregroundColor(.white)
                    )
            }

            VStack {
                Spacer()
                HStack {
                    Button {
                        selectPreviousMask()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .frame(width: 100, height: 100)
                    }
                    Spacer()
                    Button {
                        selectNextMask()
                    } label: {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                            .frame(width: 100, height: 100)
                    }
                }
                Spacer()
            }
        }

    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            arContainer
            HStack {
                if !isShowingNameEditingSet, !isShowingChangeMaskSet {
                    maskButton
                    nameEditButton
                }
            }
            if isShowingNameEditingSet {
                nameEditingSet
            }
            if isShowingChangeMaskSet {
                maskEditingSet
            }
        }
    }
    
    func selectPreviousMask() {
        guard let currentIndex = MaskType.allCases.firstIndex(of: selectedMaskType) else {
            return
        }
        let previousIndex = (currentIndex - 1 + MaskType.allCases.count) % MaskType.allCases.count
        selectedMaskType = MaskType.allCases[previousIndex]
    }
    
    func selectNextMask() {
        guard let currentIndex = MaskType.allCases.firstIndex(of: selectedMaskType) else {
            return
        }
        let nextIndex = (currentIndex + 1) % MaskType.allCases.count
        selectedMaskType = MaskType.allCases[nextIndex]
    }
}

enum MaskType: CaseIterable {
    case none
    case batman
    case glasses1
    case dog
    case hat
}

struct ARNameAndAppearanceViewContainer: UIViewRepresentable {
    @Binding var name: String
    @Binding var maskType: MaskType

    func makeUIView(context: Context) -> ARView {
        guard ARFaceTrackingConfiguration.isSupported else {
            print("error face tracking is not supported")
            return ARView(frame: .zero)
        }
        let arView = createARView(context: context)
        
        let nameAnchor = createNameAnchor()
        let maskAnchor = createMaskAnchor()
       
        arView.scene.anchors.append(nameAnchor)
        arView.scene.anchors.append(maskAnchor)
        
        return arView
    }
    
    func createARView(context: Context) -> ARView {
        let faceConfiguration = ARFaceTrackingConfiguration()
        faceConfiguration.isLightEstimationEnabled = true
        
        let arView = ARView(frame: .zero)
        let session = arView.session
        session.run(faceConfiguration, options: [])

        return arView
    }
    
    func createNameAnchor() -> AnchorEntity {
        let nameAnchor = AnchorEntity(.face)
        let textEntity = NameAndMaskEntityFactory.createTextEntity(name: name)
        let nameCount = name.count
        let x: Float = Float(nameCount) / 65
        textEntity.position = SIMD3(-x, 0.15, -0.03)
        nameAnchor.addChild(textEntity)
        return nameAnchor
    }
    
    func createMaskAnchor() -> AnchorEntity {
        let maskAnchor = AnchorEntity(.face)
        
        switch maskType {
        case .none:
            return maskAnchor
        case .batman:
            if let batmanMaskEntity = NameAndMaskEntityFactory.loadBatmanModel() {
                maskAnchor.addChild(batmanMaskEntity)
            }
        case .glasses1:
            if let glassesEntity = NameAndMaskEntityFactory.loadGlasses1Model() {
                maskAnchor.addChild(glassesEntity)
            }
        case .dog:
            if let dogHeadEntity = NameAndMaskEntityFactory.loadDogModel() {
                maskAnchor.addChild(dogHeadEntity)
            }
        case .hat:
            if let hatEntity = NameAndMaskEntityFactory.loadHatModel() {
                maskAnchor.addChild(hatEntity)
            }
        }
        
        return maskAnchor
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        uiView.scene.anchors.first?.children.removeAll()
        
        if let faceAnchor = uiView.scene.anchors.first as? AnchorEntity {
            faceAnchor.addChild(createNameAnchor())
            faceAnchor.addChild(createMaskAnchor())
        }
    }
}
