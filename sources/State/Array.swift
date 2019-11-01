import Foundation

extension Array where Element: Identifiable, Element.ID == UUID {
    
    mutating func remove(ids: [UUID]) {
        self = filter { !ids.contains($0.id) }
    }
    
    func getByIds<T>(path: KeyPath<T, Set<UUID>>, in parents: [T]) -> [Element] {
        let ids = parents.reduce([], { $0 + $1[keyPath: path] })
        return filter { ids.contains($0.id) }
    }
    
    mutating func reduce<SubState, Action>(
        action: Action,
        pred: (Element) -> Bool,
        path: WritableKeyPath<Element, SubState>,
        reducer: (inout SubState, Action) -> Void
    ) {
        for i in 0..<count {
            if pred(self[i]) {
                reducer(&self[i][keyPath: path], action)
            }
        }
    }
}

extension Array {
    
    mutating func update(
        isSelected: (Element) -> Bool = { _ in true },
        f: (inout Element) -> Void
    ) {
        for i in 0..<count {
            if isSelected(self[i]) {
                f(&self[i])
            }
        }
    }
}

//extension Array where Element == Attribute {
//    mutating func update(id: UUID, value: Double) {
//        self = map { $0.id == id ? $0.updated(with: value) : $0 }
//    }
//}
