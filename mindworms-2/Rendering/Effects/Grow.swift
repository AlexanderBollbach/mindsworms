
func grow(_ props: inout RenderProps, attributes: [Attribute], parameters: Any) {
    guard
//        let amount = attributes.value(for: "amount")?.toRange(low: 0, high: 1),
        let speed = attributes.value(for: "speed"),
        speed > 0.05,
        let params = parameters as? GrowParams
        else { return }
    
    let s = speed.toRange(low: 0.001, high: 0.1)
    
    params.phase += s
    
    if params.phase >= 1.0 {
        params.phase = 0
    }
    
    props.paths = props.paths.map { path in
        MyPath(
            id: path.id,
            points: Array(
                path.points.prefix(
                    Int(params.phase * Double(path.points.count - 1))
                )
            )
        )
    }
}
