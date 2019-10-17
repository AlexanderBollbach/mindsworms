//
//  Entities.swift
//  mindworms-2
//
//  Created by Alexander Bollbach on 10/15/19.
//  Copyright © 2019 Alexander Bollbach. All rights reserved.
//

import Foundation


struct Entities {
    
    struct Types {
        let from: String
        let to: String
    }
    
    struct Ids {
        let from: UUID
        let to: UUID
    }
    
    struct Specifier {
        let types: Types
        let ids: Ids
    }
    
    var map: [String: [String: EntityRelationship]] = [:]
    
    func first(types: Types) -> UUID? {
//        map[types.from]?[types.to]?
        return nil
    }
    
    private mutating func ensure(_ specifier: Specifier) {
        if map[specifier.types.from] == nil {
            map[specifier.types.from] = [String: EntityRelationship]()
        }
        
            if map[specifier.types.from]?[specifier.types.to] == nil {
            map[specifier.types.from]?[specifier.types.to] = EntityRelationship()
        }
    }
        
        
    mutating func connect(specifier: Specifier) {
        ensure(specifier)
        map[specifier.types.from]?[specifier.types.to]?.connect(specifier.ids.from, to: specifier.ids.to)
    }
}

struct EntityRelationship {
    var map = [UUID: Relation]()
    
    mutating func connect(_ from: UUID, to: [UUID]) {
        for id in to {
            connect(from, to: id)
        }
    }
    
    mutating func connect(_ from: [UUID], to: UUID) {
        for id in from {
            connect(id, to: id)
        }
    }
    
    mutating func disconnect(_ from: UUID, to: [UUID]) {
        for id in to {
            disconnect(from, to: id)
        }
    }
    
    mutating func disconnect(_ from: [UUID], to: UUID) {
        for id in from {
            disconnect(id, to: id)
        }
    }
    
    mutating func connect(_ from: UUID, to: UUID) {
        if map[from] == nil {
            map[from] = Relation()
        }
        
        map[from]?.connect(to)
    }
    
    mutating func disconnect(_ from: UUID, to: UUID) {
        if map[from] == nil {
            map[from] = Relation()
        }
        
        map[from]?.disconnect(to)
    }

}

struct Relation {
    
    var ids: Set<UUID> = Set()
    var selected: Set<UUID> = Set()
    
    mutating func connect(_ id: UUID, select: Bool = true) {
        ids.insert(id)
        selected.insert(id)
    }
    
    mutating func disconnect(_ id: UUID) {
        ids.remove(id)
        selected.remove(id)
    }
    
//    mutating func deselectAll() {
//        selected.removeAll()
//    }
    
    mutating func select(_ id: UUID) {
        selected.insert(id)
    }
    
    mutating func selectOnly(_ id: UUID) {
        selected.removeAll()
        selected.insert(id)
    }
    
    mutating func deselect(_ id: UUID) {
        selected.remove(id)
    }
    
//    mutating func deleteSelected() {
//        ids = Set(ids.drop(while: { selected.contains($0) }))
//        selected.removeAll()
//    }
    
    var firstSelected: UUID? {
        return selected.first
    }
}
