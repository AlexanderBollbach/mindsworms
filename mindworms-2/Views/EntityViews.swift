import SwiftUI

// MARK: - layers -

struct LayersView: View {
    @ObservedObject var store: Store<[Layer], LayersAction>
    
    var body: some View {
        HStack {
            EditEntitiesView(
                genID: genID,
                store: store.view({ _ in () }, { $0 })
            )
            EntitiesView(store: store, empty: "no active layers")
        }
    }
}

// MARK: - attributes -

struct AttributesView: View {
    @ObservedObject var store: Store<[Attribute], AttributesAction>
    
    var body: some View {
        return HStack {
            if store.value.isEmpty {
                Text("no active attributes")
            } else {
                HStack {
                    ForEach(store.value) { attribute in
                        MySlider(title: attribute.name, amount: attribute.value) {
                            self.store.send(.update(attribute.id, .changeValue($0)))
                        }
                    }
                }
            }
        }
    }
}

// MARK: - projects -



// MARK: - workspaces -

//struct WorkspacesView: View {
//    @ObservedObject var store: Store<[Workspace], WorkspacesAction>
//
//    var body: some View {
//        HStack {
//            EditEntitiesView(
//                genID: genID,
//                store: store.view({ _ in () }, { $0 })
//            )
//            EntitiesView(store: store, empty: "no active workspaces")
//        }
//    }
//}
