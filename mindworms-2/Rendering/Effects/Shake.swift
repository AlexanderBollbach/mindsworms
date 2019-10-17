import Foundation

private extension MyPath {
    func withUpdated(points: [Point]) -> MyPath { .init(id: id, points: points) }
}

func shake(_ props: inout RenderProps, attributes: [Attribute], parameters: Any) {
    guard
        let amount = attributes.value(for: "amount"),
        let speed = attributes.value(for: "speed")?.toRange(low: 1, high: 5),
        let params = parameters as? ShakeParams,
        amount > 0.05 else { return }
    
    let a = amount.toRange(low: 0, high: 0.04)
    
    func shaken(path: MyPath) -> MyPath {
        
        path.withUpdated(points: path.points.enumerated().map { p in
            if p.offset % params.r1 == 0 {
                return Point(
                    x: p.element.x - (Double(params.index) / 100) * a,
                    y: p.element.y - (Double(params.index) / 100) * a
                )
            }
            
            if p.offset % params.r2 == 0 {
                return Point(
                    x: p.element.x + (Double(params.index) / 100) * a,
                    y: p.element.y + (Double(params.index) / 100) * a
                )
            }
            
            if p.offset % params.r3 == 0 {
                return Point(
                    x: p.element.x - (Double(params.index) / 100) * a,
                    y: p.element.y + (Double(params.index) / 100) * a
                )
            }
            
            if p.offset % params.r4 == 0 {
                return Point(
                    x: p.element.x + (Double(params.index) / 100) * a,
                    y: p.element.y - (Double(params.index) / 100) * a
                )
            }
            
            return p.element
        })
    }
    

    if params.directionUp && params.index >= params.target || !params.directionUp && params.index <= params.target {
        
        params.target = Int(Utilities.random() * 100)
        params.directionUp = params.target > params.index
    }
    
    let s = Int(speed)
    params.index += params.target >= params.index ? s : -s
    
    props.paths = props.paths.map(shaken)
}



