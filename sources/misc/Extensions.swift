
import UIKit

extension UIView {
    
    func pinTo(superView: UIView) {
        let insets: CGFloat = 0
        superView.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.leftAnchor.constraint(equalTo: superView.leftAnchor, constant: insets).isActive = true
        self.rightAnchor.constraint(equalTo: superView.rightAnchor, constant: -insets).isActive = true
        self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -insets).isActive = true
        self.topAnchor.constraint(equalTo: superView.topAnchor, constant: insets).isActive = true
    }
}
