//
//  MapMessageTests.swift
//  TrolleyTrackerTests
//
//  Created by Austin on 7/7/18.
//  Copyright © 2018 Code For Greenville. All rights reserved.
//

import XCTest
@testable import TrolleyTracker

class MapMessageTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMessagePrioritySorting() {

        let messageArray: [MapMessageType] = [
            .searching, .disclaimer, .noTrolleys
        ]
        let messageSet = Set(messageArray)

        XCTAssertEqual(messageSet.highestPriorityMessage, .disclaimer)
    }

    func testEmptyMessageSetReturnNone() {
        let messageSet = Set<MapMessageType>()
        XCTAssertEqual(messageSet.highestPriorityMessage, .none)
    }

}
