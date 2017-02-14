//
//  TrolleyTrackerUITests.swift
//  TrolleyTrackerUITests
//
//  Created by Austin on 2/13/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import XCTest

class TrolleyTrackerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()

        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    

    func testMapScreenshot() {
        snapshot("01Map")
    }

    func testScheduleScreenshot() {

        let app = XCUIApplication()
        app.tabBars.buttons["Schedule"].tap()

        let navigationBarsQuery = app.navigationBars
        let byDayButton = navigationBarsQuery.buttons["By Day"]
        byDayButton.tap()
        navigationBarsQuery.buttons["By Route"].tap()
        byDayButton.tap()

        snapshot("02Schedule")
    }

    func testMoreScreenshot() {
        
        let app = XCUIApplication()
        app.tabBars.buttons["More"].tap()

        snapshot("03More")
    }
    
}
