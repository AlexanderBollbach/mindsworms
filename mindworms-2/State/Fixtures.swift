import Foundation


// MARK: - effects -
//
//
//extension Array where Element == Effect {
//    static var standard: [Element] {
//        return [
//            .pulse,
//            .spin,
//            .shake,
//            .color,
//            .neon,
//            .symmetry,
//            .flicker,
//            .grow,
//            .cluster,
//            .lofi,
//            .mirror
//        ]
//    }
//}


class PulseParams {
    var width = 0.1
    var direction = false
}

class SpinParams {
    var theta = 0.0
}

class GrowParams {
    var phase = 0.0
}

class NeonParams {
    var r = 0.0
    var g = 0.0
    var b = 0.0
    var a = 0.0
    
    var rUp = false
    var gUp = false
    var bUp = false
    var aUp = false
}

class ShakeParams {
    var index = 0
    var target = 100
    var directionUp = false
    
    var r1 = Int(Utilities.random() * 10)
    var r2 = Int(Utilities.random() * 10)
    var r3 = Int(Utilities.random() * 10)
    var r4 = Int(Utilities.random() * 10)
}

class FlickerParams {
    var tick = 0
}

class ClusterParams {
    var tick = 0
    var subsetIndices = [Int]()
}

struct Effect: Identifiable {
    let id: UUID
    let name: String
    var attributes: Relation
    var parameters: Any?
    
    init(
        id: UUID,
        name: String = "effect",
        attributes: Relation = Relation(),
        parameters: Any? = nil
    ) {
        self.id = id
        self.name = name
        self.attributes = attributes
        self.parameters = parameters
        self.attributes = attributes
    }
}
//
//extension Effect {
//    static func pulse(id: UUID) -> Effect {
//        return Effect(
//            id: id,
//            name: "pulse",
//            attributes: [
//                Attribute(name: "amount", value: 0.0),
//                Attribute(name: "speed", value: 0.0)
//            ],
//            parameters: PulseParams()
//        )
//    }
//    static func spin(id: UUID) -> Effect {
//        return Effect(
//            id: id,
//            name: "spin",
//            attributes: [
//                Attribute(name: "speed", value: 0.0)
//            ],
//            parameters: SpinParams()
//        )
//    }
//    static func cluster(id: UUID) -> Effect {
//        return Effect(
//            id: id,
//            name: "cluster",
//            attributes: [
//                Attribute(name: "speed", value: 0.0),
//                Attribute(name: "clusters", value: 0.0)
//            ],
//            parameters: ClusterParams()
//        )
//    }
//    static func flicker(id: UUID) -> Effect {
//        return Effect(
//            id: id,
//            name: "flicker",
//            attributes: [
//                Attribute(name: "amount", value: 0.0),
//                Attribute(name: "speed", value: 0.0),
//            ],
//            parameters: FlickerParams()
//        )
//    }
//    static func grow(id: UUID) -> Effect {
//        return Effect(
//            id: id,
//            name: "grow",
//            attributes: [
//                Attribute(name: "speed", value: 0.0)
//            ],
//            parameters: GrowParams()
//        )
//    }
//    static func shake(id: UUID) -> Effect {
//        return Effect(
//            id: id,
//            name: "shake",
//            attributes: [
//                Attribute(name: "amount", value: 0.0),
//                Attribute(name: "speed", value: 0.0)
//            ],
//            parameters: ShakeParams()
//        )
//    }
//    static func color(id: UUID) -> Effect {
//        Effect(
//            id: id,
//            name: "color",
//            attributes: [
//                Attribute(name: "red", value: 1.0),
//                Attribute(name: "green", value: 1.0),
//                Attribute(name: "blue", value: 1.0),
//                Attribute(name: "alpha", value: 1.0)
//            ]
//        )
//    }
//    static func neon(id: UUID) -> Effect {
//        Effect(
//            id: id,
//            name: "neon",
//            attributes: [
//                Attribute(
//                    name: "amount",
//                    value: 0.0
//                ),
//                Attribute(
//                    name: "speed",
//                    value: 0.0
//                )
//            ],
//        parameters: NeonParams()
//        )
//    }
//    static func symmetry(id: UUID) -> Effect {
//        Effect(
//            id: id,
//            name: "symmetry",
//            attributes: [
//                Attribute(
//                    name: "count",
//                    value: 0.0
//                )
//            ]
//        )
//    }
//    static func mirror(id: UUID) -> Effect {
//        Effect(
//            id: id,
//            name: "mirror",
//            attributes: [
//                Attribute(
//                    name: "x",
//                    value: 0.0
//                ),
//                Attribute(
//                    name: "y",
//                    value: 0.5
//                )
//            ]
//        )
//    }
//    static func lofi(id: UUID) -> Effect {
//        Effect(
//            id: id,
//            name: "lofi",
//            attributes: [
//                Attribute(
//                    name: "amount",
//                    value: 0.0
//                )
//            ]
//        )
//    }
//}
