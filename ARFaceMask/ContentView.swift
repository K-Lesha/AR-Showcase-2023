import SwiftUI
import RealityKit
import ARKit
import FocusEntity

struct ContentView : View {
    
    @ObservedObject var appCoordinator: AppCoordinator
    
    init() {
        self.appCoordinator = AppCoordinator()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: ARNameAndAppearanceContentView(),
                               tag: NavigationDestination.nameAndAppearance,
                               selection: $appCoordinator.navigation) {
                    Button {
                        appCoordinator.navigateToNameAndAppearance()
                    } label: {
                        createRectangle(text: "Choose name and mask", destination: .nameAndAppearance)
                    }
                }
                
                NavigationLink(destination: ARSetObjectContentView(choosedModel: .none),
                               tag: NavigationDestination.setObject,
                               selection: $appCoordinator.navigation) {
                    Button {
                        appCoordinator.navigateToSetObject()
                    } label: {
                        createRectangle(text: "Set object on the floor", destination: .setObject)
                    }
                }
                
                NavigationLink(destination: ARVideoTagContentView(),
                               tag: NavigationDestination.videoTag,
                               selection: $appCoordinator.navigation) {
                    Button {
                        appCoordinator.navigateToVideoTag()
                    } label: {
                        createRectangle(text: "Check video tag", destination: .videoTag)
                    }
                }
                
                NavigationLink(destination: ARObjectTagContentView(),
                               tag: NavigationDestination.objectTag,
                               selection: $appCoordinator.navigation) {
                    Button {
                        appCoordinator.navigateToObjectTag()
                    } label: {
                        createRectangle(text: "Check object tag", destination: .objectTag)
                    }
                }
            }
            .navigationTitle("AR Options")
        }
    }
    
    private func createRectangle(text: String, destination: NavigationDestination) -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(appCoordinator.navigation == destination ? .green : .gray)
                .frame(width: 300, height: 50)
                .overlay(
                    Text(text)
                )
        }
    }
}

enum NavigationDestination: Hashable {
    case nameAndAppearance
    case setObject
    case objectTag
    case videoTag
}

class AppCoordinator: ObservableObject {
    @Published var navigation: NavigationDestination?
    
    init () {}
    
    func navigateToSetObject() {
        navigation = .setObject
    }
    
    func navigateToNameAndAppearance() {
        navigation = .nameAndAppearance
    }
    
    func navigateToVideoTag() {
        navigation = .videoTag
    }
    
    func navigateToObjectTag() {
        navigation = .objectTag
    }
}
