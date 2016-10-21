//
//  JustPeek_UITests.swift
//  JustPeek_UITests
//
//  Created by Gianluca Tranchedone on 21/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest

class TableViewControllerUITests: XCTestCase {
    
    let longPressDurationForPreview = 1.0
    let longPressDurationForCommit = 6.0
    let asyncOperationsTimeout = 10.0
    
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
        row3.press(forDuration: longPressDurationForPreview)
        
        // Assert that we see the preview UIViewController
        XCTAssertTrue(app.staticTexts["Loading..."].exists)
        
        // Assert we're still in the same UIViewController
        XCTAssertTrue(app.navigationBars.staticTexts["JustPeek"].exists)
        XCTAssertFalse(app.navigationBars.staticTexts["Row 3"].exists)
    }
    
    func testLongPressingDisplaysPreviewStaticallyWhenFingerMovesEnoughFromStartLocation() {
        // Long Press on a table row
        let app = XCUIApplication()
        let row3 = app.tables.cells.element(boundBy: 2) // row 3 -> index 2 as 0 based
        row3.press(forDuration: longPressDurationForPreview, thenDragTo: app.navigationBars.element(boundBy: 0))
        
        // Assert that we see the preview UIViewController and that it updates live
        XCTAssertTrue(app.windows.staticTexts["Loading..."].exists)
        let label = app.windows.staticTexts["Row 3 Details"]
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: asyncOperationsTimeout, handler: nil)
        
        // Assert we're still in the same UIViewController
        XCTAssertTrue(app.navigationBars.staticTexts["JustPeek"].exists)
        XCTAssertFalse(app.navigationBars.staticTexts["Row 3"].exists)
    }
    
    func testLongPressingForLongEnoughTimeCommitsPreview_IfTouchDoesNotMoveEnoughFromStartLocation() {
        // Long Press on a table row
        let app = XCUIApplication()
        let row3 = app.tables.cells.element(boundBy: 2) // row 3 -> index 2 as 0 based
        row3.press(forDuration: longPressDurationForCommit + 0.5) // + 0.5 to wait for animation
        
        // Assert we're not in the same UIViewController anymore
        XCTAssertFalse(app.navigationBars.staticTexts["JustPeek"].exists)
        XCTAssertTrue(app.navigationBars.staticTexts["Row 3"].exists)
    }
    
    func testLongPressingDoesNotTryToCommitPreviewInAnyCase() {
        // Long Press on a table row
        let app = XCUIApplication()
        let row3 = app.tables.cells.element(boundBy: 2) // row 3 -> index 2 as 0 based
        row3.press(forDuration: longPressDurationForPreview, thenDragTo: app.navigationBars.element(boundBy: 0))
        
        // this works because UI Tests live in a different process than the app being tested
        sleep(UInt32(longPressDurationForCommit))
        
        // Assert we're still in the same UIViewController
        XCTAssertTrue(app.navigationBars.staticTexts["JustPeek"].exists)
        XCTAssertFalse(app.navigationBars.staticTexts["Row 3"].exists)
    }
    
}
