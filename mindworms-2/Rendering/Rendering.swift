import UIKit
//
//struct RenderingLayer {
//    let paths: [MyPath]
//}
//
struct RenderProps {
    var paths: [MyPath]
    var color: MyColor
    var strokeWidth: Double
    
//    init(from layer: RenderingLayer) {
//        self.paths = layer.paths
//        self.strokeWidth = 1.0
//        self.color = layer.color
//    }
}
//
class Renderer {
//    
//    var env: RenderingEnvironment = defaultRE()
//    
//    func render(project: Project) -> CGImage? {
//        
//        env.context.clear(env.rect)
//        
//        for layer in project.layers where !layer.isMuted {
//            renderLayer(layer)
//        }
//        
//        return env.context.makeImage()
//    }
//    
//    func renderLayer(_ layer: Layer) {
//        var props = RenderProps(from: layer)
//        
//        for effect in layer.effects {
//            if let ef = effectFunctions[effect.name] {
//                ef(&props, effect.attributes, effect.parameters as Any)
//            }
//        }
//        
//        render(props)
//    }
//    
    func render(_ props: RenderProps) {
//        for path in props.paths {
//            render(
//                path: path,
//                color: props.color.uicolor.cgColor,
//                lineWidth: props.strokeWidth
//            )
//        }
    }
//    
//    func render(path: MyPath, color: CGColor, lineWidth: Double) {
//        env.context.setLineWidth(CGFloat(lineWidth))
//        env.context.setStrokeColor(color)
//        env.context.setLineCap(.round)
//        env.context.setLineJoin(.bevel)
//        
//        for point in path.points.enumerated() {
//            
//            let p = env.transform.applyTo(point.element).cgPoint(in: env.rect)
//            
//            if point.offset == 0 {
//                env.context.move(to: p)
//            } else {
//                env.context.addLine(to: p)
//            }
//        }
//        
//        env.context.strokePath()
//    }
}

