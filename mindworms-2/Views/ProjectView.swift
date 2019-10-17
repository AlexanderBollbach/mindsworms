import SwiftUI

//
//
//
//struct ProjectView: View {
//    @ObservedObject var store: Store<Project, ProjectViewAction>
//    @EnvironmentObject var style: Style
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: style.topLevelSectionSpacing) {
//
//
//                DashboardView(store: self.store.view({ $0 }, { fatalError() }))
//
//
//            AppSection("canvas") {
//                Connected(
//                    store: self.store.view(CanvasView.sMap, CanvasView.aMap),
//                    empty: Text("no selected project"),
//                    content: { CanvasView(state: $0, send: $1) }
//                )
//            }
//            .layoutPriority(1)
//
//            AppSection("layers") {
//                LayersView(
//                    store: self.store.view(
//                        { $0.layers },
//                        {  Action.selectedProject(LayersView.actionMap($0)) }
//                    )
//                )
//            }
//
//            effectsCommandsView(store: store)
//            effectsPickerView(store: store).frame(height: 200)
//        }
//        .padding(5)
//    }
//}
//
//extension CanvasView {
//    static func sMap(_ state: Project) -> Project {
//        state
//    }
//
//    static func aMap(_ localAction: CanvasView.Action) -> ProjectView.Action {
//        switch localAction {
//        case let .project(action):
//            return ProjectView.Action.selectedProject(action)
//        case let .selectedLayer(action):
//            return ProjectView.Action.selectedProject(.layers(.updateSelected(action)))
//        }
//    }
//}
//
//func effectsCommandsView(store: Store<Project, ProjectView.Action>) -> some View {
//
//    func sMap(_ state: Project) -> [Effect]? {
//        guard let layer = state.layers.firstSelected else { return nil }
//        return layer.availableEffects
//    }
//
//    func aMap(_ localAction: EffectsAction) -> ProjectView.Action {
//        ProjectView.Action.selectedProject(.layers(.updateSelected(.effects(localAction))))
//    }
//
//    return view(
//        store: store,
//        aMap: aMap,
//        sMap: sMap,
//        content: { state, send in
//            EffectsCommandsView(availableEffects: state, send: send)
//    },
//        empty: Text("no active layer")
//    )
//}
//
//func effectsPickerView(store: Store<Project, ProjectView.Action>) -> some View {
//
//    func sMap(_ state: Project) -> EffectsPickerView.ViewState? {
//        guard let layer = state.layers.firstSelected else { return nil }
//        return .init(effects: layer.effects, availableEffects: layer.availableEffects)
//    }
//
//    func aMap(_ localAction: EffectsPickerView.Action) -> ProjectView.Action {
//        switch localAction {
//        case let .effects(action):
//            return ProjectView.Action.selectedProject(.layers(.updateSelected(.effects(action))))
//        }
//    }
//
//    return view(
//        store: store,
//        aMap: aMap,
//        sMap: sMap,
//        content: { state, send in
//            AppSection("effects") {
//                EffectsPickerView(state: state, send: send)
//            }
//    },
//        empty: Text("no active layer")
//    )
//}
//




//  AppSection("attributes") {
//                        AttributesView(
//                            store: self.store.view(
//                                { (
//                                    $0.activeEffect?.name,
//                                    $0.activeEffect?.attributes.all ?? []
//                                    ) },
//                                { $0 }
//                            )
//                        )
//                    }
