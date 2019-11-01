import UIKit

// MARK: - drawing -

struct MyColor: Codable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
    
    init(red: Double = 1.0, green: Double = 1.0, blue: Double = 1.0, alpha: Double = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    var uicolor: UIColor { UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha)) }
    
    func with(alpha: Double) -> MyColor { .init(red: red, green: green, blue: blue, alpha: alpha) }
}

import CoreGraphics

struct Point: Codable {
    let x: Double
    let y: Double
}

extension Point {
    func cgPoint(in bounds: CGRect) -> CGPoint {
        CGPoint(x: CGFloat(x) * bounds.width, y: CGFloat(y) * bounds.height)
    }
}

extension Transform {
    
    mutating func reset() {
        origin = Point(x: 0.5, y: 0.5)
        zoom = 1.0
    }
    
    // zooming
    
    mutating func startZoom(amount: Double) {
        currentZoomStart = amount
        currentProjectZoom = self.zoom
    }
    
    mutating func updateZoom(amount: Double) {
        let currentZoomAmount = amount - currentZoomStart
        self.zoom = currentProjectZoom + currentZoomAmount
    }
    
    // translate
    
    mutating func startTranslate(point: Point) {
        currentTranslateStart = point
        currentProjectTranslate = self.origin
    }
    
    mutating func updateTranslate(point: Point) {
        
        let xDelta = point.x - currentTranslateStart.x
        let yDelta = point.y - currentTranslateStart.y
        
        let finalX = (currentProjectTranslate.x - (xDelta * 1 / zoom))
        let finalY = (currentProjectTranslate.y + (yDelta * 1 / zoom))
        
        self.origin = Point(x: finalX, y: finalY)
    }
    
    func removeTransformFromPoint(_ point: Point) -> Point {
        
        let spanWithZoom = 1 / self.zoom
        
        let halfSpanWithZoom = spanWithZoom / 2
        
        let minX = self.origin.x - halfSpanWithZoom
        let minY = self.origin.y - halfSpanWithZoom
        
        let finalX = minX + point.x * spanWithZoom
        let finalY = minY + point.y * spanWithZoom
        
        return Point(x: finalX, y: finalY)
    }
    
    func applyTo(_ point: Point) -> Point {
        
        let spanWithZoom = 1 / self.zoom
        
        let halfSpanWithZoom = spanWithZoom / 2
        
        let minX = self.origin.x - halfSpanWithZoom
        let minY = self.origin.y - halfSpanWithZoom
        
        let finalX = (point.x - minX) * 1 / spanWithZoom
        let finalY = (point.y - minY) * 1 / spanWithZoom
        
        return Point(x: finalX, y: finalY)
    }
}
