
import Foundation


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

