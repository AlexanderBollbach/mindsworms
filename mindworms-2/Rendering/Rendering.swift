import UIKit


struct RenderProps {
    var paths: [MyPath]
    var color: MyColor
    var strokeWidth: Double
    
    init(from layer: R_Layer) {
        self.paths = layer.paths
        self.strokeWidth = 1.0
        self.color = layer.color
    }
}

class Renderer {

    var env = defaultRE()
    
    func render(project: R_Project) -> CGImage? {
        
        env.transform = project.transform
    
        env.context.clear(env.rect)
        
        for layer in project.layers where !layer.isMuted {
            renderLayer(layer)
        }
        
        return env.context.makeImage()
    }
    
    func renderLayer(_ layer: R_Layer) {
        var props = RenderProps(from: layer)
        
        for effect in layer.effects {
            effect.run(&props)
        }
        
        render(props)
    }

    func render(_ props: RenderProps) {
        for path in props.paths {
            render(
                path: path,
                color: props.color.uicolor.cgColor,
                lineWidth: props.strokeWidth
            )
        }
    }
    
    func render(path: MyPath, color: CGColor, lineWidth: Double) {
        env.context.setLineWidth(CGFloat(lineWidth))
        env.context.setStrokeColor(color)
        env.context.setLineCap(.round)
        env.context.setLineJoin(.bevel)
        
        for point in path.points.enumerated() {
            
            let p = env.transform.applyTo(point.element).cgPoint(in: env.rect)
            
            if point.offset == 0 {
                env.context.move(to: p)
            } else {
                env.context.addLine(to: p)
            }
        }
        
        env.context.strokePath()
    }
}

