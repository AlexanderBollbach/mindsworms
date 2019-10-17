import SwiftUI

protocol ListTitleDisplayable {
    var name: String { get }
}

extension Project: ListTitleDisplayable { }
extension Layer: ListTitleDisplayable { }
extension Effect: ListTitleDisplayable { }
extension Attribute: ListTitleDisplayable { }

struct EntitiesViewState<E: Identifiable> where E.ID == UUID {
    let entities: [E]
    let selectedIds: [UUID]
    
    func isEntitySelected(e: E) -> Bool {
        selectedIds.contains(e.id)
    }
}

struct EntityPicking<E> {
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

struct EntitiesView<E: Identifiable & ListTitleDisplayable>: View where E.ID == UUID {
    
    @ObservedObject var store: Store<EntitiesViewState<E>, CrudAction<E>>
    
    @EnvironmentObject var style: Style
    
    @State var showPickerModal = false
    
    var allowsMultipleSelection = false
    
    var entityPicking: EntityPicking<E>? = nil
    
    var body: some View {
        HStack {
            ItemView(title: "+") { self.add() }
            ItemView(title: "-") { self.delete() }
            
            ForEach(store.value.entities) { e in
                ItemView(title: e.name, isSelected: self.store.value.isEntitySelected(e: e)) {
                    self.select(e: e)
                }
            }
        }.sheet(isPresented: $showPickerModal, content: { self.entityPickingView.environmentObject(self.style) })
    }
    
    private func add() {
        
        if entityPicking != nil {
            self.showPickerModal = true
            return
        }
        
        self.deselectAll()
        let id = UUID()
        self.store.send(.create(id: id))
        self.store.send(.select(id: id))
    }
    
    private func select(e: E) {
        
        let isSelected = self.store.value.isEntitySelected(e: e)
        
        if !self.allowsMultipleSelection {
            self.deselectAll()
        }
        
        if isSelected {
            self.store.send(.deselect(id: e.id))
        } else {
            self.store.send(.select(id: e.id))
        }
    }
    
    private func deselectAll() {
        for id in self.store.value.selectedIds {
            self.store.send(.deselect(id: id))
        }
    }
    
    private func delete() {
        for id in self.store.value.selectedIds {
            self.store.send(.remove(id: id))
        }
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

