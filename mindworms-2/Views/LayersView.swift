import SwiftUI

//enum LayersViewAction {
//    case layers(LayersAction)
//    case selectedLayer(LayerAction)
//}

//extension LayersView {
//
//    static func actionMap(_ localAction: LayersView.Action) -> ProjectAction {
//        switch localAction {
//
//        case let .layers(action):
//            return ProjectAction.layers(action)
//
//        case let .selectedLayer(action):
//            return .layers(.updateSelected(action))
//        }
//    }
//}

//struct LayersView: View {
//    var store: Store<[Layer], LayersViewAction>
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: true) {
//            HStack {
//                HStack {
//                    ItemView(title: "-", isSelected: false) {
////                        self.store.send(.layers(LayersAction.deleteSelected))
//                    }
//                    ItemView(title: "+", isSelected: false) {
////                        let id = UUID()
////                        self.store.send(.layers(.create(id: id)))
////                        self.store.send(.layers(.selectOnly(id: id)))
//                    }
//                }
//                Text(" | ")
//                ForEach(store.value) { layer in
//                    ItemView(
//                        title: "layer",
//                        isSelected: layer.isSelected
//                    ) {
////                        self.store.send(.layers(.selectOnly(id: layer.id)))
//                    }
//                }
//            }
//        }
//    }
//}




