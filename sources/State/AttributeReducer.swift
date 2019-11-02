

import Foundation

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

let attributeReducer: Reducer<Attribute, AttributeAction> = { state, action in
    switch action {
    
    case let .changeValue(val):
        state.value = val
    }
    
    return []
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

