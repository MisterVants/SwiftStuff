import UIKit

protocol TypeStringConvertible {
    static var typeDescription: String { get }
    var typeDescription: String { get }
}

extension TypeStringConvertible {
    static var typeDescription: String {
        return String(describing: self)
    }
    
    var typeDescription: String {
        return type(of: self).typeDescription
    }
}

extension UIView: TypeStringConvertible {}
