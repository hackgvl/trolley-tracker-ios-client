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

    fileprivate enum MessageType {
        case disclaimer
        case searching
        case noTrolleys
        case none

        var displayValue: String {
            switch self {
            case .disclaimer: return LS.mapMessageDisclaimer
            case .searching: return LS.mapMessageSearching
            case .noTrolleys: return LS.mapMessageNoTrolleys
            case .none: return ""
            }
        }
    }

    private let viewController: MessageViewController
    weak var delegate: MessageControllerDelegate?

    fileprivate var activeMessage: MessageType = .disclaimer {
        didSet { viewController.setMessageText(activeMessage.displayValue) }
    }
    private var shouldShowDisclaimer = false {
        didSet { updateMessage() }
    }
    private var shouldShowSearching = false {
        didSet { updateMessage() }
    }
    private var shouldShowNoTrolleys = false {
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
        shouldShowNoTrolleys = true
    }

    func hideNoTrolleysMessage() {
        shouldShowNoTrolleys = false
    }

    func showStopsDisclaimerMessage() {
        shouldShowDisclaimer = true
    }

    func hideStopsDisclaimerMessage() {
        shouldShowDisclaimer = false
    }

    func showSearchingMessage() {
        shouldShowSearching = true
    }

    func hideSearchingMessage() {
        shouldShowSearching = false
    }

    // It probably makes sense to add a different function to handle the listener for the API response triggering the show/hideSearchingMessage
    // Would love your thoughts/assistance here Austin - Jeremy Wight
    
    private func updateMessage() {
        switch (shouldShowNoTrolleys, shouldShowDisclaimer) {
        case (true, true), (true, false):
            // Both messages are requested, or only the no trolleys message is requested
            activeMessage = .noTrolleys
            showMessageRequested = true
        case (false, true):
            // Only the disclaimer message is requested
            activeMessage = .disclaimer
            showMessageRequested = true
        case (false, false):
            // No messages are requested
            activeMessage = .none
            showMessageRequested = false
        }
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
