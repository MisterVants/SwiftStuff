//
//  Layout.swift
//
//  Created by André Vants on 03/07/21.
//

import UIKit

// Experimental layout system to simplify the declaration of constraints for views and layout guides.

public protocol Constrainable {
    
    associatedtype Content: Constrainable
    
    var layout: LayoutProxy<Content> { get }
    
    var topAnchor: NSLayoutYAxisAnchor { get }
    
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    
    var leftAnchor: NSLayoutXAxisAnchor { get }
    
    var rightAnchor: NSLayoutXAxisAnchor { get }
    
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    
    var centerYAnchor: NSLayoutYAxisAnchor { get }
    
    var widthAnchor: NSLayoutDimension { get }
    
    var heightAnchor: NSLayoutDimension { get }
}

extension UIView: Constrainable {
    public var layout: LayoutProxy<UIView> {
        LayoutProxy(self)
    }
}

extension UILayoutGuide: Constrainable {
    public var layout: LayoutProxy<UILayoutGuide> {
        LayoutProxy(self)
    }
}

public class LayoutProxy<Content: Constrainable> {
    
    let content: Content
    
    init(_ content: Content) {
        self.content = content
    }
    
    public func constraint(_ block: (LayoutProxy) -> Void) {
        if let view = content as? UIView {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        block(self)
    }
}

extension LayoutProxy {
    
    @discardableResult
    public func edges<Guides: Constrainable>(
        to guides: Guides,
        padding: CGFloat = 0.0
    ) -> [NSLayoutConstraint] {
        edges(to: guides, insets: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
    }
    
    @discardableResult
    public func edges<Guides: Constrainable>(
        to guides: Guides,
        insets: UIEdgeInsets
    ) -> [NSLayoutConstraint] {
        let layout = content.layout
        return [
            layout.top(to: guides.topAnchor, offset: insets.top),
            layout.bottom(to: guides.bottomAnchor, offset: insets.bottom),
            layout.leading(to: guides.leadingAnchor, offset: insets.left),
            layout.trailing(to: guides.trailingAnchor, offset: insets.right)
        ]
    }
    
    @discardableResult
    public func top(
        to anchor: NSLayoutYAxisAnchor,
        offset: CGFloat = 0.0,
        relation: NSLayoutConstraint.Relation = .equal
    ) -> NSLayoutConstraint {
        content.topAnchor.constraint(to: anchor, constant: offset, relation: relation)
    }
    
    @discardableResult
    public func top(
        systemSpacingTo anchor: NSLayoutYAxisAnchor,
        multiplier: CGFloat = 1.0,
        relation: NSLayoutConstraint.Relation = .equal
    ) -> NSLayoutConstraint {
        content.topAnchor.constraint(belowAutoSpacing: anchor, multiplier: multiplier, relation: relation)
    }
    
    @discardableResult
    public func bottom(
        to anchor: NSLayoutYAxisAnchor,
        offset: CGFloat = 0.0,
        relation: NSLayoutConstraint.Relation = .equal)
    -> NSLayoutConstraint {
        content.bottomAnchor.constraint(to: anchor, constant: offset, relation: relation)
    }
    
    @discardableResult
    public func bottom(
        systemSpacingTo anchor: NSLayoutYAxisAnchor,
        multiplier: CGFloat = 1.0,
        relation: NSLayoutConstraint.Relation = .equal
    ) -> NSLayoutConstraint {
//        content.bottomAnchor.constraint(belowAutoSpacing: anchor, multiplier: multiplier, relation: relation)
        anchor.constraint(belowAutoSpacing: content.bottomAnchor, multiplier: multiplier, relation: relation) // needs to be inverted
    }
}

// MARK: Leading Constraints

extension LayoutProxy {
    
    @discardableResult
    public func leading(
        to anchor: NSLayoutXAxisAnchor,
        offset: CGFloat = 0.0,
        relation: NSLayoutConstraint.Relation = .equal
    ) -> NSLayoutConstraint {
        content.leadingAnchor.constraint(to: anchor, constant: offset, relation: relation)
    }
    
    @discardableResult
    public func leading(
        systemSpacingTo anchor: NSLayoutXAxisAnchor,
        multiplier: CGFloat = 1.0,
        relation: NSLayoutConstraint.Relation = .equal
    ) -> NSLayoutConstraint {
        content.leadingAnchor.constraint(afterAutoSpacing: anchor, multiplier: multiplier, relation: relation)
    }
    
    @discardableResult
    public func leading<Guides: Constrainable>(
        alignedTo guides: Guides,
        offset: CGFloat = 0.0,
        relation: NSLayoutConstraint.Relation = .equal
    ) -> NSLayoutConstraint {
        content.leadingAnchor.constraint(to: guides.leadingAnchor, constant: offset, relation: relation)
    }
    
