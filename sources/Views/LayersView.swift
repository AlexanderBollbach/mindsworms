import SwiftUI

struct LayersView: View {
    @ObservedObject var store: Store<Project?, LayersAction>
    @EnvironmentObject var modalPresenter: ModalPresenter
    
    var header: some View {
        VStack {
            Text("Layers")
                .modifier(HeadingLabel())
            HStack(alignment: .center) {
                Spacer()
                
                Spacer()
                
                Button(action: {
                    self.store.send(.create(id: genID()))
                }) {
                    Image(systemName: "plus")
                }
                .buttonStyle(ButtonStyleText2())
                
                Button(action: {
                    self.store.send(.removeSelected)
                }) {
                    Image(systemName: "minus")
                }
                .buttonStyle(ButtonStyleText2())
                
                Button(action: { self.modalPresenter.dismiss() }) {
                    Text("done")
                }
                .buttonStyle(ButtonStyleText2())
            }
        }
    }
    
    func v(project: Project) -> some View {
        VStack {
            header
                .layoutPriority(-1)
            ScrollView {
                ForEach(project.layers) { layer in
                    Button(action: {
                        self.store.send(.deselectAll)
                        self.store.send(.select(id: layer.id))
                    }) {
                        LayerView(project: project, layer: layer)
                    }
                }
            }
            Spacer()
        }
        .padding(style.spacing.large)
    }
    
    var body: some View {
        Group {
            if store.value == nil {
                Text("no active project")
            } else {
                v(project: store.value!)
            }
        }.onTapGesture {
            print("did tap")
        }
    }
}

struct LayerView: View {
    let project: Project
    let layer: Layer
    
    var body: some View {
        VStack {
            ProjectRenderingView(project: project.onlyLayers(ids: [layer.id]), framerate: 10)
                .frame(height: 150)
                .padding(style.spacing.medium)
                .overlay(RoundedRectangle(cornerRadius: style.cornerRadius1).stroke(style.colors.lightest))
                .background(layer.isSelected ? style.colors.lightest.opacity(0.06) : nil)
            
        }
    }
}

