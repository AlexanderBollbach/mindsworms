
import Foundation

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

let effectReducer: Reducer<Effect, EffectAction> = { state, action in
    switch action {

    case let .attributes(action):
        let es = makeListReducer(attributeReducer)(&state.attributes, action)
        return []
    }
}

