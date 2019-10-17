import Foundation

extension Point {
    func rotated(around center: Point, with degrees: Double) -> Point {
        let dx = self.x - center.x
        let dy = self.y - center.y
        let radius = sqrt(dx * dx + dy * dy)
        let azimuth = atan2(dy, dx) // in radians
        let newAzimuth = azimuth + degrees * Double(.pi / 180.0) // convert it to radians
        let x = center.x + radius * cos(newAzimuth)
        let y = center.y + radius * sin(newAzimuth)
        return Point(x: x, y: y)
    }
}

func symmetry(props: inout RenderProps, attributes: [Attribute], parameters: Any?) {
    guard let countVal = attributes.value(for: "count") else { return }
    
    let count = Int(countVal.toRange(low: 1, high: 15))
    
    
    if count <= 1 {
        return
    }
    
    let eachDegree = 360 / count
    let oldPaths = props.paths


    for path in oldPaths {
        guard let center = path.points.first else { continue }

        var symmetryPaths = [MyPath]()
        var currentDegree = 0

        while currentDegree < 360 {

            var symPath = MyPath(id: path.id, points: [])

            for point in path.points {
                symPath.points.append(point.rotated(around: center, with: Double(currentDegree)))
            }

            symmetryPaths.append(symPath)
            currentDegree += eachDegree
        }

        props.paths.append(contentsOf: symmetryPaths)
    }
}

