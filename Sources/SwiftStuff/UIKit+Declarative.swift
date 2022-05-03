import UIKit

// Extensions to modify properties of UIKit view classes in a declarative way.

public extension UILabel {
    
    convenience init(_ text: String) {
        self.init()
        self.text = text
    }
    
    func text(_ text: String) -> Self {
        self.text = text
        return self
    }
    
    func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    func color(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    func alignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }
    
    func lineBreak(_ mode: NSLineBreakMode) -> Self {
        self.lineBreakMode = mode
        return self
    }
    
    func lineLimit(_ number: Int) -> Self {
        self.numberOfLines = number
        return self
    }
}

public extension UIImageView {
    
    func contentMode(_ mode: ContentMode) -> Self {
        self.contentMode = mode
        return self
    }
}

public extension UIView {
    
    convenience init(backgroundColor: UIColor) {
        self.init()
        self.backgroundColor = backgroundColor
    }
}

