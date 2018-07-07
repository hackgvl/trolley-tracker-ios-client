//
//  MapMessages.swift
//  TrolleyTracker
//
//  Created by Austin on 7/7/18.
//  Copyright © 2018 Code For Greenville. All rights reserved.
//

import Foundation

enum MapMessageType {
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

    var priority: Int {
        switch self {
        case .disclaimer: return 5
        case .searching: return 4
        case .noTrolleys: return 2
        case .none: return 0
        }
    }
}

extension Set where Element == MapMessageType {
    var highestPriorityMessage: MapMessageType {
        guard !isEmpty else {
            return .none
        }
        return sortedByPriority()[0]
    }

    func sortedByPriority() -> [Element] {
        return sorted { (m1, m2) -> Bool in
            m1.priority > m2.priority
        }
    }
}
