//import SwiftUI
//
//struct EntitiesView<E, Action, EntityView>: View where E: Identifiable, E.ID == UUID, EntityView: View {
//
//    enum Action {
//        case create
//        case delete
//        case select(id: UUID)
//    }
//
//    let title: String?
//    let entities: Entities<E>
//    let update: (EntitiesAction<E, Action>) -> Void
//    let allowsMultipleSelection: Bool
//    let canMutate: Bool
//    let getEntityView: (E) -> EntityView
//
//    init(
//        title: String? = nil,
//        entities: Entities<E>,
//        update: @escaping (EntitiesAction<E, Action>) -> Void,
//        allowsMultipleSelection: Bool = true,
//        canMutate: Bool = true,
//        getEntityView: @escaping (E) -> EntityView
//    ) {
//        self.title = title
//        self.entities = entities
//        self.update = update
//        self.allowsMultipleSelection = allowsMultipleSelection
//        self.canMutate = canMutate
//        self.getEntityView = getEntityView
//    }
//
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: true) {
//            HStack {
//                ForEach(self.entities.all) { self.entityView(e: $0).frame(width: 105, height: 30) }
//            }
//        }
////        VStack {
////            title.map { Text($0) }
////            HStack {
////                VStack {
////                    if self.canMutate {
////                        Button(action: { self.update(.deleteSelected) }) { Text("del") }
////                        Button(action: { self.update(.create) }) { Text("add") }
////                    }
////                }
////
////                Spacer()
////            }
////        }
//        .padding()
//        .border(Color.black)
//    }
//
//    func entityView(e: E) -> some View {
//        getEntityView(e)
//            .padding()
//            .background(self.entities.selected.contains(e.id) ? Color.red : Color.white.opacity(0.2))
//            .frame(minHeight: 0, maxHeight: 50)
//            .border(Color.black)
//            .onTapGesture {
//                if !self.allowsMultipleSelection { self.update(.deselectAll) }
//                self.update(.select(id: e.id))
//        }
//    }
//}
