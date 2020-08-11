//
//  NSLayoutAnchor+Extension.swift
//  Recademic
//
//  Created by Ignacio Paradisi on 5/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
extension UIView {
    public var anchor: Anchor { return Anchor(view: self) }
}
public struct Anchor {
    public let view: UIView
    public let top: NSLayoutConstraint?
    public let leading: NSLayoutConstraint?
    public let bottom: NSLayoutConstraint?
    public let trailing: NSLayoutConstraint?
    public let height: NSLayoutConstraint?
    public let width: NSLayoutConstraint?
    public let centerX: NSLayoutConstraint?
    public let centerY: NSLayoutConstraint?
    
    fileprivate init(view: UIView) {
        self.view = view
        top = nil
        leading = nil
        bottom = nil
        trailing = nil
        height = nil
        width = nil
        centerX = nil
        centerY = nil
    }
    
    private init(view: UIView, top: NSLayoutConstraint?, leading: NSLayoutConstraint?, bottom: NSLayoutConstraint?,
                 trailing: NSLayoutConstraint?, height: NSLayoutConstraint?, width: NSLayoutConstraint?,
                 centerX: NSLayoutConstraint?, centerY: NSLayoutConstraint?) {
        self.view = view
        self.top = top
        self.leading = leading
        self.bottom = bottom
        self.trailing = trailing
        self.height = height
        self.width = width
        self.centerX = centerX
        self.centerY = centerY
    }
    
    private func update(
        edge: NSLayoutConstraint.Attribute,
        constraint: NSLayoutConstraint?,
        priority: UILayoutPriority? = nil) -> Anchor {
        
        var top = self.top
        var leading = self.leading
        var bottom = self.bottom
        var trailing = self.trailing
        var height = self.height
        var width = self.width
        var centerX = self.centerX
        var centerY = self.centerY
        constraint?.priority = priority ?? .defaultHigh
        
        switch edge {
        case .top: top = constraint
        case .leading: leading = constraint
        case .bottom: bottom = constraint
        case .trailing: trailing = constraint
        case .height: height = constraint
        case .width: width = constraint
        case .centerX: centerX = constraint
        case .centerY: centerY = constraint
        default: return self
        }
        
        return Anchor(
            view: self.view,
            top: top,
            leading: leading,
            bottom: bottom,
            trailing: trailing,
            height: height,
            width: width,
            centerX: centerX,
            centerY: centerY)
    }
    
    private func insert(anchor: Anchor) -> Anchor {
        return Anchor(
            view: self.view,
            top: anchor.top ?? top,
            leading: anchor.leading ?? leading,
            bottom: anchor.bottom ?? bottom,
            trailing: anchor.trailing ?? trailing,
            height: anchor.height ?? height,
            width: anchor.width ?? width,
            centerX: anchor.centerX ?? centerX,
            centerY: anchor.centerY ?? centerY)
    }
    
