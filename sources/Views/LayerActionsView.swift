import SwiftUI

struct LayerActionsView: View {
    @ObservedObject var store: Store<Project?, ProjectAction>
    
    var body: some View {
        VStack {
            HStack {
                Button(action: self.removeSelected) {
                    Image(systemName: "minus")
                }
                .buttonStyle(ButtonStyleText2())
                
                
                Button(action: self.newLayer) {
                    Image(systemName: "plus")
                }
                .buttonStyle(ButtonStyleText2())
            }
            HStack {
                Button(action: self.swapLeft) { Image(systemName: "arrow.uturn.left") }
                    .buttonStyle(ButtonStyleText2())
                
                Button(action: self.swapRight) { Image(systemName: "arrow.uturn.right") }
                    .buttonStyle(ButtonStyleText2())
            }
        }
    }
    
    func newLayer() {
        let id = genID()
        store.send(.layers(.create(id: id)))
        store.send(.layers(.deselectAll))
        store.send(.layers(.select(id: id)))
    }
    func removeSelected() { store.send(.layers(.removeSelected)) }
    func swapLeft() { store.send(.layers(.swapSelected(rightLeft: false))) }
    func swapRight() { store.send(.layers(.swapSelected(rightLeft: true))) }
}
