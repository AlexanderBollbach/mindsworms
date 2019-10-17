import Foundation

func flicker(props: inout RenderProps, attributes: [Attribute], parameters: Any?) {
    guard
        let amount = attributes.value(for: "amount"),
        let speed = attributes.value(for: "speed"),
        let params = parameters as? FlickerParams,
        speed > 0.05 else { return }
    
    let s = Int(speed.toRange(low: 20, high: 1))
    params.tick = params.tick > 100 ? 1 : params.tick + 1
    props.color = props.color.with(alpha: params.tick % Int(s) < Int(s / 2) ? 1 : 1 - amount)
}
