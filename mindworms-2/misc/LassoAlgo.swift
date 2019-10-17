import Foundation
//
//extension Point: Equatable {
//    static func ==(lhs: Point, rhs: Point) -> Bool {
//        return lhs.x == rhs.x && lhs.y == rhs.y
//    }
//}
//
//struct PolygonSide {
//    let begin: Point
//    let end: Point
//}
//
//protocol LayerType {
//    var id: UUID { get }
//    var paths: [Path] { get }
//}
//
////extension Layer: LayerType {
////    var paths: [Path] {
////        return paths.all
////    }
////}
//
struct Lasso {
//    
//    struct DebugInfo {
//        var intersections = [Point]()
//        var sides = [PolygonSide]()
//        var rays = [Point]()
//    }
//    
//    var debug = DebugInfo()
    var points = [Point]()
}
//    
//    var renderDebugInfo = true
//    
//    mutating func select(layers: [LayerType]) -> [UUID] {
//        self.debug = DebugInfo()
//        
//        let sides = getSides(self.points)
//        
//        self.debug.sides = sides
//        
//        let r = layers
//            .filter { checkSelected(layer: $0, sides: sides) }
//        
//        return r.map { $0.id }
//    }
//   
//    mutating func checkSelected(layer: LayerType, sides: [PolygonSide]) -> Bool {
//        var previousPoint = Point(x: 0, y: 0)
//        
//        var isSelected = false
////
////        for point in layer.path {
////            if abs(point.x - previousPoint.x) < 0.1 && abs(point.y - previousPoint.y) < 0.1 { continue }
////
////            if intersect(point: point, sides: sides) {
////                isSelected = true
////            }
////
////            self.debug.rays.append(point)
////
////            previousPoint = point
////        }
////
//        return isSelected
//    }
//    
//    mutating func intersect(point: Point, sides: [PolygonSide]) -> Bool {
//        guard sides.count > 1 else { return false }
//        
//        var intersectionCount = 0
//        
//        for i in 0..<sides.count {
//            let side = sides[i]
//            
//            let t = point
//            let v2 = side.begin.y < side.end.y ? side.begin : side.end
//            let v1 = v2 == side.begin ? side.end : side.begin
//            
//            let testPointBetweenVertices = t.y > v2.y && t.y < v1.y
//            
//            if testPointBetweenVertices {
//                let xIntersection = v1.x + ((t.y - v1.y) / (v2.y - v1.y)) * (v2.x - v1.x)
//                if xIntersection > t.x {
//                    intersectionCount += 1
//                    self.debug.intersections.append(RenderProps.Point(x: xIntersection, y: t.y))
//                }
//            }
//        }
//        
//        return intersectionCount % 2 != 0
//    }
//}
//
//
//
//private func getSides(_ points: [Point]) -> [PolygonSide] {
//    
//    let maxSpacingNeeded = 0.05
//    
//    guard points.count > 2 else { return [] }
//    var sides = [PolygonSide]()
//    var sideBegin = points[0]
//    
//    for i in 0...points.count - 2 {
//        let currentPoint = points[i]
//        let enoughDistance = abs(currentPoint.x - sideBegin.x) > maxSpacingNeeded
//            || abs(currentPoint.y - sideBegin.y) > maxSpacingNeeded
//        
//        let pointsArentTheSame = true//currentPoint.x != sideBegin.x && currentPoint.y != sideBegin.y
//        let alwaysAddLastPoint = (i == points.count - 2)
//        
//        if ((pointsArentTheSame && enoughDistance) || alwaysAddLastPoint) {
//            sides.append(.init(begin: sideBegin, end: points[i + 1]))
//            sideBegin = points[i + 1]
//        }
//    }
//    
//    // loop
//    sides.append(.init(begin: points[points.count - 1], end: points[0]))
//    
//    return sides
//}
