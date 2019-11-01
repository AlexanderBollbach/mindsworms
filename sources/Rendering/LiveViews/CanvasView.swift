import UIKit
import SwiftUI

enum CanvasViewAction {
    case layer(LayerAction)
    case project(ProjectAction)
    
    var appAction: AppAction {
        switch self {
        case let .layer(action): return .activeLayers(.selected(action))
        case let .project(action): return .activeProjects(.selected(action))
        }
    }
}

struct CanvasView: UIViewRepresentable {
    typealias UIViewType = CanvasView_UIKit
    @ObservedObject var store: Store<Project, CanvasViewAction>
    
    func makeUIView(context: UIViewRepresentableContext<CanvasView>) -> CanvasView.UIViewType {
        return CanvasView_UIKit(
            state: store.value,
            send: self.store.send
        )
    }
    
    func updateUIView(_ uiView: CanvasView.UIViewType, context: UIViewRepresentableContext<CanvasView>) {
        uiView.state = store.value
    }
}

class PathView: UIView {
    
    var points = [Point]()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        ctx.setStrokeColor(UIColor.white.cgColor)
        
        for point in points.enumerated() {
            var p = point.element.cgPoint(in: bounds)
            p.y = bounds.height - p.y
            if point.offset == 0 {
                ctx.move(to: p)
                continue
            } else {
                ctx.addLine(to: p)
            }
        }
        
        ctx.strokePath()
    }
}

class CanvasView_UIKit: UIView {
    var state: Project {
        didSet { projectRW.updateProject(state) }
    }
    let send: (CanvasViewAction) -> Void
    private let projectRW = ProjectRenderingUIView(framerate: 30)
    var currentPoint = Point(x: 0, y: 0)
    
    var tempPath = [Point]() {
        didSet {
            pathView.points = tempPath
            pathView.setNeedsDisplay()
        }
    }
    
    private let pathView = PathView()
    
    init(state: Project, send: @escaping (CanvasViewAction) -> Void) {
        self.state = state
        self.send = send
        super.init(frame: .zero)
        projectRW.pinTo(superView: self)
        projectRW.updateProject(state)
        setupGestures()
        pathView.pinTo(superView: self)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.state.mode == .moving { return }
        if let point = touches.first?.location(in: self) {
            tempPath = [format(point)]
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.state.mode == .moving { return }
        if let point = touches.first?.location(in: self) {
            tempPath.append(format(point))
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        tempPath.append(format(point))
       
        let points = tempPath // TODO format/reduce num
        
        send(.layer(.paths(.insert(MyPath(id: genID(), points: points, isSelected: true)))))
        
        tempPath = []
    }
    
    private func format(_ point: CGPoint) -> Point {
        state.transform.removeTransformFromPoint(
            Point(
                x: Double(point.x / bounds.width),
                y: Double(1 - point.y / bounds.height)
            )
        )
    }
}

extension CanvasView_UIKit {
    private func setupGestures() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinched))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panned))
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        
        pan.minimumNumberOfTouches = 1
        pan.cancelsTouchesInView = false
        tap.numberOfTapsRequired = 2
        
        add([pinch, pan, tap])
    }

    @objc private func pinched(rec: UIPinchGestureRecognizer) {
        
        guard state.mode == .moving else { return }
        
        if rec.state == .began {
            send(.project(.transform(.startZoom(Double(rec.scale)))))
        } else {
            send(.project(.transform(.updateZoom(Double(rec.scale)))))
        }
    }
    
    @objc private func panned(rec: UIPanGestureRecognizer) {
        
        guard state.mode == .moving else { return }
        
        let cgpoint = rec.location(in: self)
        
        let point = Point(
            x: Double(cgpoint.x / bounds.width),
            y: Double(cgpoint.y / bounds.height)
        )
        
        if rec.state == .began {
            send(.project(.transform(.startTranslate(point))))
        } else {
            send(.project(.transform(.updateTranslate(point))))
        }
    }
    
    @objc private func tapped() {
        send(.project(.transform(.reset)))
    }
}

extension UIView { func add(_ gestures: [UIGestureRecognizer]) { for g in gestures { addGestureRecognizer(g) } } }
