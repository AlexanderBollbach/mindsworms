import Foundation

protocol ViewFrameUpdatorDelegate: class {
    func frameUpdated()
}

class RealTimeViewUpdator {
    
    weak var delegate: ViewFrameUpdatorDelegate?
    
    init(delegate: ViewFrameUpdatorDelegate) { self.delegate = delegate }
    
    @objc func update() { delegate?.frameUpdated() }
}
