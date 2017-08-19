//
//  ArrayHelpers.swift
//  TrolleyTracker
//
//  Created by Austin on 8/19/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {

    func subtract(_ otherArray: Array<Element>) -> [Element] {
        var returnArray = [Element]()
        for element in self {
            if !otherArray.contains(element) {
                returnArray.append(element)
            }
        }
        return returnArray
    }
}
