
import UIKit
import SwiftUI

class Style: ObservableObject {
    var appBackgroundColor = Color(.sRGB, red: 0.2, green: 0.2, blue: 0.25, opacity: 0.7)
        
    var sectionBackgroundColor = Color(.sRGB, red: 0.1, green: 0, blue: 0.1, opacity: 0.6)
    var sectionBorderColor = Color.init(.sRGB, red: 0.7, green: 0.8, blue: 0.9, opacity: 0.6)
    var sliderBGColor = Color.init(.sRGB, red: 0.8, green: 0.9, blue: 0.7, opacity: 0.6)
    var sliderFGColor = Color.init(.sRGB, red: 0.3, green: 0.3, blue: 0.4, opacity: 0.9)
    var sectionPadding = 8
    
    var topLevelSectionSpacing: CGFloat = 5.0
    var appPadding = 5
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let style = Style()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            let store = Store(initialValue: AppState(), reducer: appReducer)
            
            window.rootViewController = UIHostingController(
                rootView: AppView()
                    .environmentObject(store)
                    .environmentObject(style)
                .environment(\.colorScheme, .dark)
            )
            
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}



typealias ActionMaker = (AppState) -> AppAction?
//
//struct ActionPresets {
//
//    func preset1() -> [(AppState) -> AppAction?] {
//        project1()
////            + project2()
////            + project3()
////            + project4()
////            + project1()
////            + project2()
//    }
//
//    func project1() -> [ActionMaker] {
//        [
//            { _ in  },
////            { $0.layersAction(.createAndSelect) },
////            { $0.selectedLayerAction(.renderProps(action: .addPoint(.init(x: 0.1, y: 0.1)))) },
////            { $0.selectedLayerAction(.renderProps(action: .addPoint(.init(x: 0.9, y: 0.9)))) },
////            { $0.selectedLayerAction(.selectEffect(name: "shake" )) },
////            { $0.selectedEffectAction(.updateAttribute(name: "amount", value: 0.5)) },
////            { $0.selectedLayerAction(.selectEffect(name: "neon" )) },
////            { $0.selectedEffectAction(.updateAttribute(name: "amount", value: 0.5)) },
////            { $0.selectedEffectAction(.updateAttribute(name: "speed", value: 0.5)) }
//        ]
//    }
//
//
//}
//
//
