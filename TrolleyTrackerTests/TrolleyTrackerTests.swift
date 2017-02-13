//
//  TrolleyTrackerTests.swift
//  TrolleyTrackerTests
//
//  Created by Ryan Poolos on 11/18/14.
//  Copyright (c) 2014 Code For Greenville. All rights reserved.
//

import UIKit
import XCTest
@testable import TrolleyTracker

class TrolleyTrackerTests: XCTestCase {

    private var mockTrolleyData: Data?

    override func setUp() {
        super.setUp()

        let bundle = Bundle(for: TrolleyTrackerTests.self)
        let url = bundle.url(forResource: "trolleyMock", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        mockTrolleyData = data
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTrolleyParsing() {

        guard let trolleyData = mockTrolleyData else {
            XCTAssert(false, "No Trolley Data to test with")
            return
        }
        guard let jsonData = try? JSONSerialization.jsonObject(with: trolleyData, options: []) else {
            XCTAssert(false, "Unable to create JSON Data from mock data")
            return
        }
        guard let trolley = Trolley(jsonData: jsonData) else {
            XCTAssert(false, "Unable to parse Trolley from data: \(String(describing: mockTrolleyData))")
            return
        }

        XCTAssertEqual(trolley.ID, 6)
        XCTAssertEqual(trolley.name, "Limo Trolley")
        XCTAssertEqual(trolley.number, 8)
    }
    
}
