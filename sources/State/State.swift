import Foundation

struct UndoStack<T: Codable>: Codable {
    var history = [T]()
    var future = [T]()
    var current: T
    
    mutating func undo() {
        if history.isEmpty { return }
        let curr = current
        current = history.removeLast()
        future = [curr] + future
    }
    
    mutating func redo() {
        if future.isEmpty { return }
        let curr = current
        current = future.removeFirst()
        history.append(curr)
    }
    
    mutating func update(value: T) {
        history.append(current)
        current = value
    }
}

enum UndoAction<Action> {
    case undo
    case redo
    case action(Action)

    var undo: Void? {
        guard case .undo = self else { return nil }
        return ()
    }

    var redo: Void? {
        guard case .redo = self else { return nil }
        return ()
    }

    var action: Action? {
        get {
            guard case let .action(value) = self else { return nil }
            return value
        }
        set {
            guard case .action = self, let newValue = newValue else { return }
            self = .action(newValue)
        }
    }
}

func makeUndoReducer<State, Action>(_ reducer: @escaping (inout State, Action) -> Void) -> (inout UndoStack<State>, UndoAction<Action>) -> Void {
    return { state, action in
        switch action {
        case .undo:
            state.undo()
        
        case .redo:
            state.redo()
            
        case let .action(val):
            var s = state.current
            reducer(&s, val)
            state.update(value: s)
        }
    }
}

// MARK: - app -

var _idCounter = 0

func genID() -> Int {
    _idCounter += 1
    return _idCounter
}


struct AppState {
    var projects = [Project]()
    var presets = Presets()
    var panes = Panes()
}

struct Presets {
    private var presets = [String: [Effect]]()
    
    var names: [String] { Array(presets.keys) }
    
    mutating func add(preset: [Effect], name: String) {
        presets[name] = preset
    }
    
    func getPreset(name: String) -> [Effect]? {
        return presets[name]
    }
}

enum PresetsAction {
    case save(name: String, effects: [Effect])
    case load(name: String)

    var save: (name: String, effects: [Effect])? {
        get {
            guard case let .save(value) = self else { return nil }
            return value
        }
        set {
            guard case .save = self, let newValue = newValue else { return }
            self = .save(name: newValue.0, effects: newValue.1)
        }
    }

    var load: String? {
        get {
            guard case let .load(value) = self else { return nil }
            return value
        }
        set {
            guard case .load = self, let newValue = newValue else { return }
            self = .load(name: newValue)
        }
    }

}

enum ProjectPersistenceAction {
    case save
    case fetch
    case load([Project])

    var save: Void? {
        guard case .save = self else { return nil }
        return ()
    }

    var fetch: Void? {
        guard case .fetch = self else { return nil }
        return ()
    }

    var load: [Project]? {
        get {
            guard case let .load(value) = self else { return nil }
            return value
        }
        set {
            guard case .load = self, let newValue = newValue else { return }
            self = .load(newValue)
        }
    }
}

enum AppAction {
    case projects(ListAction<Project, ProjectAction, Int>)
    case presets(PresetsAction)
    case panes(PanesAction)
    case projectsPersistence(ProjectPersistenceAction)

    var projects: ListAction<Project, ProjectAction, Int>? {
        get {
            guard case let .projects(value) = self else { return nil }
            return value
        }
        set {
            guard case .projects = self, let newValue = newValue else { return }
            self = .projects(newValue)
        }
    }

    var presets: PresetsAction? {
        get {
            guard case let .presets(value) = self else { return nil }
            return value
        }
        set {
            guard case .presets = self, let newValue = newValue else { return }
            self = .presets(newValue)
        }
    }

    var panes: PanesAction? {
        get {
            guard case let .panes(value) = self else { return nil }
            return value
        }
        set {
            guard case .panes = self, let newValue = newValue else { return }
            self = .panes(newValue)
        }
    }

    var projectsPersistence: ProjectPersistenceAction? {
        get {
            guard case let .projectsPersistence(value) = self else { return nil }
            return value
        }
        set {
            guard case .projectsPersistence = self, let newValue = newValue else { return }
            self = .projectsPersistence(newValue)
        }
    }
}

//let r = makeListReducer(projectReducer)

let appReducer2: Reducer<AppState, AppAction> = combine(
    pullback(panesReducer, value: \AppState.panes, action: \AppAction.panes),
    pullback(projectsPersistenceReducer, value: \.self, action: \.projectsPersistence),
    pullback(presetsReducer, value: \.self, action: \.presets)
//    pullback(makeListReducer(projectReducer), value: \AppState.projects, action: \AppAction.projects)
)

