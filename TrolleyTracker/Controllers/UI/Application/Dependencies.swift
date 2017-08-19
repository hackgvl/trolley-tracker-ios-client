//
//  Dependencies.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/30/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import Foundation

protocol HasModelController {
    var modelController: ModelController { get }
}

struct AppDependencies: HasModelController {

    let modelController: ModelController

    init(client: APIClient) {
        modelController = ModelController(apiClient: client)
    }
}