    @discardableResult
    public func leading<Guides: Constrainable>(
        systemSpacingTo guides: Guides,
        multiplier: CGFloat = 1.0,
        relation: NSLayoutConstraint.Relation = .equal
    ) -> NSLayoutConstraint {
        content.leadingAnchor.constraint(afterAutoSpacing: guides.leadingAnchor, multiplier: multiplier, relation: relation)
    }
}

// MARK: Trailing Constraints

extension LayoutProxy {
    
    @discardableResult
    public func trailing(
        to anchor: NSLayoutXAxisAnchor,
        offset: CGFloat = 0.0,
        relation: NSLayoutConstraint.Relation = .equal
    ) -> NSLayoutConstraint {
        anchor.constraint(to: content.trailingAnchor, constant: offset, relation: relation) // invert
    }
    
    @discardableResult
    public func trailing(
        systemSpacingTo anchor: NSLayoutXAxisAnchor,
        multiplier: CGFloat = 1.0,
        relation: NSLayoutConstraint.Relation = .equal
    ) -> NSLayoutConstraint {
        anchor.constraint(afterAutoSpacing: content.trailingAnchor, multiplier: multiplier, relation: relation) // invert
    }
    
    @discardableResult
    public func trailing<Guides: Constrainable>(
        alignedTo guides: Guides,
        offset: CGFloat = 0.0,
        relation: NSLayoutConstraint.Relation = .equal
    ) -> NSLayoutConstraint {
        guides.trailingAnchor.constraint(to: content.trailingAnchor, constant: offset, relation: relation)
    }
    
    @discardableResult
    public func trailing<Guides: Constrainable>(
        systemSpacingTo guides: Guides,
        multiplier: CGFloat = 1.0,
        relation: NSLayoutConstraint.Relation = .equal
    ) -> NSLayoutConstraint {
        guides.trailingAnchor.constraint(afterAutoSpacing: content.trailingAnchor, multiplier: multiplier, relation: relation)
    }
}

// MARK: Center X and Center Y Constraints

extension LayoutProxy {
    
    @discardableResult
    public func centerX(
        to anchor: NSLayoutXAxisAnchor,
        offset: CGFloat = 0.0,
        relation: NSLayoutConstraint.Relation = .equal
    ) -> NSLayoutConstraint {
        content.centerXAnchor.constraint(to: anchor, constant: offset, relation: relation)
    }
    
    @discardableResult
    public func centerX<Guides: Constrainable>(
        on guides: Guides,
        offset: CGFloat = 0.0,
        relation: NSLayoutConstraint.Relation = .equal
    ) -> NSLayoutConstraint {
        content.centerXAnchor.constraint(to: guides.centerXAnchor, constant: offset, relation: relation)
    }
    
    @discardableResult
    public func centerY(
        to anchor: NSLayoutYAxisAnchor,
        offset: CGFloat = 0.0,
        relation: NSLayoutConstraint.Relation = .equal
    ) -> NSLayoutConstraint {
        content.centerYAnchor.constraint(to: anchor, constant: offset, relation: relation)
    }
    
    @discardableResult
    public func centerY<Guides: Constrainable>(
        on guides: Guides,
        offset: CGFloat = 0.0,
        relation: NSLayoutConstraint.Relation = .equal
    ) -> NSLayoutConstraint {
        content.centerYAnchor.constraint(to: guides.centerYAnchor, constant: offset, relation: relation)
    }
}

extension LayoutProxy {
    
    @discardableResult
    func width(
        _ constant: CGFloat,
        relation: NSLayoutConstraint.Relation = .equal
    ) -> NSLayoutConstraint {
        content.widthAnchor.constraint(toConstant: constant, relation: relation)
    }
    
    @discardableResult
    func width(
        toDimension dimension: NSLayoutDimension,
        multiplier: CGFloat = 1.0,
        constant: CGFloat = 0.0,
        relation: NSLayoutConstraint.Relation = .equal
    ) -> NSLayoutConstraint {
        content.widthAnchor.constraint(toDimension: dimension, multiplier: multiplier, constant: constant, relation: relation)
    }
    
    @discardableResult
    public func height(
        _ constant: CGFloat,
        relation: NSLayoutConstraint.Relation = .equal
    ) -> NSLayoutConstraint {
        content.heightAnchor.constraint(toConstant: constant, relation: relation)
    }
    
    @discardableResult
    public func height(
        toDimension dimension: NSLayoutDimension,
        multiplier: CGFloat = 1.0,
        constant: CGFloat = 0.0,
        relation: NSLayoutConstraint.Relation = .equal
    ) -> NSLayoutConstraint {
        content.heightAnchor.constraint(toDimension: dimension, multiplier: multiplier, constant: constant, relation: relation)
    }
}

// MARK: Baseline Constraints

extension LayoutProxy where Content == UIView {
    
    @discardableResult
    public func firstBaseline(
        to anchor: NSLayoutYAxisAnchor,
        offset: CGFloat = 0.0,
        relation: NSLayoutConstraint.Relation = .equal
    ) -> NSLayoutConstraint {
        content.firstBaselineAnchor.constraint(to: anchor, constant: offset, relation: relation)
    }
    
