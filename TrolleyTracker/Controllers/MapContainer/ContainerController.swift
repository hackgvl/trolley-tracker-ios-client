//
//  ContainerController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/29/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

class ContainerController: FunctionController {

    typealias Dependencies = HasLocationService & HasRouteService

    private let dependencies: Dependencies
    private let viewController: ContainerViewController

    private let mapController: MapController
    private let detailController: DetailController
    private let messageController: MessageController

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
    }

    func prepare() -> UIViewController {
        return viewController
    }
}
