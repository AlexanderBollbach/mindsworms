import SwiftUI

enum EffectActionsViewAction {
    case effects(EffectsAction)
    case loadPreset(name: String)
    case savePreset(name: String, effects: [Effect])
    
    var appAction: AppAction {
        switch self {
        case let .effects(action):
            return .projects(.selected(.layers(.selected(.effects(action)))))
        case let .loadPreset(name):
            return .presets(.load(name: name))
        case let .savePreset(name, effects):
            return .presets(.save(name: name, effects: effects))
        }
    }
}

struct EffectActionsView: View {
    @ObservedObject var store: Store<(effects: [Effect], presets: [String]), EffectActionsViewAction>
    @EnvironmentObject var modalPresenter: ModalPresenter
    
    var body: some View {
        
        HStack {
            Button(action: self.removeEffect) { Image(systemName: "minus") }
                .buttonStyle(ButtonStyleText2())
            
            Button(action: self.newEffect) { Image(systemName: "plus") }
                .buttonStyle(ButtonStyleText2())
            
            Button(action: self.swapLeft) { Image(systemName: "arrow.uturn.left") }
                .buttonStyle(ButtonStyleText2())
            
            Button(action: self.swapRight) { Image(systemName: "arrow.uturn.right") }
                .buttonStyle(ButtonStyleText2())
            
            Button(action: self.savePreset) { Image(systemName: "doc") }
                .buttonStyle(ButtonStyleText2())
            
            Button(action: self.loadPreset) { Image(systemName: "archivebox") }
                .buttonStyle(ButtonStyleText2())
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
    
    private func savePreset() {
        
        let v = SaveWithNameView(message: "preset name", initialValue: "untitled \(store.value.presets.count)") { result in
            self.store.send(.savePreset(name: result, effects: self.store.value.effects))
            self.modalPresenter.dismiss()
        }
        modalPresenter.present(v)
    }
    
    private func loadPreset() {
        modalPresenter.present(
            VStack {
                Text("Presets").modifier(PrimaryLabel())
                ForEach(store.value.presets) { preset in
                    Button(preset) {
                        self.store.send(.loadPreset(name: preset))
                        self.modalPresenter.dismiss()
                    }.buttonStyle(ButtonStyleText2())
                }
                
                if store.value.presets.isEmpty {
                    Text("you have no saved presets").modifier(SecondaryLabel())
                }
            }
        )
    }
}
