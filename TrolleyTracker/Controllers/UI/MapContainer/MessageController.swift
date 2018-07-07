//
//  MessageController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/30/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

protocol MessageControllerDelegate: class {
    func setMessageController(visible: Bool)
    func showSchedule()
}

class MessageController: FunctionController {

    private let viewController: MessageViewController
    weak var delegate: MessageControllerDelegate?

    fileprivate var activeMessage: MapMessageType = .disclaimer {
        didSet { viewController.setMessageText(activeMessage.displayValue) }
    }

    private var requestedMessages: Set<MapMessageType> = Set() {
        didSet { updateMessage() }
    }

    private var showMessageRequested = false {
        didSet {
            guard oldValue != showMessageRequested else { return }
            delegate?.setMessageController(visible: showMessageRequested)
        }
    }

    override init() {
        self.viewController = MessageViewController()
    }

    func prepare() -> UIViewController {
        viewController.delegate = self
        return viewController
    }

    func showNoTrolleysMessage() {
        requestedMessages.insert(.noTrolleys)
    }

    func hideNoTrolleysMessage() {
        requestedMessages.remove(.noTrolleys)
    }

    func showStopsDisclaimerMessage() {
        requestedMessages.insert(.disclaimer)
    }

    func hideStopsDisclaimerMessage() {
        requestedMessages.remove(.disclaimer)
    }

    func showSearchingMessage() {
        requestedMessages.insert(.searching)
    }

    func hideSearchingMessage() {
        requestedMessages.remove(.searching)
    }

    // It probably makes sense to add a different function to handle the listener for the API response triggering the show/hideSearchingMessage
    // Would love your thoughts/assistance here Austin - Jeremy Wight
    
    private func updateMessage() {
        activeMessage = requestedMessages.highestPriorityMessage
        showMessageRequested = activeMessage != .none
    }
}

extension MessageController: MessageVCDelegate {

    func messageLabelTapped() {
        switch activeMessage {
        case .none: return
        case .disclaimer: hideStopsDisclaimerMessage()
        case .searching: return
        case .noTrolleys: delegate?.showSchedule()
        }
    }
}
