import SwiftUI

//extension EffectsPickerView {
//    enum Action {
//        case effects(EffectsAction)
//    }
//    struct ViewState {
//        let effects: [Effect]
//        let availableEffects: [Effect]
//    }
//}
//
//struct EffectsPickerView: View {
//    
//    let state: ViewState
//    let send: (Action) -> Void
//    
//    @State var showModal: Bool = false
//    
//
//    func reorder(old: Int, new: Int) {
//        print(old)
//        print(new)
////        self.store.send(.effect(.swap(
////            a: self.store.value.effects[old].id,
////            b: self.store.value.effects[new].id
////            )))
//    }
//    
//    var body: some View {
//        VStack {
//            CollectionView(
//                data: self.state.effects,
//                onReorder: { self.reorder(old: $0, new: $1) }) { effect in
//                    ItemView(
//                        title: effect.name,
//                        isSelected: effect.isSelected
//                    ) {
//                        self.send(.effects(.selectOnly(id: effect.id)))
//                    }
//            }
//        }
//    }
//}
