import SwiftUI

enum EffectActionsViewAction {
    case effects(EffectsAction)
    
    var appAction: AppAction {
        switch self {
        case let .effects(action):
            return .projects(.selected(.layers(.selected(.effects(action)))))
        }
    }
}

struct EffectActionsView: View {
    @ObservedObject var store: Store<(effects: [Effect], presets: [String]), EffectActionsViewAction>
    @EnvironmentObject var modalPresenter: ModalPresenter
    
    var body: some View {
        VStack {
            HStack {
                Button(action: self.removeEffect) { Image(systemName: "minus") }
                    .buttonStyle(ButtonStyleText2())
                
                Button(action: self.newEffect) { Image(systemName: "plus") }
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
    
    
    private func newEffect() {
        let v = SelectView(items: EffectFunctionality.effects.map { $0.key }) { result in
            self.loadEffect(name: result)
            self.modalPresenter.dismiss()
        }
        modalPresenter.present(v)
    }
    
    private func swapRight() { store.send(.effects(.swapSelected(rightLeft: true))) }
    private func swapLeft() { store.send(.effects(.swapSelected(rightLeft: false))) }
    private func removeEffect() { store.send(.effects(.removeSelected)) }
    
    
    func loadEffect(name: String) {
        if let effect = EffectFunctionality.effects[name]?.generateEffect(genID()) {
            store.send(.effects(.insert(effect)))
            store.send(.effects(.deselectAll))
            store.send(.effects(.select(id: effect.id)))
        }
    }
}