let projectsPersistenceReducer: Reducer<AppState, ProjectPersistenceAction> = { state, action in
    switch action {
        case .save:
            let projects = state.projects
            return [{
                let data = try! JSONEncoder().encode(projects)
                let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                let docsURL = URL(fileURLWithPath: path)
                let appData = docsURL.appendingPathComponent("projects.json")
                try! data.write(to: appData)
                return nil
            }]
            
        case .fetch:
            return [{
                let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                let docsURL = URL(fileURLWithPath: path)
                let appData = docsURL.appendingPathComponent("projects.json")
                
                guard
                    let data = try? Data(contentsOf: appData),
                    let projects = try? JSONDecoder().decode([Project].self, from: data) else { return nil }
                
                return .load(projects)
                }]
    default:
        break
    }
    
    return []
}

let presetsReducer: Reducer<AppState, PresetsAction> = { state, action in
    switch action {
        case let .save(name, effects):
            state.presets.add(preset: effects, name: name)

        case let .load(name):
            if let effects = state.presets.getPreset(name: name) {
//                let r: Reducer<AppState, AppAction> = pullback(makeListReducer(projectReducer), value: \AppState.projects, action: \AppAction.projects)
//                r
//                return makeListReducer(projectReducer)(
//                    &state.projects,
//                    .selected(.layers(.selected(.effects(.replace(with: effects)))))
//                )
            }
    }
    
    return []
}

// MARK: - project -

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
//
//func projectReducer(state: inout Project, action: ProjectAction) -> [StoreEffect<ProjectAction>] {
//    switch action {
//
//    case let .changeName(name):
//        state.name = name
//
//    case .toggleMoving:
//        state.mode.toggleMoving()
//
//    case let .transform(action):
//        transformReducer(state: &state.transform, action: action)
//
//    case let .layers(action):
//        let r: Reducer<[Layer], LayersAction> = pullback(makeListReducer(layerReducer), value: \Project.layers, action: \ProjectAction.layers)
//        return r(&state.layers, action)
//
//    case let .settings(action):
//        projectSettingsReducer(state: &state.settings, action: action)
//    }
//
//    return []
//}

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


// MARK: - layer -

struct Layer: Identifiable, Selectable, Creatable, Codable {
    let id: Int
    var name = "layer"
    var color = MyColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var isSoloed = false
    var isSelected = false
    var effects = [Effect]()
    var paths = UndoStack(current: [MyPath]())
    
    static func create(id: Int) -> Layer { .init(id: id) }
}

enum LayerAction {
    case setSolo(Bool)
    case effects(ListAction<Effect, EffectAction, Int>)
    case paths(ListAction<MyPath, PathAction, Int>)
    case undo
    case redo

    var setSolo: Bool? {
        get {
            guard case let .setSolo(value) = self else { return nil }
            return value
        }
        set {
            guard case .setSolo = self, let newValue = newValue else { return }
            self = .setSolo(newValue)
        }
    }

    var effects: ListAction<Effect, EffectAction, Int>? {
        get {
            guard case let .effects(value) = self else { return nil }
            return value
        }
        set {
            guard case .effects = self, let newValue = newValue else { return }
            self = .effects(newValue)
        }
    }

    var paths: ListAction<MyPath, PathAction, Int>? {
        get {
            guard case let .paths(value) = self else { return nil }
            return value
        }
        set {
            guard case .paths = self, let newValue = newValue else { return }
            self = .paths(newValue)
        }
    }

    var undo: Void? {
        guard case .undo = self else { return nil }
        return ()
    }

    var redo: Void? {
        guard case .redo = self else { return nil }
        return ()
    }
}
//
//func layerReducer(state: inout Layer, action: LayerAction) -> [StoreEffect<LayerAction>] {
//    switch action {
//
//    case let .setSolo(val):
//        state.isSoloed = val
//
//    case let .effects(action):
//        makeListReducer(effectReducer)(&state.effects, action)
//
//
//    case let .paths(action):
//        let a = makeListReducer(pathReducer(state:action:))
//        let r: (inout UndoStack<[MyPath]>, UndoAction<ListAction<MyPath, PathAction, Int>>) -> Void = makeUndoReducer(a)
//        r(&state.paths, .action(action))
//
//    case .undo:
//        let a = makeListReducer(pathReducer(state:action:))
//        let r: (inout UndoStack<[MyPath]>, UndoAction<ListAction<MyPath, PathAction, Int>>) -> Void = makeUndoReducer(a)
//        r(&state.paths, .undo)
//
//    case .redo:
//        let a = makeListReducer(pathReducer(state:action:))
//        let r: (inout UndoStack<[MyPath]>, UndoAction<ListAction<MyPath, PathAction, Int>>) -> Void = makeUndoReducer(a)
//        r(&state.paths, .redo)
//    }
//
//    return []
//}


