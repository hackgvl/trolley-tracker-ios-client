//
//  Formatters.swift
//  TrolleyTracker
//
//  Created by Austin on 3/23/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import Foundation
import MapKit

extension MKDistanceFormatter {

    static let standard: MKDistanceFormatter = {
        let formatter = MKDistanceFormatter()
        formatter.units = MKDistanceFormatterUnits.imperial
        formatter.unitStyle = MKDistanceFormatterUnitStyle.default
        return formatter
    }()
}
