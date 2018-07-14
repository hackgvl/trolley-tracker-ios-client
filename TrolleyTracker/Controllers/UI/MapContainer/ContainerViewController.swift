//
//  ContainerViewController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/29/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

protocol ContainerVCDelegate: class {
    func handleObscuredView(_ view: UIView)
}

class ContainerViewController: UIViewController {

    weak var delegate: ContainerVCDelegate?

    private let mapViewController: UIViewController
    private let detailViewController: UIViewController
    private let messageViewController: UIViewController

    private let mapContainer: UIView = .container()
    private let detailContainer: UIView = .container()
    private let messageContainer: UIView = .container()

    private var detailVisibleConstraint: NSLayoutConstraint?
    private var detailHiddenConstraint: NSLayoutConstraint?

    private var messageHiddenConstraint: NSLayoutConstraint?
    private var messageVisibleConstraint: NSLayoutConstraint?

    init(mapViewController: UIViewController,
         detailViewController: UIViewController,
         messageViewController: UIViewController) {
        self.mapViewController = mapViewController
        self.detailViewController = detailViewController
        self.messageViewController = messageViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarItem.image = #imageLiteral(resourceName: "Map")
        tabBarItem.title = LS.mapTitle

        setupViews()
        setupChildren()

        setDetail(visible: false, animated: false, completion: nil)
    }

    private func setupViews() {
        for container in [mapContainer, messageContainer, detailContainer] {
            view.addSubview(container)
        }
        mapContainer.edgeAnchors == view.edgeAnchors

        detailContainer.horizontalAnchors == view.horizontalAnchors
        detailHiddenConstraint = detailContainer.topAnchor == view.bottomAnchor

        let detailAnchor = detailContainer.bottomAnchor
        let viewAnchor = bottomLayoutGuide.topAnchor
        detailVisibleConstraint = detailAnchor.constraint(equalTo: viewAnchor)

        messageContainer.horizontalAnchors == view.horizontalAnchors
        messageHiddenConstraint = messageContainer.topAnchor == view.bottomAnchor
        let messageAnchor = messageContainer.bottomAnchor
        messageVisibleConstraint = messageAnchor.constraint(equalTo: viewAnchor)
    }

    private func setupChildren() {
        addAndPin(mapViewController, to: mapContainer)
        addAndPin(detailViewController, to: detailContainer)
        addAndPin(messageViewController, to: messageContainer)
    }

    // MARK: - API

    var isDetailViewVisible: Bool {
        return detailVisibleConstraint?.isActive ?? false
    }

    func setDetail(visible: Bool, animated: Bool, completion: (() -> Void)?) {
        setVisible(visible: visible, animated: animated,
                   visibleConstraint: detailVisibleConstraint,
                   hiddenConstraint: detailHiddenConstraint,
                   completion: completion)
    }

    func setMessage(visible: Bool, animated: Bool) {
        setVisible(visible: visible, animated: animated,
                   visibleConstraint: messageVisibleConstraint,
                   hiddenConstraint: messageHiddenConstraint,
                   completion: nil)
    }

    func ensureViewIsNotObscured(_ subview: UIView) {
        let subviewFrame = view.convert(subview.frame, from: subview.superview)
        let detailFrame = view.convert(detailContainer.frame, from: detailContainer.superview)
        let obscured = detailFrame.contains(subviewFrame)
        guard obscured else { return }
        delegate?.handleObscuredView(subview)
    }
}
