//
//  JustPeek_UITests.swift
//  JustPeek_UITests
//
//  Created by Gianluca Tranchedone on 21/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest

class JustPeek_UITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
        XCUIDevice.shared().orientation = .portrait
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLongPressingDisplaysPreview() {
        // Long Press on a table row
        let app = XCUIApplication()
        let row3 = app.tables.cells.element(boundBy: 2) // row 3 -> index 2 as 0 based
        row3.press(forDuration: 1.0)
        
        // Assert we're still in the same UIViewController
        XCTAssertTrue(app.navigationBars.staticTexts["JustPeek"].exists)
        XCTAssertFalse(app.navigationBars.staticTexts["Row 3"].exists)
        
        // Assert that we see the preview UIViewController and that it updates live
        XCTAssertTrue(app.windows.staticTexts["Loading..."].exists)
    }
    
    func testLongPressingDisplaysPreviewStaticallyWhenFingerMovesEnoughFromStartLocation() {
        // Long Press on a table row
        let app = XCUIApplication()
        let row3 = app.tables.cells.element(boundBy: 2) // row 3 -> index 2 as 0 based
        row3.press(forDuration: 1.0, thenDragTo: app.navigationBars.element(boundBy: 0))
        
        // Assert we're still in the same UIViewController
        XCTAssertTrue(app.navigationBars.staticTexts["JustPeek"].exists)
        XCTAssertFalse(app.navigationBars.staticTexts["Row 3"].exists)
        
        // Assert that we see the preview UIViewController and that it updates live
        XCTAssertTrue(app.windows.staticTexts["Loading..."].exists)
        let label = app.windows.staticTexts["Row 3 Details"]
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}
