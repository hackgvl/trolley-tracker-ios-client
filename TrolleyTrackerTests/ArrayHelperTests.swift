//
//  ArrayHelperTests.swift
//  TrolleyTrackerTests
//
//  Created by Austin Younts on 4/7/18.
//  Copyright © 2018 Code For Greenville. All rights reserved.
//

import XCTest
@testable import TrolleyTracker

class ArrayHelperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testArraySubtraction() {
        let array1 = [1, 2, 3, 4, 5, 6, 7]
        let array2 = [2, 4, 6]
        let subtracted = array1.subtract(array2)
        XCTAssertEqual(subtracted, [1, 3, 5, 7])
    }

    func testArraySubtractionWithDuplicates() {
        let array1 = [1, 2, 2, 3, 4, 5, 6, 7, 2]
        let array2 = [2, 4, 6]
        let subtracted = array1.subtract(array2)
        XCTAssertEqual(subtracted, [1, 3, 5, 7])
    }
}
