//
//  DateHelpers.swift
//  TrolleyTracker
//
//  Created by Austin on 8/5/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import Foundation

extension Date {

    func isAcrossQuarterHourBoundry(comparedTo otherDate: Date) -> Bool {

        let calendar = Calendar.current
        let selfComps = calendar.component(.minute, from: self)
        let otherComps = Calendar.current.component(.minute, from: otherDate)

        guard selfComps != otherComps else {
            return false
        }

        // If `other` minutes are greater than `self` minutes,
        // the range spans the top of the hour
        guard selfComps > otherComps else {
            return true
        }

        let range = otherComps..<selfComps
        let boundryMarkers = [0, 15, 30, 45, 60]

        for marker in boundryMarkers {
            if range.contains(marker) {
                return true
            }
        }

        return false
    }

    var isAcrossQuarterHourBoundryFromNow: Bool {
        let now = Date()
        return isAcrossQuarterHourBoundry(comparedTo: now)
    }
}
