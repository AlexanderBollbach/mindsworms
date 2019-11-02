
import Foundation


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
