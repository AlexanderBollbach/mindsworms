import SwiftUI

struct AppView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @EnvironmentObject var modalPresenter: ModalPresenter
    
    var body: some View {
        ZStack {
            content()
                .blur(radius: modalPresenter.isPresenting ? 10.0 : 0)
                .overlay(modalPresenter.isPresenting ? Color.black.opacity(0.25) : Color.clear)
                .overlay(self.modalPresenter.isPresenting ? Color.white.opacity(0.01).onTapGesture { self.modalPresenter.dismiss() } : nil)
                .animation(.interactiveSpring())
            modalPresenter.view
        }
        .animation(.default)
    }
    
    func content() -> some View {
        VStack(spacing: style.spacing.small) {
            
            CurrentProjectView(
                store: store.view({ $0.projects }, { .projects($0) }),
                onSave: { self.store.send(.projectsPersistence(.save)) }
            )
            
            canvasSection
            
            layersSection
            
            effectsSection
            
            AttributesView(store: self.store.view({ $0.activeAttributes }, { .activeAttributes($0) }))
        }
        .padding(style.spacing.small)
        .frame(maxWidth: .infinity)
    }
    
    var canvasSection: some View {
        Section {
            VStack(spacing: 0) {
                OptionalStoreView(
                    empty: Text("no active project"),
                    content: CanvasView.init,
                    store: self.store.view({ $0.firstActiveProject }, { $0.appAction })
                )
                    .background(style.colors.mainBG)
                    .layoutPriority(1)
                
                CanvasActionsView(
                    store: self.store.view(
                        { (project: $0.firstActiveProject, presets: $0.presets.names) },
                        { $0.appAction }
                    )
                )
                    .padding(style.spacing.small)
            }
        }
        .layoutPriority(1)
    }
    
    var layersSection: some View {
        Section {
            VStack {
                HStack {
                    LayerActionsView(store: self.store.view({ $0.firstActiveProject }, { .projects(.selected($0)) }))
                    EntityList(name: "layer", emptyMessage: "no layers", store: self.store.view({ $0.activeLayers }, { .activeLayers($0) }))
                        .layoutPriority(1)
                        .frame(maxHeight: .infinity)
                    Spacer()
                }
            }
        }
    }
    
    var effectsSection: some View {
        Section {
            HStack(alignment: .center) {
                EffectActionsView(store: self.store.view({ (effects: $0.activeEffects, presets: $0.presetNames) }, { $0.appAction }))
                EntityList(name: "effect", emptyMessage: "no effects", store: self.store.view({ $0.activeEffects }, { .activeEffects($0) }))
                    .layoutPriority(1)
                    .frame(maxHeight: .infinity)
                Spacer()
            }
        }
    }
}

struct Section<Content: View>: View {
    let content: () -> Content
    var body: some View {
        ZStack {
            style.colors.dark
                .cornerRadius(style.cornerRadius1)
            content()
                .padding(style.spacing.small)
        }
    }
}