// MARK: - effect -

struct Effect: Identifiable, Selectable, Creatable, Codable {
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

    var attributes: ListAction<Attribute, AttributeAction, Int>? {
        get {
            guard case let .attributes(value) = self else { return nil }
            return value
        }
        set {
            guard case .attributes = self, let newValue = newValue else { return }
            self = .attributes(newValue)
        }
    }
}

//func effectReducer(state: inout Effect, action: EffectAction) {
//    switch action {
//
//    case let .attributes(action):
//        makeListReducer(attributeReducer)(&state.attributes, action)
//    }
//}

// MARK: - attribute -

struct Attribute: Identifiable, Selectable, Creatable, Equatable, Codable {
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

    var changeValue: Double? {
        get {
            guard case let .changeValue(value) = self else { return nil }
            return value
        }
        set {
            guard case .changeValue = self, let newValue = newValue else { return }
            self = .changeValue(newValue)
        }
    }
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

struct Transform: Codable {
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

    var startZoom: Double? {
        get {
            guard case let .startZoom(value) = self else { return nil }
            return value
        }
        set {
            guard case .startZoom = self, let newValue = newValue else { return }
            self = .startZoom(newValue)
        }
    }

    var updateZoom: Double? {
        get {
            guard case let .updateZoom(value) = self else { return nil }
            return value
        }
        set {
            guard case .updateZoom = self, let newValue = newValue else { return }
            self = .updateZoom(newValue)
        }
    }

    var startTranslate: Point? {
        get {
            guard case let .startTranslate(value) = self else { return nil }
            return value
        }
        set {
            guard case .startTranslate = self, let newValue = newValue else { return }
            self = .startTranslate(newValue)
        }
    }

    var updateTranslate: Point? {
        get {
            guard case let .updateTranslate(value) = self else { return nil }
            return value
        }
        set {
            guard case .updateTranslate = self, let newValue = newValue else { return }
            self = .updateTranslate(newValue)
        }
    }

    var reset: Void? {
        guard case .reset = self else { return nil }
        return ()
    }
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

struct MyPath: Identifiable, Creatable, Selectable, Codable {
    let id: Int
    var points: [Point] = []
    var isSelected: Bool = false
    
    static func create(id: Int) -> MyPath { .init(id: id) }
}

enum PathAction {
    case addPoint(Point)
    case clear

    var addPoint: Point? {
        get {
            guard case let .addPoint(value) = self else { return nil }
            return value
        }
        set {
            guard case .addPoint = self, let newValue = newValue else { return }
            self = .addPoint(newValue)
        }
    }

    var clear: Void? {
        guard case .clear = self else { return nil }
        return ()
    }
}

func pathReducer(state: inout MyPath, action: PathAction) {
    switch action {

    case let .addPoint(val):
        state.points.append(val)

    case .clear:
        state.points = []
    }
}

// MARK: - list handling -


enum ListAction<Entity, SubAction, ID: Hashable> {
    case insert(Entity)
    case load([Entity])
    case create(id: ID)
    case select(id: ID)
    case deselect(id: ID)
    case removeSelected
    case selected(SubAction)
    case all(SubAction)
    case update(ID, SubAction)
    case deselectAll
    case replace(with: [Entity])
    case selectAll
    case reorder(id1: ID, id2: ID)
    case swapRight(id: ID)
    case swapLeft(id: ID)
    
    case swapSelected(rightLeft: Bool)

    var insert: Entity? {
        get {
            guard case let .insert(value) = self else { return nil }
            return value
        }
        set {
            guard case .insert = self, let newValue = newValue else { return }
            self = .insert(newValue)
        }
    }

    var load: [Entity]? {
        get {
            guard case let .load(value) = self else { return nil }
            return value
        }
        set {
            guard case .load = self, let newValue = newValue else { return }
            self = .load(newValue)
        }
    }

    var create: ID? {
        get {
            guard case let .create(value) = self else { return nil }
            return value
        }
        set {
            guard case .create = self, let newValue = newValue else { return }
            self = .create(id: newValue)
        }
    }

    var select: ID? {
        get {
            guard case let .select(value) = self else { return nil }
            return value
        }
        set {
            guard case .select = self, let newValue = newValue else { return }
            self = .select(id: newValue)
        }
    }

    var deselect: ID? {
        get {
            guard case let .deselect(value) = self else { return nil }
            return value
        }
        set {
            guard case .deselect = self, let newValue = newValue else { return }
            self = .deselect(id: newValue)
        }
    }

