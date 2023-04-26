//
//  UIView+Constraints.swift
//  Created by Vinicius Gibran on 10/10/2020.
//

import UIKit

extension UIView {
    func prepareForConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func pinEdgesToSuperview(_ offset: CGFloat = 0.0) {
        guard let superview = self.superview else {
            return
        }
        prepareForConstraints()
        self.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: offset).isActive = true
        self.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -offset).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -offset).isActive = true
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: offset).isActive = true
    }
    
    @discardableResult
    func centerVertically(_ offset: CGFloat = 0.0) -> NSLayoutConstraint? {
        guard let superview = self.superview else {
            return nil
        }
        
        prepareForConstraints()
        let constraint = self.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func centerVertically(inRelationTo: UIView, _ offset: CGFloat = 0.0) -> NSLayoutConstraint? {
        prepareForConstraints()
        
        let superview = inRelationTo
        let constraint = self.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: offset)
        
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func centerHorizontally(_ offset: CGFloat = 0.0) -> NSLayoutConstraint? {
        guard let superview = self.superview else {
            return nil
        }
        
        prepareForConstraints()
        let constraint = self.centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
    
    func centerToSuperView() {
        centerHorizontally()
        centerVertically()
    }
    
    @discardableResult
    func pinLeft(_ offset: CGFloat = 0.0) -> NSLayoutConstraint? {
        guard let superview = self.superview else {
            return nil
        }
        
        prepareForConstraints()
        let constraint = self.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func pinfLeftInRelationTo(heightAnchor: NSLayoutXAxisAnchor, constant: CGFloat) -> NSLayoutConstraint? {
        prepareForConstraints()
        let constraint = self.leftAnchor.constraint(equalTo: heightAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func pinRight(_ offset: CGFloat = 0.0) -> NSLayoutConstraint? {
        guard let superview = self.superview else {
            return nil
        }
        
        prepareForConstraints()
        let constraint = self.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -offset)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func pinTop(_ offset: CGFloat = 0.0, target: UIView? = nil) -> NSLayoutConstraint? {
        guard let superview = self.superview else {
            return nil
        }
        
        prepareForConstraints()
        var constraint: NSLayoutConstraint?
        
        if let target = target {
            constraint = self.topAnchor.constraint(equalTo: target.bottomAnchor, constant: offset)
        } else {
            constraint = self.topAnchor.constraint(equalTo: superview.topAnchor, constant: offset)
        }
        
        constraint?.isActive = true
        return constraint
    }
    
    @discardableResult
    func pinBottom(_ offset: CGFloat = 0.0) -> NSLayoutConstraint? {
        guard let superview = self.superview else {
            return nil
        }
        
        prepareForConstraints()
        let constraint = self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -offset)
        constraint.isActive = true
        return constraint
    }
    
    //pin to safe area on bottom of screen
    @discardableResult
    func pinSafeBottom(_ offset: CGFloat = 0.0) -> NSLayoutConstraint? {
        guard let superview = self.superview else {
            return nil
        }
        
        prepareForConstraints()
        let constraint = self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -offset)
        constraint.isActive = true
        return constraint
    }
    
    //pin to safe area on top of screen
    @discardableResult
    func pinSafeTop(_ offset: CGFloat = 0.0) -> NSLayoutConstraint? {
        guard let superview = self.superview else {
            return nil
        }
        
        prepareForConstraints()
        let constraint = self.topAnchor.constraint(equalTo: superview.safeTopAnchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func alignLeading(_ offset: CGFloat = 0.0, target: UIView) -> NSLayoutConstraint? {
        guard self.superview != nil else {
            return nil
        }
        
        prepareForConstraints()
        var constraint: NSLayoutConstraint?
        constraint = self.leadingAnchor.constraint(equalTo: target.leadingAnchor, constant: offset)
        constraint?.isActive = true
        return constraint
    }
    
    @discardableResult
    func alignTrailing(_ offset: CGFloat = 0.0, target: UIView) -> NSLayoutConstraint? {
        guard self.superview != nil else {
            return nil
        }
        
        prepareForConstraints()
        var constraint: NSLayoutConstraint?
        constraint = self.trailingAnchor.constraint(equalTo: target.trailingAnchor, constant: offset)
        constraint?.isActive = true
        return constraint
    }
    
    @discardableResult
    func constraintHeight(_ toConstant: CGFloat) -> NSLayoutConstraint? {
        prepareForConstraints()
        let constraint = self.heightAnchor.constraint(equalToConstant: toConstant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func constraintWidth(_ toConstant: CGFloat) -> NSLayoutConstraint? {
        prepareForConstraints()
        let constraint = self.widthAnchor.constraint(equalToConstant: toConstant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func squareViewConstraint() -> NSLayoutConstraint? {
        prepareForConstraints()
        let constraint = self.widthAnchor.constraint(equalTo: self.heightAnchor)
        constraint.isActive = true
        return constraint
    }
    
    func roundView() {
        self.layer.cornerRadius = self.frame.height / 2.0
        self.clipsToBounds = true
    }
    
    func roundCorner(_ value: CGFloat = 5) {
        self.layer.cornerRadius = value
        self.clipsToBounds = true
    }
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        } else {
            return self.topAnchor
        }
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.leftAnchor
        } else {
            return self.leftAnchor
        }
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.rightAnchor
        } else {
            return self.rightAnchor
        }
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        } else {
            return self.bottomAnchor
        }
    }
}
