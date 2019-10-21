import Foundation


struct R_Project {
    var layers: [R_Layer]
    var transform: Transform
    
    init(project: Project) {
        self.layers = []
        self.layers.update(with: project.layers)
        self.transform = project.transform
    }
    
    init() {
        self.layers = []
        self.transform = Transform()
    }
}

struct R_Layer: Identifiable {
    let id: Int
    var isMuted: Bool
    var paths: [MyPath]
    var color: MyColor
    var effects: [R_Effect]
    
    init(layer: Layer) {
        self.id = layer.id
        self.isMuted = layer.isMuted
        self.paths = layer.paths
        self.color = layer.color
        self.effects = [R_Effect]()
        self.effects.update(with: layer.effects)
    }
}

protocol Updatable {
    func update(with other: Self)
}

extension Array where Element: Identifiable {
    func contains(_ element: Element) -> Bool { map { $0.id }.contains(element.id) }
}

extension R_Effect {
    func update(with effect: Effect) {
        attributes = effect.attributes
    }
}

extension R_Layer {
    mutating func update(with layer: Layer) {
        self.paths = layer.paths
        self.isMuted = layer.isMuted
        self.color = layer.color
        self.effects.update(with: layer.effects)
    }
}
extension Layer { func toR_Layer() -> R_Layer { R_Layer(layer: self) } }

extension Effect {
    func toR_Effect() -> R_Effect? {
        EffectFunctionality.effects[name]?.generateR_Effect(self.id)
    }
}

extension Array where Element == R_Layer {
    mutating func update(with other: [Layer]) {
         var result = [R_Layer]()
         
         for o in other {
             if let i = self.firstIndex(where: { $0.id == o.id }) {
                 self[i].update(with: o)
                 result.append(self[i])
                 continue
             }
             
             result.append(o.toR_Layer())
         }
         self = result
    }
}

extension Array where Element == R_Effect {
    mutating func update(with other: [Effect]) {
        var result = [R_Effect]()
        
        for o in other {
            if let i = self.firstIndex(where: { $0.id == o.id }) {
                self[i].update(with: o)
                result.append(self[i])
                continue
            }
            
            result.append(o.toR_Effect()!)
        }
        self = result
    }
}

