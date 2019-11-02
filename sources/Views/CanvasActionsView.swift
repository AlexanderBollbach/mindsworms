import SwiftUI

enum CanvasActionsViewAction {
    case project(ProjectAction)
    
    var appAction: AppAction {
        switch self {
        case let .project(action):
            return .activeProjects(.selected(action))
        }
    }
}

struct CanvasActionsView: View {
    @ObservedObject var store: Store<(project: Project?, presets: [String]), CanvasActionsViewAction>
    @EnvironmentObject var modalPresenter: ModalPresenter
    let showLayers: () -> Void
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Button(action: toggleMoving) { Image(systemName: "arrow.up.arrow.down") }
                    .buttonStyle(ButtonStyleText2(isSelected: isMoving))
                
                Button(action: resetTransform) { Image(systemName: "arrow.clockwise") }
                    .buttonStyle(ButtonStyleText2())
                
                Button(action: deletePaths) { Image(systemName: "trash") }
                    .buttonStyle(ButtonStyleText2())
                
                Button(action: toggleSoloed) { Image(systemName: "s.square") }
                    .buttonStyle(ButtonStyleText2(isSelected: isSoloed))
                
                
                
                Spacer()
            }
            HStack(spacing: 0) {
                
                
                Button(action: self.undo) {
                    Image(systemName: "arrow.turn.up.left")
                        .overlay(Color.clear)
                }
                .buttonStyle(ButtonStyleText2())
                
                Button(action: self.redo) {
                    Image(systemName: "arrow.turn.up.right")
                        .overlay(Color.clear)
                }
                .buttonStyle(ButtonStyleText2())
                
                Button(action: self.showLayers) { Text("Layers") }
                    .buttonStyle(ButtonStyleText2())
            }
        }
    }
    
    private func toggleSoloed() {
        if isSoloed {
            store.send(.project(.layers(.all(.setSolo(false)))))
        } else {
            store.send(.project(.layers(.selected(.setSolo(true)))))
        }
    }
    
    private var isSoloed: Bool { store.value.project?.layers.selected.first?.isSoloed == true }
    
    private func deletePaths() {
        store.send(.project(.layers(.selected(.paths(.selectAll)))))
        store.send(.project(.layers(.selected(.paths(.removeSelected)))))
    }
    
    private func undo() { store.send(.project(.layers(.selected(.undo)))) }
    private func redo() { store.send(.project(.layers(.selected(.redo)))) }
    private func toggleMoving() { store.send(.project(.toggleMoving)) }
    private func resetTransform() { store.send(.project(.transform(.reset))) }
    private var isMoving: Bool { store.value.project?.mode == .moving }
    private func newLayer() { store.send(.project(.layers(.create(id: genID())))) }
}

