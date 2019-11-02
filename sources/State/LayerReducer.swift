import Foundation

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

let layerReducer: Reducer<Layer, LayerAction> = { state, action in
    
    let a = makeListReducer(pathReducer)
    let undoReducer: Reducer<UndoStack<[MyPath]>, UndoAction<MyPathsAction>> = makeUndoReducer(a)
    
    switch action {

    case let .setSolo(val):
        state.isSoloed = val

    case let .effects(action):
        let es = makeListReducer(effectReducer)(&state.effects, action)
        return []

    case let .paths(action):
        undoReducer(&state.paths, UndoAction<MyPathsAction>.action(action))

    case .undo:
        undoReducer(&state.paths, UndoAction<MyPathsAction>.undo)

    case .redo:
        undoReducer(&state.paths, UndoAction<MyPathsAction>.undo)
    }

    return []
}
