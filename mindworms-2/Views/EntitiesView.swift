import SwiftUI

protocol Named {
    var name: String { get }
}

struct EntityPicking {
    let choices: [String]
    let create: (String) -> Void
}

private struct EntityPickingView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let entityNames: [String]
    let didSelect: (String) -> Void

    var body: some View {
        VStack {
            ForEach(entityNames) { entity in
                ItemView(title: entity) {
                    self.presentationMode.wrappedValue.dismiss()
                    self.didSelect(entity)
                }
            }
        }.background(Color.black)
    }
}

protocol ListTitled { var title: String { get } }

//extension Workspace: ListTitled { var title: String { "w: \(id)" } }
extension Project: ListTitled { var title: String { "p: \(id)" } }
extension Layer: ListTitled { var title: String { "l: \(id)" } }
extension Effect: ListTitled { var title: String { "\(name)" } }
extension Attribute: ListTitled { var title: String { "a: \(id)" } }

typealias EntityType = Identifiable & Selectable & ListTitled

struct EditEntitiesView<Entity: EntityType, Action>: View {
    let genID: () -> Entity.ID
    @ObservedObject var store: Store<Void, ListAction<Entity, Action, Entity.ID>>
    
    @EnvironmentObject var style: Style
    @State var showPickerModal = false
    
    var entityPicking: EntityPicking? = nil
    
    var body: some View {
        HStack(spacing: 0) {
            ItemView(title: "+") { self.add() }
            ItemView(title: "-") { self.delete() }
        }.sheet(isPresented: $showPickerModal, content: { self.entityPickingView.environmentObject(self.style) })
    }

    private func add() {

        if entityPicking != nil {
            self.showPickerModal = true
            return
        }

        let id = genID()
        self.store.send(.create(id: id))
        self.store.send(.deselectAll)
        self.store.send(.select(id: id))
    }

    private func delete() {
        self.store.send(.removeSelected)
    }

    var entityPickingView: some View {
        if let picking = self.entityPicking {
            return EntityPickingView(entityNames: picking.choices) { choice in
                picking.create(choice)
            }
        } else {
            fatalError()
        }
    }
}

struct EntitiesView<Entity: EntityType, Action>: View {
    
    @ObservedObject var store: Store<[Entity], ListAction<Entity, Action, Entity.ID>>
    
    let empty: String
    
    var body: some View {
        ScrollView {
            HStack(spacing: 0) {
                if store.value.isEmpty {
                    Text(empty)
                } else {
                    ForEach(store.value) { e in
                        ItemView(title: e.title, isSelected: e.isSelected) {
                            self.store.send(.deselectAll)
                            self.store.send(e.isSelected ? .deselect(id: e.id) : .select(id: e.id))
                        }
                    }
                }
            }
        }
    }
}
