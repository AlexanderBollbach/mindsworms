import Foundation
import UIKit

struct Workspace: Identifiable {
    let id: UUID
    var projects = Relation()
}

struct AppState {
    var workspaces = [Workspace(id: UUID())]
    var projects = [Project]()
    var layers = [Layer]()
    var effects = [Effect]()
    var attributes = [Attribute]()
}

// MARK: - project -

enum ProjectMode {
    case drawing
    case moving
    case lasso
    
    mutating func toggleMoving() {
        if self == .moving {
            self = .drawing
        } else {
            self = .moving
        }
    }
}

struct Project: Identifiable {
    let id: UUID
    var name: String
    var settings: ProjectSettings
    var transform = Transform()
    var mode: ProjectMode
    var layers: Relation
    
    init(
        id: UUID = UUID(),
        name: String = "project",
        settings: ProjectSettings = ProjectSettings(),
        mode: ProjectMode = .drawing,
        layers: Relation = Relation()
    ) {
        self.id = id
        self.name = name
        self.settings = settings
        self.mode = mode
        self.layers = layers
    }
}

// MARK: - layer -

struct Layer: Identifiable {
    var id = UUID()
    var name = "layer"
    var color = MyColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var isMuted = false
    var effects = Relation()
}

extension Project {
    mutating func recomputeLasso() {
//        layers.selected = self.lasso.select(layers: self.layers.all)
    }
    
//    func withSoloedLayer(id: UUID) -> Project {
//        var project = self
//        project.layers = layers.map {
//            var layer = $0
//            if layer.id != id {
//                layer.isMuted = true
//            }
//            return layer
//        }
//        return project
//    }
    
//    func withLowFi() -> Project {
//        var project = self
//        project.settings = ProjectSettings(canvasWidth: 10, canvasHeight: 10)
//        return project
//    }
}


struct ProjectSettings: Codable, Equatable {
    var canvasWidth: Int
    var canvasHeight: Int
    var videoWidth: Int
    var videoHeight: Int
    var numFrames: Int
    var framerateOutput: Int
    var framerateLive: Int
    var destinationPath: String
    
    init(canvasWidth: Int = 1000,
         canvasHeight: Int = 1000,
         videoWidth: Int = 16 * 50,
         videoHeight: Int = 16 * 50,
         numFrames: Int = 50,
         framerateOutput: Int = 30,
         framerateLive: Int = 30,
         destinationPath: String = "/Users/alexanderbollbach/Desktop") {
        
        self.canvasWidth = canvasWidth.nearest16
        self.canvasHeight = canvasHeight.nearest16
        self.videoWidth = videoWidth.nearest16
        self.videoHeight = videoHeight.nearest16
        self.numFrames = numFrames
        self.framerateOutput = framerateOutput
        self.framerateLive = framerateLive
        self.destinationPath = destinationPath
    }
}


//private extension Effect {
//    func attributeValue(for name: String) -> Double? { attributes.value(for: name) }
//}


struct Attribute: Identifiable {
    let id: UUID
    let name: String
    var value: Double
    
    init(id: UUID = UUID(), name: String = "attribute", value: Double = 0.0) {
        self.id = id
        self.name = name
        self.value = value
    }
}


extension Array where Element == Attribute {
    func value(for name: String) -> Double? { first(where: { $0.name == name })?.value }
}
 
// MARK: - drawing -

struct MyColor {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
    
    var uicolor: UIColor { UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha)) }
    
    func with(alpha: Double) -> MyColor { .init(red: red, green: green, blue: blue, alpha: alpha) }
}

import CoreGraphics

struct Point {
    let x: Double
    let y: Double
}

extension Point {
    func cgPoint(in bounds: CGRect) -> CGPoint {
        CGPoint(x: CGFloat(x) * bounds.width, y: CGFloat(y) * bounds.height)
    }
}


// MARK: - transform -

struct Transform {
    
    var origin = Point(x: 0.5, y: 0.5)
    var zoom = 1.0
    
    var currentZoomStart = 0.0
    var currentProjectZoom = 0.0
    
    var currentTranslateStart = Point(x: 0.5, y: 0.5)
    var currentProjectTranslate = Point(x: 0.5, y: 0.5)
    
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

