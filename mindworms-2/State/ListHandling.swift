import Foundation

// MARK: - actions -
//
//enum ListAction<Entity, SubAction> {
//    case delete(pred: (Entity) -> Bool)
//    case create(id: UUID)
//    case add(Entity)
//    case deleteSelected
//    case selectOnly(id: UUID)
////    case updateSelected(SubAction)
//}
//
//
//// MARK: - reducer -
//
//func makeListReducer<T: Identifiable & Selectable & Creatable, A>(
//    baseReducer: @escaping (inout T, A) -> Void
//) -> (inout [T], ListAction<T, A>) -> Void
//    where T.ID == UUID {
//
//        return { state, listAction in
//            switch listAction {
//
//            case let .delete(pred):
//                state = Array(state.drop(while: { pred($0) }))
//
////            case let .updateSelected(action):
////                state.update(pred: { $0.isSelected }, t: { baseReducer(&$0, action) })
//
//            case let .create(id):
//                state.append(T.create(id: id))
//                
//            case .deleteSelected:
//                state = Array(state.drop(while: { $0.isSelected }))
//                
//            case let .selectOnly(id):
//                state.deselectAll()
//                state.select(at: id)
//                
//            case let .add(e):
//                state.append(e)
//                
//            }
//        }
//}
//
//
//
//protocol Selectable {
//    var isSelected: Bool { get set }
//}
//
//extension Selectable {
//    func selected() -> Selectable {
//        var s = self
//        s.isSelected = true
//        return s
//    }
//}

//extension Array where Element: Selectable & Identifiable, Element.ID == UUID {
//    mutating func selectAll() {
//        for i in 0..<count {
//            self[i].isSelected = true
//        }
//    }
//    
//    mutating func deselectAll() {
//        for i in 0..<count {
//            self[i].isSelected = false
//        }
//    }
//    
//    mutating func select(at id: UUID) {
//        update(pred: { $0.id == id }, t: { $0.isSelected = true })
//    }
//    
//    var firstSelected: Element? {
//        for e in self {
//            if e.isSelected {
//                return e
//            }
//        }
//        return nil
//    }
//}
//
//extension Array where Element: Identifiable & Selectable {
//   
//    mutating func update(
//        pred: (Element) -> Bool,
//        t: (inout Element) -> Void
//    ) {
//        for i in 0..<count {
//            if pred(self[i]) {
//                t(&self[i])
//            }
//        }
//    }
//}
