//
//  AutoLayoutHelpers.swift
//  Created by Austin on 5/6/17.
//

import UIKit

extension UIViewController {

    func addAndPin(_ viewController: UIViewController, to container: UIView? = nil) {
        let containerView = container ?? view
        addChildViewController(viewController)
        containerView?.addSubview(viewController.view)
        containerView?.pin(view: viewController.view)
        viewController.didMove(toParentViewController: self)
    }
}

extension UIView {

    func useAutolayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }

    public convenience init(usingAutolayout: Bool) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = !usingAutolayout
    }

    public static func flexibleView() -> UIView {
        let v = UIView().useAutolayout()
        v.backgroundColor = .clear
        v.setContentHuggingPriority(UILayoutPriority(rawValue: 1), for: .vertical)
        v.setContentHuggingPriority(UILayoutPriority(rawValue: 1), for: .horizontal)
        v.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1), for: .vertical)
        v.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1), for: .horizontal)
        return v
    }

    public static func spacerView(height: CGFloat) -> UIView {
        let v = UIView().useAutolayout()
        v.backgroundColor = .clear
        v.heightAnchor == height
        return v
    }

    public static func spacerView(width: CGFloat) -> UIView {
        let v = UIView().useAutolayout()
        v.backgroundColor = .clear
        v.widthAnchor == width
        return v
    }

    public static func container() -> UIView {
        let v = UIView().useAutolayout()
        v.backgroundColor = .clear
        return v
    }

    public func pin(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.edgeAnchors == edgeAnchors
    }

    func updateLayout(animated: Bool = true, duration: TimeInterval = 0.25) {
        if animated { UIView.animate(withDuration: duration) { self.layoutIfNeeded() } }
        else { layoutIfNeeded() }
    }
}
