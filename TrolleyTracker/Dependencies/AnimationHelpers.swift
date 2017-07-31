//
//  AnimationHelpers.swift
//  Created by Austin on 5/6/17.
//

import UIKit

extension UIViewController {

    func setVisible(visible: Bool,
                    animated: Bool,
                    duration: TimeInterval = 0.25,
                    visibleConstraint: NSLayoutConstraint?,
                    hiddenConstraint: NSLayoutConstraint?) {

        if visible {
            hiddenConstraint?.isActive = false
            visibleConstraint?.isActive = true
        }
        else {
            visibleConstraint?.isActive = false
            hiddenConstraint?.isActive = true
        }

        guard animated else {
            view.layoutIfNeeded(); return
        }

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
}

extension UIView {

    static func setViews(hidden: [UIView], visible: [UIView],
                         animated: Bool = true,
                         duration: TimeInterval = 0.1) {

        for view in visible {
            view.alpha = 0
            view.isHidden = false
        }

        let animations = {
            for view in hidden {
                view.alpha = 0
            }
            for view in visible {
                view.alpha = 1
            }
        }

        let completion: (Bool) -> Void = { _ in
            for view in hidden {
                view.alpha = 1
                view.isHidden = true
            }
        }

        if animated {
            UIView.animate(withDuration: duration, animations: animations, completion: completion)
        }
        else {
            animations()
            completion(true)
        }
    }

    func pop(scale: CGFloat = 1.25,
             duration: TimeInterval = 0.25,
             completion: ((Bool) -> Void)? = nil) {

        let originalTransform = transform

        let firstAnimation = {
            self.transform = originalTransform.scaledBy(x: scale, y: scale)
        }
        let secondAnimation = {
            self.transform = originalTransform
        }

        UIView.animate(withDuration: duration / 3, animations: firstAnimation) { _ in
            UIView.animate(withDuration: duration / 1.5,
                           delay: 0,
                           usingSpringWithDamping: 0.3,
                           initialSpringVelocity: 1,
                           options: [],
                           animations: secondAnimation,
                           completion: completion)
        }
    }
}
