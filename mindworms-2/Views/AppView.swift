import SwiftUI

struct AppView: View {
    
    @EnvironmentObject var store: Store<AppState, AppAction>
    @EnvironmentObject var style: Style
    
    var body: some View {
        VStack {
            projectsView
            layersView
            effectsView
            attributesView
            Spacer()
        }.frame(maxWidth: .infinity).background(Color.black).onAppear(perform: self.startUp)
    }

    var projectsView: some View {
        EntitiesView(
            store: store.view(
                { .init(entities: $0.activeProjects, selectedIds: $0.selectedProjects.map { $0.id }) },
                { AppAction.projects($0) }
            )
        )
    }

    var layersView: some View {
        Group {
            if !store.value.selectedProjects.isEmpty {
                EntitiesView(
                    store: store.view(
                        { .init(entities: $0.activeLayers, selectedIds: $0.selectedLayers.map { $0.id }) },
                        { AppAction.layers($0) }
                    )
                )
            } else {
                Text("no active project")
            }
        }
    }

    var effectsView: some View {
        Group {
            if !store.value.selectedLayers.isEmpty {
                EntitiesView(
                    store: store.view(
                        { .init(entities: $0.activeEffects, selectedIds: $0.selectedEffects.map { $0.id }) },
                        { AppAction.effects($0) }
                    ),
                    entityPicking: EntityPicking(choices: ["pulse", "clusters", "spin"], create: self.createEffect)
                )
            } else {
                Text("no selected layers")
            }
        }
    }
    
    var attributesView: some View {
        Group {
            if !store.value.selectedEffects.isEmpty {
                EntitiesView(
                    store: store.view(
                        { .init(entities: $0.activeAttributes, selectedIds: $0.selectedAttributes.map { $0.id }) },
                        { AppAction.attributes($0) }
                    )
                )
            } else {
                Text("no selected effects")
            }
        }
    }
    
    func createEffect(name: String) {
        if name == "pulse" {
            let effectId = UUID()
            let amountId = UUID()
            let speedId = UUID()
            
            let effect = Effect(id: effectId, name: "pulse", parameters: PulseParams())
            
            self.store.send(.effects(.insert(effect)))
            self.store.send(.effects(.selectOnly(id: effectId)))
            
            self.store.send(.attributes(.insert(Attribute(id: amountId, name: "amount", value: 0.0))))
            self.store.send(.attributes(.insert(Attribute(id: speedId, name: "speed", value: 0.0))))
        }
        if name == "clusters" {
            let effectId = UUID()
            let amountId = UUID()
            let speedId = UUID()
            
            let effect = Effect(id: effectId, name: "clusters", parameters: ClusterParams())
            
            self.store.send(.effects(.insert(effect)))
            self.store.send(.effects(.selectOnly(id: effectId)))
            
            self.store.send(.attributes(.insert(Attribute(id: amountId, name: "speed", value: 0.0))))
            self.store.send(.attributes(.insert(Attribute(id: speedId, name: "clusters", value: 0.0))))
        }
        if name == "spin" {
            let effectId = UUID()
            let amountId = UUID()
            let speedId = UUID()
            
            let effect = Effect(id: effectId, name: "spin", parameters: SpinParams())
            
            self.store.send(.effects(.insert(effect)))
            self.store.send(.effects(.selectOnly(id: effectId)))
            
            self.store.send(.attributes(.insert(Attribute(id: amountId, name: "speed", value: 0.0))))
        }
    }
 
    private func startUp() {
        let projectId = UUID()
        self.store.send(.projects(.create(id: projectId)))
        self.store.send(.projects(.select(id: projectId)))
        
        let layerId = UUID()
        self.store.send(.layers(.create(id: layerId)))
        self.store.send(.layers(.select(id: layerId)))
        
        
    }
}
