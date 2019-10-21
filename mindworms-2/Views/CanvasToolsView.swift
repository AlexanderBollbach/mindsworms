import SwiftUI

struct CanvasToolsView: View {
    @ObservedObject var store: Store<Project, ProjectAction>

    var body: some View {
        HStack {
            ItemView(title: "move", isSelected: self.store.value.mode == .moving) { self.store.send(.toggleMoving) }
            ItemView(title: "reset") { self.store.send(.transform(.reset)) }
            ItemView(title: "delete paths") { self.deletePaths() }
            ItemView(title: "solo") { self.solo() }
        }
    }
    
    private func solo() {
        if isSoloed == false {
            store.send(.layers(.all(.mute)))
            store.send(.layers(.selected(.unmute)))
        } else {
            store.send(.layers(.all(.unmute)))
        }
    }
    
    private var isSoloed: Bool { store.value.layers.filter { $0.isMuted }.count > 0 }
    
    private func deletePaths() {
        store.send(.layers(.selected(.paths(.selectAll))))
        store.send(.layers(.selected(.paths(.removeSelected))))
    }
}



