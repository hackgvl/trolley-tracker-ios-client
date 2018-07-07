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

    typealias Dependencies = HasModelController

    private let dependencies: Dependencies
    private let viewController: ContainerViewController

    weak var delegate: ContainerControllerDelegate?

    private let mapController: MapController
    private let detailController: DetailController
    private let messageController: MessageController

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
        viewController.delegate = self
    }

    func prepare() -> UIViewController {
        return viewController
    }

    func showSearchingMessageUntilNextTrolleyFetch() {
        messageController.showSearchingMessage()
        let observers = dependencies.modelController.locationService.trolleyObservers
        trolleyObserver = observers.add(handleTrolleyObserverNotification(_:))
    }

    func showStopsDisclaimer() {
        messageController.showStopsDisclaimerMessage()
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            self.messageController.hideStopsDisclaimerMessage()
        }
    }

    private func handleTrolleyObserverNotification(_ trolleys: [Trolley]) {
        messageController.hideSearchingMessage()
        trolleyObserver.map {
            self.dependencies.modelController.locationService.trolleyObservers.remove($0)
        }
        trolleyObserver = nil
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

    func annotationSelected(_ annotation: MKAnnotationView?,
                            userLocation: MKUserLocation?) {
        
        detailController.show(annotation: annotation?.annotation, userLocation: userLocation)

        let shouldShow = annotation != nil
        viewController.setDetail(visible: shouldShow, animated: true) {
            annotation.map {
                self.viewController.ensureViewIsNotObscured($0)
            }
        }
    }

    func handleNoTrolleysUpdate(_ trolleysPresent: Bool) {
        if trolleysPresent { messageController.hideNoTrolleysMessage() }
        else { messageController.showNoTrolleysMessage() }
    }
}

extension ContainerController: ContainerVCDelegate {

    func handleObscuredView(_ view: UIView) {
        mapController.unobscure(view)
    }
}
