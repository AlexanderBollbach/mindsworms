import SwiftUI

//protocol ResultView: View {
//    associatedtype Result
//    var done: (Result) -> Void { get set }
//}
//
//struct MyModel<Content: View, Modal: ResultView, Result>: View where Modal.Result == Result {
//    @State private var showModal: Bool = false
//    let modal: Modal
//    let onFinish: (Result) -> Void
//    let content: Content
//    var body: some View {
//        content.sheet(isPresented: $showModal) {
//                self.modal.onFinish = { onFinish() }
//        }
//    }
//}

//
struct PresetLoaderView: View {
    
    let names: [String]
    let done: (String) -> Void
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack {
            ForEach(names) { name in
                ItemView(title: name) {
                    self.presentationMode.wrappedValue.dismiss()
                    self.done(name)
                }
            }
        }.background(Color.black)
    }
}


struct PresetSaverView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var text: String = ""
    
    let onFinish: (String) -> Void
    
    var body: some View {
        VStack {
            TextField("preset name: ", text: $text)
            Button("done") {
                self.onFinish(self.text)
                self.presentationMode.wrappedValue.dismiss()
            }
        }.background(Color.black)
    }
}

enum EffectsViewAction {
    case savePreset(String, [Effect])
    case loadPreset(String)
    case effects(EffectsAction)
}

extension EffectsViewAction {
    var appAction: AppAction {
        switch self {
        case let .effects(action):
            return .activeEffects(action)
        case let .savePreset(name, effects):
            return .savePreset(name: name, effects: effects)
        case let .loadPreset(name):
            return .loadPreset(name: name)
        }
    }
}

private extension EffectsAction {
    func toEffectsViewAction() -> EffectsViewAction {
        EffectsViewAction.effects(self)
    }
}

struct EffectsView: View {
    @State private var showPresetSaver = false
    @State private var showPresetLoader = false
    
    @ObservedObject var store: Store<(effects: [Effect], presetNames: [String]), EffectsViewAction>
    @EnvironmentObject var style: Style
    
    
    var body: some View {
        VStack {
            HStack {
                ItemView(title: "sp") { self.showPresetSaver = true }
                    .sheet(isPresented: $showPresetSaver) { self.savePresetsView }
                ItemView(title: "lp") { self.showPresetLoader = true }
                    .sheet(isPresented: $showPresetLoader) { self.loadPresetsView }
                EditEntitiesView(
                    genID: genID,
                    store: store.view({ _ in () }, { .effects($0) }),
                    entityPicking: EntityPicking(
                        choices: Array(EffectFunctionality.effects.keys),
                        create: self.loadEffect
                    )
                )
                            
                
                
            }
            
            EntitiesView(store: store.view({ $0.effects }, { EffectsViewAction.effects($0 )}), empty: "no active effects")

//            CollectionView(
//                data: self.store.value.effects,
//                onReorder: { a,b in
//                    print("a: \(a), b: \(b)")
//                    self.store.send(.effects(.reorder(id1: a, id2: b)))
//            }
//            ) { effect in
//                ItemView(
//                    title: effect.name,
//                    isSelected: effect.isSelected
//                ) {
//                    self.store.send(.effects(.deselectAll))
//                    self.store.send(.effects(.select(id: effect.id)))
//                }
//            }.frame(height: 150).background(Color.blue.opacity(0.5))
        }
    }
    
    private var savePresetsView: some View {
        PresetSaverView() { self.store.send(.savePreset($0, self.store.value.effects)) }
    }
    
    private var loadPresetsView: some View {
        PresetLoaderView(names: self.store.value.presetNames, done: { val in self.store.send(.loadPreset(val)) }).environmentObject(style)
    }
    
    func loadEffect(name: String) {
        if
            let effect = EffectFunctionality.effects[name]?.generateEffect(genID())
        {
            store.send(.effects(.insert(effect)))
            store.send(.effects(.deselectAll))
            store.send(.effects(.select(id: effect.id)))
        }
    }
}

//extension EffectsPickerView {
//    enum Action {
//        case effects(EffectsAction)
//    }
//    struct ViewState {
//        let effects: [Effect]
//        let availableEffects: [Effect]
//    }
//}

//struct EffectsPickerView: View {
//
////    let state: ViewState
////    let send: (Action) -> Void
////
////    @State var showModal: Bool = false
//
//
//    func reorder(old: Int, new: Int) {
//        print(old)
//        print(new)
////        self.store.send(.effect(.swap(
////            a: self.store.value.effects[old].id,
////            b: self.store.value.effects[new].id
////            )))
//    }
//
//    var body: some View {
//        VStack {
//
//        }
//    }
//}
