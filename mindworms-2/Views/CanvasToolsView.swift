import SwiftUI
//struct CanvasToolsView: View {
//    @ObservedObject var store: Store<Project, ProjectAction>
//    @State private var showAddEffectModal: Bool = false
//    @EnvironmentObject var style: Style
//    
//    var body: some View {
//        HStack {
//            ItemView(title: "move", isSelected: self.store.value.mode == .moving) {
//                self.store.send(.toggleMoving)
//            }
//            
//            ItemView(title: "reset") {
//                self.store.send(.transform(.reset))
//            }
//            
//            
//            ItemView(title: "delete paths") {
//                self.deletePaths()
//            }
//            
//            ItemView(title: "solo") {
//                self.solo()
//            }
//        }
//    }
//    
//    func solo() {
//        if isSoloed {
////            store.send(.layers(.updateAll(.unmute)))
//        } else {
////            store.send(.layers(.updateAll(.mute)))
////            store.send(.layers(.updateSelected(.unmute)))
//        }
//    }
//    
//    var isSoloed: Bool {
//        store.value.layers.filter { $0.isMuted }.count > 0
//    }
//    
//    func deletePaths() {
////        store.send(.layers(.updateSelected((.paths(.selectAll)))))
////        store.send(.layers(.updateSelected((.paths(.updateSelected(.clear))))))
//    }
//}



