import UIKit
import XCTest
@testable import JustPeek

@available(iOS 9.0, *)
class MockViewController: UIViewController, PeekingDelegate {
    
    private(set) var didCommit = false
    private(set) var didRegisterForPreviewing = false
    let viewController = UIViewController()
    
    override func registerForPreviewingWithDelegate(delegate: UIViewControllerPreviewingDelegate, sourceView: UIView) -> UIViewControllerPreviewing {
        didRegisterForPreviewing = true
        return StubPreviewing(delegate: delegate)
    }
    
    func peekContext(context: PeekContext, commit viewController: UIViewController) {
        didCommit = true
    }
    
    func peekContext(context: PeekContext, viewControllerForPeekingAt location: CGPoint) -> UIViewController? {
        return viewController
    }
    
}

@available(iOS 9.0, *)
class StubPreviewing: NSObject, UIViewControllerPreviewing {
    
    var previewingGestureRecognizerForFailureRelationship: UIGestureRecognizer
    var delegate: UIViewControllerPreviewingDelegate
    var sourceView: UIView
    var sourceRect: CGRect
    
    init(delegate: UIViewControllerPreviewingDelegate) {
        self.previewingGestureRecognizerForFailureRelationship = UIGestureRecognizer()
        self.sourceView = UIView()
        self.sourceRect = self.sourceView.bounds
        self.delegate = delegate
        super.init()
    }
    
}

@available(iOS 9.0, *)
class PeekNativeHandlerTests: XCTestCase {
    
    var handler: PeekNativeHandler!
    
    override func setUp() {
        super.setUp()
        handler = PeekNativeHandler()
    }
    
    override func tearDown() {
        handler = nil
        super.tearDown()
    }
    
    func testRegistersForNativeBehaviour() {
        let mockViewController = MockViewController()
        handler.register(viewController: mockViewController, forPeekingWithDelegate: mockViewController, sourceView: mockViewController.view)
        XCTAssertTrue(mockViewController.didRegisterForPreviewing)
    }
    
    func testNativeHandlerReturnsCorrectViewController() {
        let mockViewController = MockViewController()
        let previewing = StubPreviewing(delegate: handler)
        let viewController = handler.previewingContext(previewing, viewControllerForLocation: CGPoint.zero)
        XCTAssertEqual(viewController, mockViewController.viewController)
    }
    
    func testCommitsDestinationViewController() {
        let mockViewController = MockViewController()
        let previewing = StubPreviewing(delegate: handler)
        handler.register(viewController: mockViewController, forPeekingWithDelegate: mockViewController, sourceView: mockViewController.view)
        handler.previewingContext(previewing, commitViewController: mockViewController.viewController)
        XCTAssertTrue(mockViewController.didCommit)
    }
    
}
