import Foundation

// MARK: - app -

enum AppAction {
    case projects(CrudAction<Project>)
    case layers(CrudAction<Layer>)
    case effects(CrudAction<Effect>)
    case attributes(CrudAction<Attribute>)
}

func appReducer(state: inout AppState, action: AppAction) {
    switch action {
        
    case let .projects(action):
        projectsReducer(state: &state.projects, action: action)
        
    case let .layers(action):
        layersReducer(state: &state.layers, action: action)
        
    case let .effects(action):
        effectsReducer(state: &state.effects, action: action)
        
    case let .attributes(action):
        attributesReducer(state: &state.attributes, action: action)
    }
    
    relationsReducer(state: &state, action: action)
}

enum CrudAction<E: Identifiable> where E.ID == UUID {
    case insert(E)
    case create(id: UUID)
    case remove(id: UUID)
    case select(id: UUID)
    case selectOnly(id: UUID)
    case deselect(id: UUID)
}

// MARK: - relations -

func relationsReducer(state: inout AppState, action: AppAction) {
    
    switch action {
    case let .projects(action):
        
        switch action {
        case let .create(id):
            state.workspaces.update(isSelected: { _ in true }) { $0.projects.connect(id) }
        case let .select(id):
            state.workspaces.update(isSelected: { _ in true }) { $0.projects.select(id) }
        case let .deselect(id):
            state.workspaces.update(isSelected: { _ in true }) { $0.projects.deselect(id) }
        case let .remove(id):
            state.workspaces.update(isSelected: { _ in true }) { $0.projects.disconnect(id) }
        case let .insert(e):
            state.workspaces.update(isSelected: { _ in true }) { $0.projects.connect(e.id) }
        case let .selectOnly(id):
            state.workspaces.update(isSelected: { _ in true }) { $0.projects.selectOnly(id) }
        }
    case let .layers(action):
        let es = state.selectedProjects.map { $0.id }
        func pred<E: Identifiable>(e: E) -> Bool where E.ID == UUID {
            es.contains(e.id)
        }
        
        switch action {
        case let .create(id):
            state.projects.update(isSelected: pred) { $0.layers.connect(id) }
        case let .select(id):
            state.projects.update(isSelected: pred) { $0.layers.select(id) }
        case let .deselect(id):
            state.projects.update(isSelected: pred) { $0.layers.deselect(id) }
        case let .remove(id):
            state.projects.update(isSelected: pred) { $0.layers.disconnect(id) }
        case let .insert(e):
            state.projects.update(isSelected: pred) { $0.layers.connect(e.id) }
        case let .selectOnly(id):
            state.projects.update(isSelected: pred) { $0.layers.selectOnly(id) }
        }
        
    case let .effects(action):
        let es = state.selectedLayers.map { $0.id }
        func pred<E: Identifiable>(e: E) -> Bool where E.ID == UUID {
            es.contains(e.id)
        }
        
        switch action {
        case let .create(id):
            state.layers.update(isSelected: pred) { $0.effects.connect(id) }
        case let .select(id):
            state.layers.update(isSelected: pred) { $0.effects.select(id) }
        case let .deselect(id):
            state.layers.update(isSelected: pred) { $0.effects.deselect(id) }
        case let .remove(id):
            state.layers.update(isSelected: pred) { $0.effects.disconnect(id) }
        case let .insert(e):
            state.layers.update(isSelected: pred) { $0.effects.connect(e.id) }
        case let .selectOnly(id):
            state.layers.update(isSelected: pred) { $0.effects.selectOnly(id) }
        }
        
    case let .attributes(action):
        let es = state.selectedEffects.map { $0.id }
        func pred<E: Identifiable>(e: E) -> Bool where E.ID == UUID {
            es.contains(e.id)
        }
        
        switch action {
        case let .create(id):
            state.effects.update(isSelected: pred) { $0.attributes.connect(id) }
        case let .select(id):
            state.effects.update(isSelected: pred) { $0.attributes.select(id) }
        case let .deselect(id):
            state.effects.update(isSelected: pred) { $0.attributes.deselect(id) }
        case let .remove(id):
            state.effects.update(isSelected: pred) { $0.attributes.disconnect(id) }
        case let .insert(e):
            state.effects.update(isSelected: pred) { $0.attributes.connect(e.id) }
        case let .selectOnly(id):
            state.effects.update(isSelected: pred) { $0.attributes.selectOnly(id) }
        }
    }
}


// MARK: - projects -

func projectsReducer(state: inout [Project], action: CrudAction<Project>) {
    switch action {
        
    case let .create(id):
        state.append(Project(id: id))
        
    case let .remove(id):
        state.removeAll(where: { $0.id == id })
        
    default:
        break
    }
}

// MARK: - project -

enum ProjectAction {
    case changeName(name: String)
    case transform(TransformAction)
    case toggleMoving
}

