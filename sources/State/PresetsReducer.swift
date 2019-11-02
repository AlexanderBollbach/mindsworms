import Foundation


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

let presetsReducer: Reducer<AppState, PresetsAction> = { state, action in
    switch action {
    
    case let .save(name, effects):
        state.presets.add(preset: effects, name: name)
        return []
        
    case let .load(name):
        guard let effects = state.presets.getPreset(name: name) else { return [] }
        let r: Reducer<[Project], ProjectsAction> = makeListReducer(projectReducer)
        let a = ProjectsAction.selected(.layers(.selected(.effects(.replace(with: effects)))))
        let es = r(&state.projects, a)
        let rs = es.map { _ in [] }
        return []
    }
}
