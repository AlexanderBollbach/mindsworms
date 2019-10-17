private extension Array where Element == Point {
    func nearOnly(delta: Double = 0.01) -> [Element] {
        
        var current = Point(x: 0, y: 0)
        
        var result = [Element]()
        
        for el in self {
            if abs(el.x - current.x) > delta || abs(el.y - current.y) > delta {
                result.append(el)
                current = el
            }
        }

        return result
    }
}

func lofi(_ props: inout RenderProps, attributes: [Attribute], parameters: Any) {
    guard let amount = attributes.value(for: "amount"), amount > 0.05 else { return }
    
    props.paths = props.paths.map { path in
        MyPath(id: path.id, points: path.points.nearOnly(delta: amount.toRange(low: 0.01, high: 0.2)))
    }
}
