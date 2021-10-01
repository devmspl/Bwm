import UIKit

extension UIColor {
    
    convenience init(_ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat = 1.0) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / CGFloat(255), green: CGFloat(green) / CGFloat(255), blue: CGFloat(blue) / CGFloat(255), alpha: alpha)
    }
    
    convenience init(_ white: Int, _ alpha: CGFloat = 1.0) {
        assert(white >= 0 && white <= 255, "Invalid white component")
        self.init(white, white, white, alpha)
    }
    
    convenience init(hex: Int) {
        self.init((hex >> 16) & 0xff, (hex >> 8) & 0xff, hex & 0xff)
    }
    
}

extension UIColor {
    
    class var swYellow: UIColor {
        return UIColor.init(254, 207, 51)
    }
    
    class var appRed: UIColor {
        return UIColor(210,0,13)
    }
    
    class var lightRed: UIColor {
        return UIColor(238, 72, 88)
    }
    
}
