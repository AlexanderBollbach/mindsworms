import UIKit

let effectFunctions = [
    "shake": shake,
    "mirror": mirror,
    "color": color,
    "symmetry": symmetry,
    "flicker": flicker,
    "cluster": cluster,
    "neon": neon,
    "pulse": pulse,
    "grow": grow,
    "lofi": lofi,
    "spin": spin
]

typealias EffectFunction = (
    _ props: inout RenderProps,
    _ attributes: [Attribute],
    _ parameters: Any?
    ) -> Void
