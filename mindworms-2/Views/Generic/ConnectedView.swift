import SwiftUI


func view<S, V>(_ f: () -> S?, make: @escaping (S) -> V) -> some View where V: View {
    return Group {
        if f() != nil {
            make(f()!)
        } else {
            EmptyView()
        }
    }
}

//func view<GlobalState, LocalState, GlobalAction, LocalAction, Content: View, Empty: View>(
//    store: Store<GlobalState, GlobalAction>,
//    aMap: @escaping (LocalAction) -> GlobalAction,
//    sMap: @escaping (GlobalState) -> LocalState?,
//    content: @escaping (LocalState, @escaping (LocalAction) -> Void) -> Content,
//    empty: Empty
//) -> some View {
//    
//    let subStore = store.view(sMap, aMap)
//
//    return Connected(store: subStore, empty: empty, content: content)
//}

struct Connected<State, Action, Content: View, Empty: View>: View {
    
    @ObservedObject var store: Store<State?, Action>
    
    let empty: Empty
    let content: (State, @escaping (Action) -> Void) -> Content
    
    var body: some View {
        Group {
            if store.value == nil {
                empty
            } else {
                content(self.store.value!, { self.store.send($0) })
            }
        }
    }
}

