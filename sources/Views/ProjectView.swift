import SwiftUI

struct CurrentProjectView: View {
    @ObservedObject var store: Store<[Project], ProjectsAction>
    @EnvironmentObject var modal: ModalPresenter
    let onSave: () -> Void
    var body: some View {
        HStack {
            Button(action: self.showEditProject) {
                HStack {
                    Text(store.value.firstActive?.name ?? "--")
                    Image(systemName: "pencil")
                }
            }
            .buttonStyle(ButtonStyleText())
            
            Spacer()
            
            Button(action: showOptions) {
                Image(systemName: "plus").modifier(PrimaryLabel())
            }
        }
        .padding(.horizontal, style.spacing.small)
    }
    
    private func showEditProject() {
        modal.present(
            EditProjectView(store: self.store.view({ $0.selected.first }, { .selected($0) }))
        )
    }
    
    private func showOptions() {
        
        
        self.modal.present(
            VStack(spacing: style.spacing.medium) {
                Button(action: {
                    self.modal.dismiss()
                    self.createNewProject()
                }) { Text("New Project").modifier(PrimaryLabel()) }
                Button(action: {
                    self.modal.dismiss()
                    self.loadProject()
                }) { Text("Load Project").modifier(PrimaryLabel()) }
                if env.isDevMode {
                    Button(action: {
                        self.modal.dismiss()
                        self.store.send(.selectAll)
                        self.store.send(.removeSelected)
                    }) { Text("clear projects").modifier(PrimaryLabel()) }
                }
            }
        )
    }
    
    private func loadProject() {
        let v = ChooseProjectView(projects: store.value) {
            self.modal.dismiss()
            self.store.send(.deselectAll)
            self.store.send(.select(id: $0))
        }
        
        self.modal.present(v)
    }
    
    private func createNewProject() {
        let id = genID()
        store.send(.deselectAll)
        store.send(.create(id: id))
        store.send(.select(id: id))
        store.send(.update(id, .changeName(name: "untitled \(store.value.count)")))
        let layerId = genID()
        store.send(.update(id, .layers(.create(id: layerId))))
        store.send(.update(id, .layers(.select(id: layerId))))
    }
}


struct EditProjectView: View {
    @ObservedObject var store: Store<Project?, ProjectAction>
    @EnvironmentObject var modalPresenter: ModalPresenter
    
    var body: some View {
        Group {
            if store.value == nil {
                Text("no active project")
            } else {
                self.view(project: store.value!)
            }
        }
    }
    
    func view(project: Project) -> some View {
        VStack(alignment: .center) {
            
            Spacer()
                .layoutPriority(1)
            TextField(
                "project",
                text: store.send(
                    { _ in project.name },
                    { .changeName(name: $0) }
                )
            ).textFieldStyle(RoundedBorderTextFieldStyle())
            
            MySlider(
                title: "width",
                amount: project.settings.width,
                update: { self.store.send(.settings(.updateWidth(val: $0))) }
            )
            .layoutPriority(-1)
            
            MySlider(
                title: "height",
                amount: project.settings.height,
                update: { self.store.send(.settings(.updateHeight(val: $0))) }
            )
                .layoutPriority(-1)
            
//            Spacer().layoutPriority(1)
            
//            Button(action: { self.modalPresenter.dismiss() }) {
//                Text("Done")
//            }.buttonStyle(ButtonStyleText2())
            
            Spacer()
            .layoutPriority(1)
        }
        .padding(style.spacing.medium)
    }
}

struct ChooseProjectView: View {
    let projects: [Project]
    let result: (Int) -> Void
    
    var body: some View {
        
//        ScrollView {
        VStack(alignment: .leading) {
                ForEach(projects) { project in
                    VStack {
                        Text(project.name).modifier(PrimaryLabel())
                        ProjectRenderingView(project: project, framerate: 10)
                            .frame(height: 100)
                            .border(style.colors.lightest)
                            .onTapGesture {
                                self.result(project.id)
                        }.padding(style.spacing.medium)
                    }
                }
//            }
            Spacer()
            }
//            .frame(maxHeight: .infinity)
//            .background(Color.blue)
    }
}
