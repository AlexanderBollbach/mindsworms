import Foundation

protocol Selectable { var isSelected: Bool { get set } }

protocol Creatable {
    associatedtype ID
    static func create(id: ID) -> Self
}

enum ListAction<Entity, SubAction, ID: Hashable> {
    case insert(Entity)
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
}

typealias ListElement = Identifiable & Selectable & Creatable

func makeListReducer<S: ListElement, SubAction, ID>(
    _ reducer: @escaping (inout S, SubAction) -> Void
) -> (inout [S], ListAction<S, SubAction, ID>) -> Void
where S.ID == ID
{
    return { state, action in
        switch action {
            
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
            state.update(pred: { $0.id == id }, t: { reducer(&$0, action) })
            
        case let .replace(entities):
            state = entities
        
        case .selectAll:
            state.selectAll()
            
        case let .all(action):
            state.update(pred: { _ in true }) { reducer(&$0, action) }
            
        case let .reorder(id1, id2):
            state.swap(id1: id1, id2: id2)
        }
    }
}

extension Array where Element: Identifiable {
    mutating func swap(id1: Element.ID, id2: Element.ID) {
        guard
            let i1 = firstIndex(where: { $0.id == id1 }),
            let i2 = firstIndex(where: { $0.id == id2 }) else { fatalError() }
        
        swapAt(i1, i2)
    }
}

extension Array where Element: Selectable & Identifiable {
    mutating func selectAll() { for i in 0..<count { self[i].isSelected = true } }
    mutating func deselectAll() { for i in 0..<count { self[i].isSelected = false } }
    mutating func select(at id: Element.ID) { select(at: id, isSelected: true) }
    mutating func deselect(at id: Element.ID) { select(at: id, isSelected: false) }
    
    mutating func removeSelected() { self = filter { !$0.isSelected } }
    
    private mutating func select(at id: Element.ID, isSelected: Bool) {
        update(pred: { $0.id == id }, t: { $0.isSelected = isSelected })
    }
}

extension Array where Element: Identifiable & Selectable {
    mutating func update(pred: (Element) -> Bool, t: (inout Element) -> Void) {
        for i in 0..<count { if pred(self[i]) { t(&self[i]) } }
    }
    
    mutating func update(t: (inout Element) -> Void) {
        for i in 0..<count { t(&self[i]) }
    }
}
