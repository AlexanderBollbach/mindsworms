import SwiftUI

struct CurrentProjectView: View {
    @ObservedObject var store: Store<Project?, ProjectAction>
    
    var body: some View {
        HStack {
            TextField(
                "project",
                text: store.send(
                    { $0?.name ?? "--" },
                    { .changeName(name: $0) }
                )
            )
        }.background(Color.green)
    }
}

struct ChooseProjectView: View {
    @ObservedObject var store: Store<[Project], ProjectsAction>
    
    var body: some View {
        HStack {
            VStack {
                ForEach(store.value) { project in
                    Text(project.name).onTapGesture {
                        self.store.send(.deselectAll)
                        self.store.send(.select(id: project.id))
                    }
                }
                ItemView(title: "+") {
                    self.store.send(.create(id: genID()))
                }
            }
//            EntitiesView(
//                store: store,
//                empty: "no active projects"
//            )
        }.background(Color.green)
    }
}

struct ProjectManagementView: View {
    @ObservedObject var store: Store<[Project], ListAction<Project, ProjectAction, Int>>
    @State var showModal1 = false
    @EnvironmentObject var style: Style
    
    var body: some View {
        ItemView(title: store.value.first(where: { $0.isSelected })?.name ?? "--") {
            self.showModal1 = true
        }
        .sheet(isPresented: $showModal1) { self.editProjectsView.environmentObject(self.style) }
    }
    
    var editProjectsView: some View {
        VStack {
            CurrentProjectView(store: store.view({ $0.firstActive }, { (.selected($0)) }))
            ChooseProjectView(store: store.view({ projects in projects.filter { project in project.id != projects.firstActive?.id } }, { $0 }))
        }
    }
}

struct AppView: View {
    
    @EnvironmentObject var store: Store<AppState, AppAction>
    @EnvironmentObject var style: Style
    
    var body: some View {
        VStack {
            canvasView
            
            layersView
            effectsView
            attributesView
            
            canvasToolsView
            
            ProjectManagementView(store: store.view({ $0.projects }, { .activeProjects($0) }))
        }
        .frame(maxWidth: .infinity)
            
            //        .edgesIgnoringSafeArea(.all)
            .statusBar(hidden: true)
            .background(Color.black)
            .onAppear(perform: self.startUp)
    }
    
    var attributesView: some View {
        AttributesView(
            store: store.view({ $0.activeAttributes }, { .activeAttributes($0) })
        )
    }
    
    var layersView: some View {
        LayersView(
            store: store.view({ $0.activeLayers }, { .activeLayers($0) })
        )
    }
    
    var effectsView: some View {
        EffectsView(
            store: store.view(
                { (effects: $0.activeEffects, presetNames: $0.presetNames) },
                { $0.appAction }
            )
        )
    }
    
    var canvasToolsView: some View {
        OptionalStoreView(
            empty: Text("no active project"),
            content: CanvasToolsView.init,
            store: store.view({ $0.firstActiveProject }, { .activeProjects(.selected($0)) })
        )
    }
    
    var canvasView: some View {
        OptionalStoreView(
            empty: Text("no active project"),
            content: CanvasView.init,
            store: store.view({ $0.firstActiveProject }, { $0.toAppAction })
        )
            .layoutPriority(1)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.green)
    }
    
    private func startUp() {
        
        let l = Layer(id: 0, name: "test", color: MyColor(), isMuted: false, isSelected: true)
        let p = Project(id: 0, name: "test", transform: Transform(), mode: .drawing, isSelected: true, layers: [l])
        //        let w = Workspace(id: 0, projects: [p], name: "test", isSelected: true)
        
        let es: [Effect] = EffectFunctionality.effects.enumerated().map { val in
            let id = val.offset
            return val.element.value.generateEffect(id)
        }
        
        store.send(.savePreset(name: "basic", effects: es))
        store.send(.projects(.insert(p)))
        store.send(.loadPreset(name: "basic"))
    }
}


