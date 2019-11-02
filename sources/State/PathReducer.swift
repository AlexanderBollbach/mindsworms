import Foundation


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

let pathReducer: Reducer<MyPath, PathAction> = { state, action in
    switch action {

    case let .addPoint(val):
        state.points.append(val)

    case .clear:
        state.points = []
    }
    
    return []
}

