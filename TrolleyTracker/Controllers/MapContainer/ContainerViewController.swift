//
//  ContainerViewController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/29/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

protocol ContainerVCDelegate: class {

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

        setDetail(visible: false, animated: false)
    }

    private func setupViews() {
        for container in [mapContainer, detailContainer, messageContainer] {
            view.addSubview(container)
        }
        mapContainer.edgeAnchors == view.edgeAnchors

        detailContainer.horizontalAnchors == view.horizontalAnchors
        detailContainer.heightAnchor == view.heightAnchor * 0.3
        detailHiddenConstraint = detailContainer.topAnchor == view.bottomAnchor

        let detailAnchor = detailContainer.bottomAnchor
        let viewAnchor = bottomLayoutGuide.topAnchor
        detailVisibleConstraint = detailAnchor.constraint(equalTo: viewAnchor)

        messageContainer.horizontalAnchors == view.horizontalAnchors
        messageContainer.heightAnchor == view.heightAnchor * 0.2
        messageContainer.topAnchor == view.bottomAnchor
    }

    private func setupChildren() {
        addAndPin(mapViewController, to: mapContainer)
        addAndPin(detailViewController, to: detailContainer)
        addAndPin(messageViewController, to: messageContainer)
    }

    // MARK: - API

    func setDetail(visible: Bool, animated: Bool) {
        setVisible(visible: visible, animated: animated,
                   visibleConstraint: detailVisibleConstraint,
                   hiddenConstraint: detailHiddenConstraint)
    }

    func setMessage(visible: Bool, animated: Bool) {

    }
}