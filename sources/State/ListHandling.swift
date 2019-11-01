import Foundation

protocol Selectable { var isSelected: Bool { get set } }

protocol Titled { var title: String { get } }

protocol Creatable {
    associatedtype ID
    static func create(id: ID) -> Self
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
    
    mutating func swapSelected(_ rightLeft: Bool) {
        if let firstSelected = selected.first?.id {
            rightLeft ? self.swapRight(firstSelected) : self.swapLeft(firstSelected)
        }
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
