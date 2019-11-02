import Foundation


struct Project: Identifiable, Selectable, Creatable, Codable {
    
    struct Settings: Codable {
        var width: Double
        var height: Double
    }
    
    enum ProjectMode: String, Codable {
        case drawing
        case moving
        case lasso
        
        mutating func toggleMoving() {
            if self == .moving {
                self = .drawing
            } else {
                self = .moving
            }
        }
    }
    
    let id: Int
    var name = "project"
    var transform = Transform()
    var mode: ProjectMode = .drawing
    var isSelected = false
    var layers = [Layer]()
    var settings = Settings(width: 1, height: 1)
    
    static func create(id: Int) -> Project { .init(id: id) }
}

enum ProjectAction {
    case layers(ListAction<Layer, LayerAction, Int>)
    case changeName(name: String)
    case transform(TransformAction)
    case toggleMoving
    case settings(ProjectSettingsAction)

    var layers: ListAction<Layer, LayerAction, Int>? {
        get {
            guard case let .layers(value) = self else { return nil }
            return value
        }
        set {
            guard case .layers = self, let newValue = newValue else { return }
            self = .layers(newValue)
        }
    }

    var changeName: String? {
        get {
            guard case let .changeName(value) = self else { return nil }
            return value
        }
        set {
            guard case .changeName = self, let newValue = newValue else { return }
            self = .changeName(name: newValue)
        }
    }

    var transform: TransformAction? {
        get {
            guard case let .transform(value) = self else { return nil }
            return value
        }
        set {
            guard case .transform = self, let newValue = newValue else { return }
            self = .transform(newValue)
        }
    }

    var toggleMoving: Void? {
        guard case .toggleMoving = self else { return nil }
        return ()
    }

    var settings: ProjectSettingsAction? {
        get {
            guard case let .settings(value) = self else { return nil }
            return value
        }
        set {
            guard case .settings = self, let newValue = newValue else { return }
            self = .settings(newValue)
        }
    }
}

let projectReducer: Reducer<Project, ProjectAction> = { state, action in
    switch action {

    case let .changeName(name):
        state.name = name

    case .toggleMoving:
        state.mode.toggleMoving()

    case let .transform(action):
        transformReducer(state: &state.transform, action: action)

    case let .layers(action):
        let r: Reducer<[Layer], LayersAction> = makeListReducer(layerReducer)
        let es = r(&state.layers, action)
        return [] // TODO missing effects

    case let .settings(action):
        projectSettingsReducer(state: &state.settings, action: action)
    }

    return []
}

enum ProjectSettingsAction {
    case updateWidth(val: Double)
    case updateHeight(val: Double)

    var updateWidth: Double? {
        get {
            guard case let .updateWidth(value) = self else { return nil }
            return value
        }
        set {
            guard case .updateWidth = self, let newValue = newValue else { return }
            self = .updateWidth(val: newValue)
        }
    }

    var updateHeight: Double? {
        get {
            guard case let .updateHeight(value) = self else { return nil }
            return value
        }
        set {
            guard case .updateHeight = self, let newValue = newValue else { return }
            self = .updateHeight(val: newValue)
        }
    }
}

func projectSettingsReducer(state: inout Project.Settings, action: ProjectSettingsAction) {
    switch action {
    
    case let .updateWidth(val):
        state.width = val
        
    case let .updateHeight(val):
        state.height = val
    }
}


extension Project {
    func onlyLayers(ids: [Int]) -> Project {
        var project = self
        project.layers.removeAll(where: { !ids.contains($0.id) })
        return project
    }
}
