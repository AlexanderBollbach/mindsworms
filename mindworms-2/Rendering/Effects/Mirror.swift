
func mirror(props: inout RenderProps, attributes: [Attribute], parameters: Any?) {

    guard
        let x = attributes.value(for: "x"),
        let y = attributes.value(for: "y") else { return }

    if x > 0.5 {
        props.paths.append(
            contentsOf: props.paths.map { MyPath(id: $0.id, points: $0.points.map { Point(x: 1 - $0.x, y: $0.y) }) }
        )
    }

    if y > 0.5 {
        props.paths.append(
            contentsOf: props.paths.map { MyPath(id: $0.id, points: $0.points.map { Point(x: $0.x, y: 1 - $0.y) }) }
        )
    }
}
