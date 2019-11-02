
import UIKit
import SwiftUI

var style: Style { env.style }


struct Env {
    let style: Style
    let isDevMode: Bool
}

let env = Env(style: Style(), isDevMode: true)

class ModalPresenter: ObservableObject {
    @Published var view: AnyView?
    
    var isPresenting: Bool { view != nil }
    
    func present<V: View>(_ view: V) {
        self.view = AnyView(view)
    }
    
    func dismiss() {
        self.view = nil
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
//
            let store = Store(initialValue: AppState(), reducer: appReducer)
//            
            let l = Layer(id: 0, name: "test", color: MyColor(), isSoloed: false, isSelected: true)
            let p = Project(id: 0, name: "test", transform: Transform(), mode: .drawing, isSelected: true, layers: [l])
//
            store.send(.projects(.insert(p)))
//            
//            store.send(.loadProjects)
//     
            window.rootViewController = UIHostingController(
                rootView: ZStack {
                    Color.clear
                        .layoutPriority(1)
                        .background(style.colors.mainBG)
                        .edgesIgnoringSafeArea(.all)
                    AppView().environmentObject(store).environmentObject(ModalPresenter()).environment(\.colorScheme, .light)
                }
                .statusBar(hidden: true)
            )
            
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}


