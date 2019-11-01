import SwiftUI

enum Pane: String, CaseIterable {
    case project
    case layers
    case effects
}

struct Panes {
    var panes = Pane.allCases
    var selected = Pane.project
}

enum PanesAction {
    case select(Pane)
}

func panesReducer(state: inout Panes, action: PanesAction) -> [StoreEffect<PanesAction>] {
    switch action {
        
    case let .select(val):
        state.selected = val
    }
    
    return []
}


struct PaneSwitcher: View {
    @ObservedObject var store: Store<Panes, PanesAction>
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(store.value.panes, id: \.rawValue) { pane in
                Button(action: { self.store.send(.select(pane)) }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: style.cornerRadius1).fill(self.isSelected(pane) ? style.colors.dark : Color.clear)
                        Text(pane.rawValue).modifier(PrimaryLabel())
                    }
                }
            }
        }
    }
    
    func isSelected(_ pane: Pane) -> Bool { store.value.selected == pane }
}

