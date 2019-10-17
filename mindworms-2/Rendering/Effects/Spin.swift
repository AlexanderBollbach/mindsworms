

func spin(props: inout RenderProps, attributes: [Attribute], parameters: Any?) {
    guard
        let speed = attributes.value(for: "speed"),
        let params = parameters as? SpinParams,
        speed > 0.05 else { return }
    
    params.theta += 1
    
    if params.theta > 360 {
        params.theta = 0
    }
    
    props.paths = props.paths.map { path in
        MyPath(id: path.id, points: path.points.map { point in
            point.rotated(around: Point(x: 0.5, y: 0.5), with: params.theta)
        })
    }
}

