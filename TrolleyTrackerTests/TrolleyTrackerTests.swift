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

        let decoder = JSONDecoder()
        let apiTrolley: _APITrolley
        do {
            apiTrolley = try decoder.decode(_APITrolley.self, from: trolleyData)
        }
        catch let error {
            print(error)
            XCTAssert(false)
            return
        }

        let trolley = apiTrolley.trolley

        XCTAssertEqual(trolley.ID, 6)
        XCTAssertEqual(trolley.name, "Limo Trolley")
        XCTAssertEqual(trolley.number, 8)
    }
    
}