    // MARK: Anchor to superview edges
    public func topToSuperview(constant: CGFloat = 0, toSafeArea: Bool = false) -> Anchor {
        guard let superview = view.superview else {
            return self
        }
        if #available(iOS 11.0, *), toSafeArea {
            return top(to: superview.safeAreaLayoutGuide.topAnchor, constant: constant)
        }
        return top(to: superview.topAnchor, constant: constant)
    }
    
    public func leadingToSuperview(constant: CGFloat = 0, toSafeArea: Bool = false) -> Anchor {
        guard let superview = view.superview else {
            return self
        }
        if #available(iOS 11.0, *), toSafeArea {
            return leading(to: superview.safeAreaLayoutGuide.leadingAnchor, constant: constant)
        }
        return leading(to: superview.leadingAnchor, constant: constant)
    }
    
    public func bottomToSuperview(constant: CGFloat = 0, toSafeArea: Bool = false) -> Anchor {
        guard let superview = view.superview else {
            return self
        }
        if #available(iOS 11.0, *), toSafeArea {
            return bottom(to: superview.safeAreaLayoutGuide.bottomAnchor, constant: constant)
        }
        return bottom(to: superview.bottomAnchor, constant: constant)
    }
    
    public func trailingToSuperview(constant: CGFloat = 0, toSafeArea: Bool = false) -> Anchor {
        guard let superview = view.superview else {
            return self
        }
        if #available(iOS 11.0, *), toSafeArea {
            return trailing(to: superview.safeAreaLayoutGuide.trailingAnchor, constant: constant)
        }
        return trailing(to: superview.trailingAnchor, constant: constant)
    }
    public func edgesToSuperview(omitEdge edge: NSLayoutConstraint.Attribute = .notAnAttribute,
                                 insets: UIEdgeInsets = .zero, toSafeAreaTop: Bool = false,
                                 toSafeAreaLeading: Bool = false, toSafeAreaBottom: Bool = false,
                                 toSafeAreaTrailing: Bool = false) -> Anchor {
        let superviewAnchors = topToSuperview(constant: insets.top, toSafeArea: toSafeAreaTop)
            .leadingToSuperview(constant: insets.left, toSafeArea: toSafeAreaLeading)
            .bottomToSuperview(constant: insets.bottom, toSafeArea: toSafeAreaBottom)
            .trailingToSuperview(constant: insets.right, toSafeArea: toSafeAreaTrailing)
            .update(edge: edge, constraint: nil)
        return self.insert(anchor: superviewAnchors)
    }
    public func edgesToSuperview(
        omitEdge edge: NSLayoutConstraint.Attribute = .notAnAttribute,
        insets: UIEdgeInsets = .zero, toSafeArea: Bool = false) -> Anchor {
        let superviewAnchors = topToSuperview(constant: insets.top, toSafeArea: toSafeArea)
            .leadingToSuperview(constant: insets.left, toSafeArea: toSafeArea)
            .bottomToSuperview(constant: insets.bottom, toSafeArea: toSafeArea)
            .trailingToSuperview(constant: insets.right, toSafeArea: toSafeArea)
            .update(edge: edge, constraint: nil)
        return self.insert(anchor: superviewAnchors)
    }
    
    // MARK: Anchor to superview axises
    public func centerXToSuperview(constant: CGFloat = 0) -> Anchor {
        guard let superview = view.superview else {
            return self
        }
        return centerX(to: superview.centerXAnchor, constant: constant)
    }
    
    public func centerYToSuperview(constant: CGFloat = 0) -> Anchor {
        guard let superview = view.superview else {
            return self
        }
        return centerY(to: superview.centerYAnchor, constant: constant)
    }
    
    public func centerToSuperview() -> Anchor {
        guard let superview = view.superview else {
            return self
        }
        return centerX(to: superview.centerXAnchor)
            .centerY(to: superview.centerYAnchor)
    }
    
    // MARK: Anchor to
    public func top(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Anchor {
        return update(edge: .top, constraint: view.topAnchor.constraint(equalTo: anchor, constant: constant))
    }
    
    public func leading(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Anchor {
        return update(edge: .leading, constraint: view.leadingAnchor.constraint(equalTo: anchor, constant: constant))
    }
    
    public func bottom(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Anchor {
        return update(edge: .bottom, constraint: view.bottomAnchor.constraint(equalTo: anchor, constant: constant))
    }
    
    public func trailing(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Anchor {
        return update(edge: .trailing, constraint: view.trailingAnchor.constraint(equalTo: anchor, constant: constant))
    }
    
    // MARK: Anchor greaterOrEqual
    public func top(greaterOrEqual anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Anchor {
        return update(edge: .top, constraint: view.topAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant))
    }
    
    public func leading(greaterOrEqual anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Anchor {
        return update(edge: .leading, constraint: view.leadingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant))
    }
    public func bottom(greaterOrEqual anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Anchor {
        return update(edge: .bottom, constraint: view.bottomAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant))
    }
    public func trailing(greaterOrEqual anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Anchor {
        return update(edge: .trailing, constraint: view.trailingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant))
    }
    // MARK: Anchor lessOrEqual
    public func top(lessOrEqual anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Anchor {
        return update(edge: .top, constraint: view.topAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant))
    }
    public func leading(lessOrEqual anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Anchor {
        return update(edge: .leading, constraint: view.leadingAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant))
    }
    public func bottom(lessOrEqual anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Anchor {
        return update(edge: .bottom, constraint: view.bottomAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant))
    }
    public func trailing(lessOrEqual anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Anchor {
        return update(edge: .trailing, constraint: view.trailingAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant))
    }
    // MARK: Dimension anchors
    public func height(constant: CGFloat, priority: UILayoutPriority? = nil) -> Anchor {
        return update(edge: .height, constraint: view.heightAnchor.constraint(equalToConstant: constant), priority: priority)
    }
    public func height(to dimension: NSLayoutDimension, multiplier: CGFloat = 1, priority: UILayoutPriority? = nil) -> Anchor {
        return update(edge: .height, constraint: view.heightAnchor.constraint(equalTo: dimension, multiplier: multiplier),
                      priority: priority)
    }
    public func height(greaterThanOrEqualToConstant constant: CGFloat) -> Anchor {
        return update(edge: .height, constraint: view.heightAnchor.constraint(greaterThanOrEqualToConstant: constant))
    }
    public func height(lessThanOrEqualToConstant constant: CGFloat) -> Anchor {
        return update(edge: .height, constraint: view.heightAnchor.constraint(lessThanOrEqualToConstant: constant))
    }
    public func width(constant: CGFloat, priority: UILayoutPriority? = nil) -> Anchor {
        return update(edge: .width, constraint: view.widthAnchor.constraint(equalToConstant: constant), priority: priority)
    }
    public func width(to dimension: NSLayoutDimension, multiplier: CGFloat = 1) -> Anchor {
        return update(edge: .width, constraint: view.widthAnchor.constraint(equalTo: dimension, multiplier: multiplier))
    }
    public func width(greaterThanOrEqualToConstant constant: CGFloat) -> Anchor {
        return update(edge: .width, constraint: view.widthAnchor.constraint(greaterThanOrEqualToConstant: constant))
    }
    public func width(lessThanOrEqualToConstant constant: CGFloat) -> Anchor {
        return update(edge: .width, constraint: view.widthAnchor.constraint(lessThanOrEqualToConstant: constant))
    }
    // MARK: Axis anchors
    public func centerX(to axis: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Anchor {
        return update(edge: .centerX, constraint: view.centerXAnchor.constraint(equalTo: axis, constant: constant))
    }
    public func centerY(to axis: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Anchor {
        return update(edge: .centerY, constraint: view.centerYAnchor.constraint(equalTo: axis, constant: constant))
    }
    // MARK: Activation
    public func activate(priority: UILayoutPriority? = nil) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints =
            [top, leading, bottom, trailing, height, width, centerX, centerY].compactMap { constraint -> NSLayoutConstraint? in
            let auxConstraint = constraint
            if priority != nil {
                auxConstraint?.priority = priority!
            }
            return auxConstraint
        }
        NSLayoutConstraint.activate(constraints)
    }
    
    public func deactivate(priority: UILayoutPriority? = nil) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints =
            [top, leading, bottom, trailing, height, width, centerX, centerY].compactMap { constraint -> NSLayoutConstraint? in
            let auxConstraint = constraint
            if priority != nil {
                auxConstraint?.priority = priority!
            }
            return auxConstraint
        }
        NSLayoutConstraint.deactivate(constraints)
    }
}