    var removeSelected: Void? {
        guard case .removeSelected = self else { return nil }
        return ()
    }

    var selected: SubAction? {
        get {
            guard case let .selected(value) = self else { return nil }
            return value
        }
        set {
            guard case .selected = self, let newValue = newValue else { return }
            self = .selected(newValue)
        }
    }

    var all: SubAction? {
        get {
            guard case let .all(value) = self else { return nil }
            return value
        }
        set {
            guard case .all = self, let newValue = newValue else { return }
            self = .all(newValue)
        }
    }

    var update: (ID, SubAction)? {
        get {
            guard case let .update(value) = self else { return nil }
            return value
        }
        set {
            guard case .update = self, let newValue = newValue else { return }
            self = .update(newValue.0, newValue.1)
        }
    }

    var deselectAll: Void? {
        guard case .deselectAll = self else { return nil }
        return ()
    }

    var replace: [Entity]? {
        get {
            guard case let .replace(value) = self else { return nil }
            return value
        }
        set {
            guard case .replace = self, let newValue = newValue else { return }
            self = .replace(with: newValue)
        }
    }

    var selectAll: Void? {
        guard case .selectAll = self else { return nil }
        return ()
    }

    var reorder: (id1: ID, id2: ID)? {
        get {
            guard case let .reorder(value) = self else { return nil }
            return value
        }
        set {
            guard case .reorder = self, let newValue = newValue else { return }
            self = .reorder(id1: newValue.0, id2: newValue.1)
        }
    }

    var swapRight: ID? {
        get {
            guard case let .swapRight(value) = self else { return nil }
            return value
        }
        set {
            guard case .swapRight = self, let newValue = newValue else { return }
            self = .swapRight(id: newValue)
        }
    }

    var swapLeft: ID? {
        get {
            guard case let .swapLeft(value) = self else { return nil }
            return value
        }
        set {
            guard case .swapLeft = self, let newValue = newValue else { return }
            self = .swapLeft(id: newValue)
        }
    }

    var swapSelected: Bool? {
        get {
            guard case let .swapSelected(value) = self else { return nil }
            return value
        }
        set {
            guard case .swapSelected = self, let newValue = newValue else { return }
            self = .swapSelected(rightLeft: newValue)
        }
    }
}

typealias ListElement = Identifiable & Selectable & Creatable

func makeListReducer<S: ListElement, SubAction, ID>(
    _ reducer: @escaping Reducer<S, SubAction>
) -> Reducer<[S], ListAction<S, SubAction, ID>>
where S.ID == ID
{
    return { state, action in
        switch action {
            
        case let .load(entities):
            state = entities
            
        case let .insert(e):
            state.append(e)
            
        case let .create(id):
            state.append(S.create(id: id))
            
        case let .select(id):
            state.select(at: id)
            
        case let .deselect(id):
            state.deselect(at: id)
            
        case .deselectAll:
            state.deselectAll()
            
        case .removeSelected:
            state.removeSelected()
            
        case let .selected(action):
            state.update(pred: { $0.isSelected }, t: { reducer(&$0, action) })
            
        case let .update(id, action):
            state.update(pred: { $0.id == id }, t: { reducer(&$0, action) })
            
        case let .replace(entities):
            state = entities
        
        case .selectAll:
            state.selectAll()
            
        case let .all(action):
            state.update(pred: { _ in true }) { reducer(&$0, action) }
            
        case let .reorder(id1, id2):
            state.swap(id1: id1, id2: id2)
            
        case let .swapRight(id):
            state.swapRight(id)
        
        case let .swapLeft(id):
            state.swapLeft(id)
            
        case let .swapSelected(rightLeft):
            state.swapSelected(rightLeft)
            
        }
        
        return []
    }
}

extension Array where Element: Identifiable {
    mutating func swap(id1: Element.ID, id2: Element.ID) {
        guard
            let i1 = firstIndex(where: { $0.id == id1 }),
            let i2 = firstIndex(where: { $0.id == id2 }) else { fatalError() }
        
        swapAt(i1, i2)
    }
    mutating func swapRight(_ id: Element.ID) {
        guard
            let i1 = firstIndex(where: { $0.id == id }) else { fatalError() }
        
        if i1 == self.count - 1 {
            swapAt(i1, 0)
            return
        }
        
        swapAt(i1, i1 + 1)
    }
    mutating func swapLeft(_ id: Element.ID) {
        guard
            let i1 = firstIndex(where: { $0.id == id }) else { fatalError() }
        
        if i1 == 0 {
            swapAt(i1, self.count - 1)
            return
        }
        
        swapAt(i1, i1 - 1)
    }
}
