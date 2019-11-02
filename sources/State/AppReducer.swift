
import Foundation

struct AppState {
    var projects = [Project]()
    var presets = Presets()
    var panes = Panes()
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

let appReducer: Reducer<AppState, AppAction> = combine(
    pullback(panesReducer, value: \AppState.panes, action: \AppAction.panes),
    pullback(projectsPersistenceReducer, value: \.self, action: \.projectsPersistence),
    pullback(presetsReducer, value: \.self, action: \.presets),
    pullback(makeListReducer(projectReducer), value: \AppState.projects, action: \AppAction.projects)
)