    @discardableResult
    public func firstBaseline(
        systemSpacingTo anchor: NSLayoutYAxisAnchor,
        multiplier: CGFloat = 1.0,
        relation: NSLayoutConstraint.Relation = .equal
    ) -> NSLayoutConstraint {
        content.firstBaselineAnchor.constraint(belowAutoSpacing: anchor, multiplier: multiplier, relation: relation)
    }
    
    @discardableResult
    public func lastBaseline(
        to anchor: NSLayoutYAxisAnchor,
        offset: CGFloat = 0.0,
        relation: NSLayoutConstraint.Relation = .equal
    ) -> NSLayoutConstraint {
        anchor.constraint(to: content.lastBaselineAnchor, constant: offset, relation: relation)
    }
    
    @discardableResult
    public func lastBaseline(
        systemSpacingTo anchor: NSLayoutYAxisAnchor,
        multiplier: CGFloat = 1.0,
        relation: NSLayoutConstraint.Relation = .equal
    ) -> NSLayoutConstraint {
        anchor.constraint(belowAutoSpacing: content.lastBaselineAnchor, multiplier: multiplier, relation: relation)
    }
}

// NSLayout+Extension

extension NSLayoutYAxisAnchor {
    
    func constraint(
        to anchor: NSLayoutYAxisAnchor,
        constant: CGFloat,
        relation: NSLayoutConstraint.Relation
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        switch relation {
        case .equal:
            constraint = self.constraint(equalTo: anchor, constant: constant)
        case .greaterThanOrEqual:
            constraint = self.constraint(greaterThanOrEqualTo: anchor, constant: constant)
        case .lessThanOrEqual:
            constraint = self.constraint(lessThanOrEqualTo: anchor, constant: constant)
        @unknown default:
            fatalError()
        }
        constraint.isActive = true
        return constraint
    }
    
    func constraint(
        belowAutoSpacing anchor: NSLayoutYAxisAnchor,
        multiplier: CGFloat,
        relation: NSLayoutConstraint.Relation
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        switch relation {
        case .equal:
            constraint = self.constraint(equalToSystemSpacingBelow: anchor, multiplier: multiplier)
        case .greaterThanOrEqual:
            constraint = self.constraint(greaterThanOrEqualToSystemSpacingBelow: anchor, multiplier: multiplier)
        case .lessThanOrEqual:
            constraint = self.constraint(lessThanOrEqualToSystemSpacingBelow: anchor, multiplier: multiplier)
        @unknown default:
            fatalError()
        }
        constraint.isActive = true
        return constraint
    }
}

extension NSLayoutXAxisAnchor {
    
    func constraint(
        to anchor: NSLayoutXAxisAnchor,
        constant: CGFloat,
        relation: NSLayoutConstraint.Relation
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        switch relation {
        case .equal:
            constraint = self.constraint(equalTo: anchor, constant: constant)
        case .greaterThanOrEqual:
            constraint = self.constraint(greaterThanOrEqualTo: anchor, constant: constant)
        case .lessThanOrEqual:
            constraint = self.constraint(lessThanOrEqualTo: anchor, constant: constant)
        @unknown default:
            fatalError()
        }
        constraint.isActive = true
        return constraint
    }
    
    func constraint(
        afterAutoSpacing anchor: NSLayoutXAxisAnchor,
        multiplier: CGFloat,
        relation: NSLayoutConstraint.Relation
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        switch relation {
        case .equal:
            constraint = self.constraint(equalToSystemSpacingAfter: anchor, multiplier: multiplier)
        case .greaterThanOrEqual:
            constraint = self.constraint(greaterThanOrEqualToSystemSpacingAfter: anchor, multiplier: multiplier)
        case .lessThanOrEqual:
            constraint = self.constraint(lessThanOrEqualToSystemSpacingAfter: anchor, multiplier: multiplier)
        @unknown default:
            fatalError()
        }
        constraint.isActive = true
        return constraint
    }
}

extension NSLayoutDimension {
    
    func constraint(toConstant c: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        switch relation {
        case .equal:
            constraint = self.constraint(equalToConstant: c)
        case .greaterThanOrEqual:
            constraint = self.constraint(greaterThanOrEqualToConstant: c)
        case .lessThanOrEqual:
            constraint = self.constraint(lessThanOrEqualToConstant: c)
        @unknown default:
            fatalError()
        }
        constraint.isActive = true
        return constraint
    }
    
    func constraint(toDimension d: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        switch relation {
        case .equal:
            constraint = self.constraint(equalTo: d, multiplier: multiplier, constant: constant)
        case .greaterThanOrEqual:
            constraint = self.constraint(greaterThanOrEqualTo: d, multiplier: multiplier, constant: constant)
        case .lessThanOrEqual:
            constraint = self.constraint(lessThanOrEqualTo: d, multiplier: multiplier, constant: constant)
        @unknown default:
            fatalError()
        }
        constraint.isActive = true
        return constraint
    }
}
