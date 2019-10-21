import Foundation

extension AppState {
    var allLayers: [Layer] { projects.aggregated(path: \.layers) }
    var allEffects: [Effect] { allLayers.aggregated(path: \.effects) }
    var allAttributes: [Attribute] { allEffects.aggregated(path: \.attributes) }
    
    var activeLayers: [Layer] { projects.selected.aggregated(path: \.layers) }
    var activeEffects: [Effect] { activeLayers.selected.aggregated(path: \.effects) }
    var activeAttributes: [Attribute] { activeEffects.selected.aggregated(path: \.attributes) }
    
    var firstActiveProject: Project? { projects.firstActive }
    
    var presetNames: [String] { Array(presets.keys) }
}


extension Project {
    var paths: [MyPath] { layers.flatMap { $0.paths } }
}

extension Array where Element: Selectable {
    var selected: [Element] { filter { $0.isSelected } }
}

extension Array {
    func aggregated<T>(path: KeyPath<Element, [T]>) -> [T] { flatMap { $0[keyPath: path] } }
}

typealias ProjectsAction = ListAction<Project, ProjectAction, Int>
typealias LayersAction = ListAction<Layer, LayerAction, Int>
typealias EffectsAction = ListAction<Effect, EffectAction, Int>
typealias AttributesAction = ListAction<Attribute, AttributeAction, Int>

extension AppAction {
    static func activeProjects(_ action: ProjectsAction) -> AppAction { .projects(action) }
    static func activeLayers(_ action: LayersAction) -> AppAction { activeProjects(.selected(.layers(action))) }
    static func activeEffects(_ action: EffectsAction) -> AppAction { activeLayers(.selected(.effects(action))) }
    static func activeAttributes(_ action: AttributesAction) -> AppAction { activeEffects(.selected(.attributes(action))) }
}

extension Array where Element: Selectable {
    var firstActive: Element? { first(where: { $0.isSelected }) }
}
