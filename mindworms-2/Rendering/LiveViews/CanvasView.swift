import UIKit
import SwiftUI

enum CanvasViewAction {
    case layer(LayerAction)
    case project(ProjectAction)
    
    var toAppAction: AppAction {
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

class CanvasView_UIKit: UIView {
    var state: Project {
        didSet { projectRW.updateProject(state) }
    }
    let send: (CanvasViewAction) -> Void
    private let projectRW = ProjectRenderingUIView(framerate: 30)
    var currentPoint = Point(x: 0, y: 0)
    
    init(state: Project, send: @escaping (CanvasViewAction) -> Void) {
        self.state = state
        self.send = send
        super.init(frame: .zero)
        projectRW.pinTo(superView: self)
        projectRW.updateProject(state)
        setupGestures()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { if let point = touches.first?.location(in: self) { dispatchNewPoint(point: point, began: true) } }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { if let point = touches.first?.location(in: self) { dispatchNewPoint(point: point) } }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { if let point = touches.first?.location(in: self) { dispatchNewPoint(point: point) } }
    
    private func dispatchNewPoint(point: CGPoint, began: Bool = false) {
        if self.state.mode == .moving { return }
        
        let p = Point(
            x: Double(point.x / bounds.width),
            y: Double(1 - point.y / bounds.height)
        )
        
        let point = self.state.transform.removeTransformFromPoint(p)
        
        switch self.state.mode {
        case .drawing: dispatchDraw(point: point, began: began)
        case .moving: break
        case .lasso: dispatchLasso(point: point, began: began)
        }
    }
    
    private func dispatchDraw(point: Point, began: Bool = false) {
        if began {
            let id = self.state.paths.count
            send(.layer(.paths(.deselectAll)))
            send(.layer(.paths(.create(id: id))))
            send(.layer(.paths(.select(id: id))))
        }
        
        let minDelta = 0.02
        if abs(point.x - self.currentPoint.x) < minDelta && abs(point.y - self.currentPoint.y) < minDelta { return }
        currentPoint = point
        send(.layer(.paths(.selected(.addPoint(point)))))
    }
    
    private func dispatchLasso(point: Point, began: Bool = false) {
//        if began { store.send(.clearLasso) }
//        store.send(.addToLasso(point))
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
