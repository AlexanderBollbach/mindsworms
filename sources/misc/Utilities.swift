

import UIKit

extension Int {
    var nearest16: Int {
        var temp = self
        while temp % 16 != 0 { temp += 1 }
        return temp
    }
}

extension Double {
    mutating func clampToUnitRange() {
        self = self > 1.0 ? 1.0: self
        self = self < 0.0 ? 0.0 : self
    }
}

func delay(by amount: Double, closure: @escaping () -> Void) {
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + amount) {
        closure()
    }
}

class Utilities {
    
    static func clamp(value: Double) -> Double {
        
        if value >  1 {
            return 1
        } else if value < 0 {
            return 0
        }
        
        return value
    }
    
    
    static func random() -> Double { Double(arc4random()) / Double(UINT32_MAX) }
    
    static func distance(from: Point, to: Point) -> Double {
        let xDel = fabs(to.x - from.x)
        let yDel = fabs(to.y - from .y)
        return sqrt((xDel * xDel) + (yDel * yDel))
    }
    
    static func project(normalizedValue: CGFloat, toRange range: (CGFloat, CGFloat), withMargin margin: CGFloat) -> CGFloat {
        let low = range.0 + (margin / 2)
        let high = range.1 - (margin / 2)
        let scaledValue = (normalizedValue * (high - low)) + low
        return scaledValue
    }
}


extension Double {
    func toRange(low: Double, high: Double) -> Double { low + (self * (high - low)) }
}

func measure(block: () -> Void) -> Void {
    let start = DispatchTime.now()
    block()
    let end = DispatchTime.now()
    
    let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
    let timeInterval = Double(nanoTime) / 1_000_000_000
    
    print(timeInterval)
}
