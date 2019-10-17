
func pulse(_ props: inout RenderProps, attributes: [Attribute], parameters: Any) {
    guard
        let amount = attributes.value(for: "amount")?.toRange(low: 1, high: 50),
        let speed = attributes.value(for: "speed")?.toRange(low: 0.01, high: 10),
        amount > 2,
        let params = parameters as? PulseParams
        else { return }
    
    
    
    let step = params.direction ? speed : -speed
    params.width += step
    
    if params.width > amount {
        params.direction = false
    }
    
    if params.width < 1 {
        params.direction = true
    }
    
    props.strokeWidth += params.width
}
