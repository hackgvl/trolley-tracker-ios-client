//
//  MessageViewController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/30/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

protocol MessageVCDelegate: class {
    func messageLabelTapped()
}

class MessageViewController: UIViewController {

    weak var delegate: MessageVCDelegate?

    private let messageLabel: UILabel = {
        let l = UILabel().useAutolayout()
        l.font = .boldSystemFont(ofSize: 18)
        l.textColor = .white
        l.numberOfLines = 0
        return l
    }()

    private lazy var messageButton: UIButton = {
        let b = UIButton().useAutolayout()
        b.addTarget(self,
                    action: #selector(messageButtonTapped(_:)),
                    for: .touchUpInside)
        return b
    }()

    private let backgroundView: UIView = {
        let v = UIView().useAutolayout()
        v.backgroundColor = .ttLightGreen()
        return v
    }()

    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()

    override func loadView() {
        view = stackView
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(backgroundView)
        backgroundView.edgeAnchors == view.edgeAnchors

        let messageContainer = UIStackView().useAutolayout()
        messageContainer.axis = .horizontal
        messageContainer.addArrangedSubview(.spacerView(width: 24))
        messageContainer.addArrangedSubview(messageLabel)
        messageContainer.addArrangedSubview(.spacerView(width: 24))

        stackView.addArrangedSubview(.spacerView(height: 18))
        stackView.addArrangedSubview(messageContainer)
        stackView.addArrangedSubview(.spacerView(height: 18))

        view.addSubview(messageButton)
        messageButton.edgeAnchors == messageLabel.edgeAnchors
    }

    func setMessageText(_ text: String) {
        messageLabel.text = text
    }

    @objc private func messageButtonTapped(_ sender: UIButton) {
        delegate?.messageLabelTapped()
    }
}
