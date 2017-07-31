//
//  ContainerController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/29/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit
import MapKit

class ContainerController: FunctionController {

    typealias Dependencies = HasLocationService & HasRouteService

    private let dependencies: Dependencies
    fileprivate let viewController: ContainerViewController

    fileprivate let mapController: MapController
    fileprivate let detailController: DetailController
    fileprivate let messageController: MessageController

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
    }

    func prepare() -> UIViewController {
        return viewController
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
        // TODO: Pass to Message Controller
    }
}