func projectReducer(state: inout Project, action: ProjectAction) {
    switch action {
        
    case let .changeName(name):
        state.name = name
        
    case let .transform(action):
        transformReducer(state: &state.transform, action: action)
        
    case .toggleMoving:
        state.mode.toggleMoving()
    }
}


// MARK: - layers -

func layersReducer(state: inout [Layer], action: CrudAction<Layer>) {
    switch action {
        
    case let .create(id):
        state.append(Layer(id: id))
        
    case let .remove(id):
        state.removeAll(where: { $0.id == id })
        
    default:
        break
    }
}

// MARK: - layer -

enum LayerAction {
    case mute
    case unmute
}

func layerReducer(state: inout Layer, action: LayerAction) {
    switch action {
        
    case .mute:
        state.isMuted = true
        
    case .unmute:
        state.isMuted = false
    }
}

// MARK: - effects -

func effectsReducer(state: inout [Effect], action: CrudAction<Effect>) {
    switch action {
        
    case let .create(id):
        state.append(Effect(id: id))
        
    case let .insert(val):
        state.append(val)
        
    case let .remove(id):
        state.removeAll(where: { $0.id == id })
        
    default:
        break
    }
}

// MARK: - attributes -

func attributesReducer(state: inout [Attribute], action: CrudAction<Attribute>) {
    switch action {
        
    case let .create(id):
        state.append(Attribute(id: id))
        
    case let .remove(id):
        state.removeAll(where: { $0.id == id })
        
    case let .insert(val):
        state.append(val)
        
    default:
        break
    }
}


// MARK: - transform -

enum TransformAction {
    case startZoom(Double)
    case updateZoom(Double)
    case startTranslate(Point)
    case updateTranslate(Point)
    case reset
}

func transformReducer(state: inout Transform, action: TransformAction) {
    switch action {
        
    case let .startZoom(value):
        state.startZoom(amount: value)
        
    case let .updateZoom(value):
        state.updateZoom(amount: value)
        
    case let .startTranslate(value):
        state.startTranslate(point: value)
        
    case let .updateTranslate(value):
        state.updateTranslate(point: value)
        
    case .reset:
        state.reset()
    }
}








//
//func attributeReducer(state: inout Attribute, action: AttributeAction) {
//    switch action {
//
//    case let .changeValue(val):
//        state.value = val
//    }
//}
//
//func effectReducer(state: inout Effect, action: EffectAction) {
//    switch action {
//
//    case let .attributes(action):
//        makeListReducer(baseReducer: attributeReducer)(&state.attributes, action)}
//}
//
//func pathReducer(state: inout MyPath, action: PathAction) {
//    switch action {
//
//    case let .addPoint(val):
//        state.points.append(val)
//
//    case .clear:
//        state.points = []
//    }
//}



//enum PresetAction {
//    case addPreset
//    case removePreset
//    case applyPresetToSelectedLayer
//}


//typealias ProjectsAction = ListAction<Project, ProjectAction>
//typealias LayersAction = ListAction<Layer, LayerAction>
//typealias EffectsAction = ListAction<Effect, EffectAction>
//typealias AttributesAction = ListAction<Attribute, AttributeAction>
//typealias MyPathsAction = ListAction<MyPath, PathAction>



//enum EffectAction {
//    case attributes(AttributesAction)
//}
//
//enum AttributeAction {
//    case changeValue(Double)
//}

//
//enum PathAction {
//    case addPoint(Point)
//    case clear
//}
//

// MARK: - Selectors -


extension AppState {
    
    var activeProjects: [Project] {
        let ids = workspaces.flatMap { $0.projects.ids }
        return projects.filter { ids.contains($0.id) }
    }
    
    var selectedProjects: [Project] {
        let ids = workspaces.flatMap { $0.projects.selected }
        return projects.filter { ids.contains($0.id) }
    }
    
    var activeLayers: [Layer] {
        let ids = selectedProjects.flatMap { $0.layers.ids }
        return layers.filter { ids.contains($0.id) }
    }
    
    var selectedLayers: [Layer] {
        let ids = selectedProjects.flatMap { $0.layers.selected }
        return layers.filter { ids.contains($0.id) }
    }
    
    var activeEffects: [Effect] {
        let ids = selectedLayers.flatMap { $0.effects.ids }
        return effects.filter { ids.contains($0.id) }
    }
    
    var selectedEffects: [Effect] {
        let ids = selectedLayers.flatMap { $0.effects.selected }
        return effects.filter { ids.contains($0.id) }
    }
    
    var activeAttributes: [Attribute] {
        let ids = selectedEffects.flatMap { $0.attributes.ids }
        return attributes.filter { ids.contains($0.id) }
    }
    
    var selectedAttributes: [Attribute] {
        let ids = selectedEffects.flatMap { $0.attributes.selected }
        return attributes.filter { ids.contains($0.id) }
    }
}


extension Array where Element: Identifiable {
    mutating func update(isSelected: (Element) -> Bool, f: (inout Element) -> Void) {
        for i in 0..<count {
            if isSelected(self[i]) {
                f(&self[i])
            }
        }
    }
}
