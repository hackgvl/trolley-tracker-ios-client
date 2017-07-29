//
//  ViewControllerInitialization.swift
//  TrolleyTracker
//
//  Created by Austin on 3/22/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import Foundation

public protocol StoryboardInjectable {

    associatedtype ViewControllerDependencies

    static func setDependencies(_ dependencies: ViewControllerDependencies)
    static func getDependencies() -> ViewControllerDependencies
}

public extension StoryboardInjectable {

    private static var storageKey: String {
        return String(describing: self)
    }

    private static var dependencyStorage: ViewControllerDependencies? {
        get { return NSObject.dependencyStorage[storageKey] as? ViewControllerDependencies }
        set { NSObject.dependencyStorage[storageKey] = newValue }
    }

    public static func setDependencies(_ dependencies: ViewControllerDependencies) {
        dependencyStorage = dependencies
    }

    public static func getDependencies() -> ViewControllerDependencies {
        guard let dependencies = dependencyStorage else { fatalError() }
        dependencyStorage = nil
        return dependencies
    }
}

private extension NSObject {
    static var dependencyStorage: [String : Any] = [:]
}
