import UIKit

// Extensions for UIKit.

public extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}

#if DEBUG
public extension UIView {
    
    @discardableResult
    func debugFrame(_ color: UIColor = .red) -> Self {
        layer.borderColor = color.cgColor
        layer.borderWidth = 1
        return self
    }
}
#endif

public extension UIStackView {
    
    func removeAllArrangedSubviews() {
        for subview in arrangedSubviews {
            removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
}

public extension UILabel {
    
    convenience init(text: String) {
        self.init()
        self.text = text
    }
}

public extension UIViewController {
    
    func addSubcontroller(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func removeFromSuper() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}

public extension UIEdgeInsets {
    
    init(inset: CGFloat) {
        self.init(top: inset, left: inset, bottom: inset, right: inset)
    }
}

public extension UISearchController {
    
    var textField: UITextField? {
        return searchBar.value(forKey: "searchField") as? UITextField
    }
}

public extension UITableView {
    
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: T.typeDescription)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(ofType type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: type.typeDescription, for: indexPath) as? T else {
            fatalError("Unable to dequeue table view cell with identifier: \(type.typeDescription)")
        }
        return cell
    }
}

public extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: T.typeDescription)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.typeDescription, for: indexPath) as? T else {
            fatalError("Unable to dequeue reusable collection view cell")
        }
        return cell
    }
}
