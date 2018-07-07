//
//  ContainerController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/29/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit
import MapKit

protocol ContainerControllerDelegate: class {
    func showSchedule()
}

class ContainerController: FunctionController {

    typealias Dependencies = HasLocationService & HasRouteService

    private let dependencies: Dependencies
    fileprivate let viewController: ContainerViewController

    weak var delegate: ContainerControllerDelegate?

    fileprivate let mapController: MapController
    fileprivate let detailController: DetailController
    fileprivate let messageController: MessageController

    private var trolleyObserver: ObserverSetEntry<[Trolley]>?

    init(dependencies: Dependencies) {
        self.dependencies = dependencies

        let mapC = MapController(dependencies: dependencies)
        self.mapController = mapC

        let detailC = DetailController(dependencies: dependencies)
        self.detailController = detailC

        let messageC = MessageController()
        self.messageController = messageC

        self.viewController = ContainerViewController(mapViewController: mapC.prepare(),
                                                      detailViewController: detailC.prepare(),
                                                      messageViewController: messageC.prepare())

        super.init()
        
        mapC.delegate = self
        messageC.delegate = self
    }

    func prepare() -> UIViewController {
        return viewController
    }

    func showSearchingMessageUntilNextTrolleyFetch() {
        messageController.showSearchingMessage()
        trolleyObserver = dependencies.locationService.trolleyObservers.add({ [weak self] _ in
            self?.messageController.hideSearchingMessage()
            self?.trolleyObserver = nil
        })
    }

    func showStopsDisclaimer() {
        messageController.showStopsDisclaimerMessage()
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.messageController.hideStopsDisclaimerMessage()
        }
    }

    func showSearchingMessage() {
        messageController.showSearchingMessage()
    }

    func hideSearchingMessage() {
        messageController.hideSearchingMessage()
    }
}

extension ContainerController: MessageControllerDelegate {
    func showSchedule() {
        delegate?.showSchedule()
    }

    func setMessageController(visible: Bool) {
        viewController.setMessage(visible: visible, animated: true)
    }
}

extension ContainerController: MapControllerDelegate {

    func annotationSelected(_ annotation: MKAnnotation?,
                            userLocation: MKUserLocation?) {

        detailController.show(annotation: annotation, userLocation: userLocation)

        let shouldShow = annotation != nil
        viewController.setDetail(visible: shouldShow, animated: true)
    }

    func handleNoTrolleysUpdate(_ trolleysPresent: Bool) {
        if trolleysPresent { messageController.hideNoTrolleysMessage() }
        else { messageController.showNoTrolleysMessage() }
    }
}
