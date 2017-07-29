//
//  KeyboardHandler.swift
//  Created by Austin Younts on 5/29/17.
//

import UIKit

extension UIViewController {

    var keyboardLayoutGuide: UILayoutGuide {
        let handler = KeyboardHandler.shared

        if let guide = handler.guide(for: self) {
            return guide.guide
        }

        let guide = createKeyboardGuide()

        handler.add(guide: guide)

        return guide.guide
    }

    fileprivate func createKeyboardGuide() -> KeyboardGuide {

        let g = UILayoutGuide()
        view.addLayoutGuide(g)
        g.bottomAnchor == view.bottomAnchor
        g.horizontalAnchors == view.horizontalAnchors

        let height = g.heightAnchor == 0

        return KeyboardGuide(guide: g, height: height)
    }
}

private class KeyboardHandler: NSObject {

    static let shared: KeyboardHandler = .init()

    private var layoutGuides: [KeyboardGuide] = []

    override private init() {
        super.init()
        registerKeyboardHandlers()
    }

    private func registerKeyboardHandlers() {

        let nc = NotificationCenter.default

        nc.addObserver(self, selector: #selector(handleKeyboardNotification(_:)),
                       name: .UIKeyboardWillShow, object: nil)
        nc.addObserver(self, selector: #selector(handleKeyboardNotification(_:)),
                       name: .UIKeyboardWillHide, object: nil)
        nc.addObserver(self, selector: #selector(handleKeyboardNotification(_:)),
                       name: .UIKeyboardWillChangeFrame, object: nil)
    }

    @objc private func handleKeyboardNotification(_ note: Notification) {
        cleanupLayoutGuides()
        let info = KeyboardInfo(notification: note)
        for guide in layoutGuides {
            guide.update(withInfo: info)
        }
    }

    private func cleanupLayoutGuides() {

        var tempGuides = layoutGuides

        for guide in layoutGuides {
            guard guide.guide.owningView == nil else {
                continue
            }
            if let index = tempGuides.index(of: guide) {
                tempGuides.remove(at: index)
            }
        }

        layoutGuides = tempGuides
    }

    func guide(for viewController: UIViewController) -> KeyboardGuide? {
        cleanupLayoutGuides()
        return layoutGuides.filter { $0.guide.owningView == viewController.view }.first
    }

    func add(guide: KeyboardGuide) {
        layoutGuides.append(guide)
    }
}

private func ==(lhs: KeyboardGuide, rhs: KeyboardGuide) -> Bool {
    return lhs.guide == rhs.guide
}
private struct KeyboardGuide: Equatable {
    let guide: UILayoutGuide
    let height: NSLayoutConstraint

    func update(withInfo info: KeyboardInfo) {

        guard let view = guide.owningView else { return }
        // Translate keyboard frame into view coordinates
        let translatedFrame = view.convert(info.endingFrame, from: nil)
        let heightInView = view.frame.height - translatedFrame.minY
        // Update layout guide height
        height.constant = heightInView
        // Update view layout
        view.setNeedsLayout()

        let animations = {
            view.layoutIfNeeded()
        }

        UIView.animate(withDuration: info.duration, delay: 0,
                       options: [info.curve.options],
                       animations: animations, completion: nil)
    }
}

private extension UIViewAnimationCurve {
    var options: UIViewAnimationOptions {
        switch self {
        case .easeIn:
            return .curveEaseIn
        case .easeOut:
            return .curveEaseOut
        case .easeInOut:
            return .curveEaseInOut
        case .linear:
            return .curveLinear
        }
    }
}

private struct KeyboardInfo {
    let beginningFrame: CGRect
    let endingFrame: CGRect
    let duration: TimeInterval
    let curve: UIViewAnimationCurve
    let isLocal: Bool

    init(notification note: Notification) {
        self.beginningFrame = note.beginningFrame
        self.endingFrame = note.endingFrame
        self.duration = note.duration
        self.curve = note.curve
        self.isLocal = note.isLocal
    }
}

private extension Notification {

    var beginningFrame: CGRect {
        guard let value = userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else {
            return .zero
        }
        return value.cgRectValue
    }
    var endingFrame: CGRect {
        guard let value = userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return .zero
        }
        return value.cgRectValue
    }
    var duration: TimeInterval {
        guard let value = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return 0
        }
        return value.doubleValue
    }
    var curve: UIViewAnimationCurve {
        guard let value = userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber else {
            return .easeInOut
        }
        return UIViewAnimationCurve(rawValue: value.intValue) ?? .easeInOut
    }
    var isLocal: Bool {
        guard let value = userInfo?[UIKeyboardIsLocalUserInfoKey] as? NSNumber else {
            return false
        }
        return value.boolValue
    }
}
