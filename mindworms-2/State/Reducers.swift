import Foundation


// MARK: - app -

var _idCounter = 0

func genID() -> Int {
    _idCounter += 1
    return _idCounter
}

struct AppState {
    var projects = [Project]()
    var presets = [String: [Effect]]()
}

enum AppAction {
    case projects(ListAction<Project, ProjectAction, Int>)
    
    case savePreset(name: String, effects: [Effect])
    case loadPreset(name: String)
}

func appReducer(state: inout AppState, action: AppAction) {
    switch action {
        
    case let .projects(action):
        makeListReducer(projectReducer)(&state.projects, action)

    case let .savePreset(name, effects):
        state.presets[name] = effects

    case let .loadPreset(name):
        if let effects = state.presets[name] {
            makeListReducer(projectReducer)(
                &state.projects,
                .selected(.layers(.selected(.effects(.replace(with: effects)))))
            )
        }
    }
}


// MARK: - workspace -
//
//struct Workspace: Identifiable, Creatable, Selectable, Named {
//    let id: Int
//    var projects: [Project] = []
//    var name = "w"
//    var isSelected = false
//    
//    static func create(id: Int) -> Workspace { Workspace(id: id) }
//}
//
//enum WorkspaceAction {
//    case changeName(String)
//    case projects(ListAction<Project, ProjectAction, Int>)
//}
//
//func workspaceReducer(state: inout Workspace, action: WorkspaceAction) {
//    switch action {
//    
//    case let .changeName(val):
//        state.name = val
//    
//    case let .projects(action):
//        makeListReducer(projectsReducer)(&state.projects, action)
//    }
//}

// MARK: - project -

struct Project: Identifiable, Selectable, Creatable, Named {
    
    enum ProjectMode {
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
    
    static func create(id: Int) -> Project { .init(id: id) }
}

enum ProjectAction {
    case layers(ListAction<Layer, LayerAction, Int>)
    case changeName(name: String)
    case transform(TransformAction)
    case toggleMoving
}

func projectReducer(state: inout Project, action: ProjectAction) {
    switch action {
    
    case let .changeName(name):
        state.name = name
    
    case .toggleMoving:
        state.mode.toggleMoving()
    
    case let .transform(action):
        transformReducer(state: &state.transform, action: action)
        
    case let .layers(action):
        makeListReducer(layerReducer)(&state.layers, action)
    }
}





// MARK: - layer -

struct Layer: Identifiable, Selectable, Creatable {
    let id: Int
    var name = "layer"
    var color = MyColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var isMuted = false
    var isSelected = false
    var effects = [Effect]()
    var paths = [MyPath]()
    
    static func create(id: Int) -> Layer { .init(id: id) }
}

enum LayerAction {
    case mute
    case unmute
    case effects(ListAction<Effect, EffectAction, Int>)
    case paths(ListAction<MyPath, PathAction, Int>)
}

func layerReducer(state: inout Layer, action: LayerAction) {
    switch action {
    
    case .mute:
        state.isMuted = true
    
    case .unmute:
        state.isMuted = false
    
    case let .effects(action):
        makeListReducer(effectReducer)(&state.effects, action)
        
    case let .paths(action):
        makeListReducer(pathReducer)(&state.paths, action)
    }
}


// MARK: - effect -

struct Effect: Identifiable, Selectable, Creatable {
    let id: Int
    let name: String
    var attributes: [Attribute]
    var isSelected: Bool
    
    static func create(id: Int) -> Effect { .init(id: id) }
    
    init(id: Int, name: String = "e", attributes: [Attribute] = [], isSelected: Bool = false) {
        self.id = id
        self.name = name
        self.attributes = attributes
        self.isSelected = isSelected
    }
}

enum EffectAction {
    case attributes(ListAction<Attribute, AttributeAction, Int>)
}

func effectReducer(state: inout Effect, action: EffectAction) {
    switch action {
    
    case let .attributes(action):
        makeListReducer(attributeReducer)(&state.attributes, action)
    }
}

// MARK: - attribute -

struct Attribute: Identifiable, Selectable, Creatable, Equatable {
    let id: Int
    let name: String
    var value: Double
    var isSelected: Bool
    
    init(id: Int, name: String = "attribute", value: Double = 0.0, isSelected: Bool = false) {
        self.id = id
        self.name = name
        self.value = value
        self.isSelected = isSelected
    }
    
    static func create(id: Int) -> Attribute { .init(id: id) }
}

enum AttributeAction {
    case changeValue(Double)
}

func attributeReducer(state: inout Attribute, action: AttributeAction) {
    switch action {
    
    case let .changeValue(val):
        state.value = val
    }
}

extension Array where Element == Attribute {
    func value(for name: String) -> Double? { first(where: { $0.name == name })?.value }
}

extension Attribute {
    func updated(with value: Double) -> Attribute {
        var a = self
        a.value = value
        return a
    }
}


// MARK: - transform -

struct Transform {
    var origin = Point(x: 0.5, y: 0.5)
    var zoom = 1.0
    
    var currentZoomStart = 0.0
    var currentProjectZoom = 0.0
    
    var currentTranslateStart = Point(x: 0.5, y: 0.5)
    var currentProjectTranslate = Point(x: 0.5, y: 0.5)
}

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


// MARK: - paths -

struct MyPath: Identifiable, Creatable, Selectable {
    let id: Int
    var points: [Point] = []
    var isSelected: Bool = false
    
    static func create(id: Int) -> MyPath { .init(id: id) }
}

enum PathAction {
    case addPoint(Point)
    case clear
}

func pathReducer(state: inout MyPath, action: PathAction) {
    switch action {

    case let .addPoint(val):
        state.points.append(val)

    case .clear:
        state.points = []
    }
}
