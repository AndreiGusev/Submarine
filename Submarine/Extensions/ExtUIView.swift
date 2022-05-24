import UIKit

extension UIView {
    
    func addParalax(shift: Int = 20) {
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -shift
        horizontal.maximumRelativeValue = -shift
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -shift
        vertical.maximumRelativeValue = -shift
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        addMotionEffect(group)
    }
    
    func roundCorners(radius: CGFloat = 20) {
        self.layer.cornerRadius = radius
    }
    
    func setGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.cornerRadius = 20
        gradient.colors = [UIColor.red.cgColor,
                           UIColor.orange.cgColor,
                           UIColor.yellow.cgColor
        ]
        gradient.opacity = 0.7
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func dropShadow() {
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 1, height: 5) // Сдвиг тени
        self.layer.shouldRasterize = true // Пикселизация
        self.layer.shadowColor = UIColor.black.cgColor
    }
    
}
