

import Foundation


struct EffectFunctionality {
    
    struct EffectBin {
        let generateEffect: (Int) -> Effect
        let generateR_Effect: (Int) -> R_Effect
    }
    static var effects: [String: EffectBin] {
        return [
            "Pulse": EffectBin(
                generateEffect: {
                    Effect(
                        id: $0,
                        name: "Pulse",
                        attributes: [
                            Attribute(id: genID(), name: "amount"),
                            Attribute(id: genID(), name: "speed")
                        ]
                    )
            },
                generateR_Effect: Pulse.init
            ),
            "Mirror": EffectBin(
                generateEffect: {
                    Effect(
                        id: $0,
                        name: "Mirror",
                        attributes: [
                            Attribute(id: genID(), name: "x"),
                            Attribute(id: genID(), name: "y")
                        ]
                    )
            },
                generateR_Effect: Mirror.init
            ),
            "Neon": EffectBin(
                generateEffect: {
                    Effect(
                        id: $0,
                        name: "Neon",
                        attributes: [
                            Attribute(id: genID(), name: "amount"),
                            Attribute(id: genID(), name: "speed")
                        ]
                    )
            },
                generateR_Effect: Neon.init
            ),
            "Lofi": EffectBin(
                generateEffect: {
                    Effect(
                        id: $0,
                        name: "Lofi",
                        attributes: [
                            Attribute(id: genID(), name: "amount")
                        ]
                    )
            },
                generateR_Effect: Lofi.init
            ),
            "Shake": EffectBin(
                generateEffect: {
                    Effect(
                        id: $0,
                        name: "Shake",
                        attributes: [
                            Attribute(id: genID(), name: "amount"),
                            Attribute(id: genID(), name: "speed")
                        ]
                    )
            },
                generateR_Effect: Shake.init
            ),
            "Spin": EffectBin(
                generateEffect: {
                    Effect(
                        id: $0,
                        name: "Spin",
                        attributes: [
                            Attribute(id: genID(), name: "speed")
                        ]
                    )
            },
                generateR_Effect: Spin.init
            ),
            "Color": EffectBin(
                generateEffect: {
                    Effect(
                        id: $0,
                        name: "Color",
                        attributes: [
                            Attribute(id: genID(), name: "red"),
                            Attribute(id: genID(), name: "green"),
                            Attribute(id: genID(), name: "blue"),
                            Attribute(id: genID(), name: "alpha")
                        ]
                    )
            },
                generateR_Effect: ColorChanger.init
            ),
            "Flicker": EffectBin(
                generateEffect: {
                    Effect(
                        id: $0,
                        name: "Flicker",
                        attributes: [
                            Attribute(id: genID(), name: "speed"),
                            Attribute(id: genID(), name: "amount")
                        ]
                    )
            },
                generateR_Effect: Flicker.init
            ),
            "Cluster": EffectBin(
                generateEffect: {
                    Effect(
                        id: $0,
                        name: "Cluster",
                        attributes: [
                            Attribute(id: genID(), name: "speed"),
                            Attribute(id: genID(), name: "clusters")
                        ]
                    )
            },
                generateR_Effect: Cluster.init
            ),
            "Symmetry": EffectBin(
                generateEffect: {
                    Effect(
                        id: $0,
                        name: "Symmetry",
                        attributes: [
                            Attribute(id: genID(), name: "count")
                        ]
                    )
            },
                generateR_Effect: Symmetry.init
            ),
            "Grow": EffectBin(
                generateEffect: {
                    Effect(
                        id: $0,
                        name: "Grow",
                        attributes: [
                            Attribute(id: genID(), name: "speed")
                        ]
                    )
            },
                generateR_Effect: Grow.init
            ),
        ]
    }
}
