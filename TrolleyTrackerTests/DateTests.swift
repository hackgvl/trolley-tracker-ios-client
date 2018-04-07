//
//  DateTests.swift
//  TrolleyTrackerTests
//
//  Created by Austin Younts on 4/7/18.
//  Copyright © 2018 Code For Greenville. All rights reserved.
//

import XCTest
@testable import TrolleyTracker

class DateTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: Quarter Hour tests

    func testQuarterHourFunctionCatches0() {
        let date1 = Date(timeIntervalSinceReferenceDate: 60) // Dec 31, 2000 at 7:01 PM
        let date2 = Date(timeIntervalSinceReferenceDate: -60) // Dec 31, 2000 at 6:59 PM
        let result1 = date2.isAcrossQuarterHourBoundry(comparedTo: date1)
        XCTAssertTrue(result1)
    }

    func testQuarterHourFunctionCatches15() {
        let date1 = Date(timeIntervalSinceReferenceDate: 840) // Dec 31, 2000 at 7:14 PM
        let date2 = Date(timeIntervalSinceReferenceDate: 960) // Dec 31, 2000 at 7:16 PM
        let result1 = date2.isAcrossQuarterHourBoundry(comparedTo: date1)
        XCTAssertTrue(result1)
    }

    func testQuarterHourFunctionCatches30() {
        let date1 = Date(timeIntervalSinceReferenceDate: 1740) // Dec 31, 2000 at 7:29 PM
        let date2 = Date(timeIntervalSinceReferenceDate: 1860) // Dec 31, 2000 at 7:31 PM
        let result1 = date2.isAcrossQuarterHourBoundry(comparedTo: date1)
        XCTAssertTrue(result1)
    }

    func testQuarterHourFunctionCatches45() {
        let date1 = Date(timeIntervalSinceReferenceDate: 2640) // Dec 31, 2000 at 7:44 PM
        let date2 = Date(timeIntervalSinceReferenceDate: 2760) // Dec 31, 2000 at 7:46 PM
        let result1 = date2.isAcrossQuarterHourBoundry(comparedTo: date1)
        XCTAssertTrue(result1)
    }

    func testQuarterHourFunctionDoesNotReturnFalsePositives() {

        let date1 = Date(timeIntervalSinceReferenceDate: 60) // Dec 31, 2000 at 7:01 PM
        let date2 = Date(timeIntervalSinceReferenceDate: 840) // Dec 31, 2000 at 7:14 PM
        let result1 = date2.isAcrossQuarterHourBoundry(comparedTo: date1)
        XCTAssertFalse(result1)
    }
}
