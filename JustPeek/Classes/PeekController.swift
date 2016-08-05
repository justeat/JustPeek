//
//  PeekController.swift
//  JustPeek
//
//  Created by Gianluca Tranchedone for JustEat on 05/08/2016.
//

import UIKit

@objc(JEPeekControllerDelegate) public protocol PeekControllerDelegate {
    
    func peekController(controller: PeekController, peekContextForLocation location: CGPoint) -> PeekContext?
    func peekController(controller: PeekController, commit viewController: UIViewController)

}

@objc(JEPeekController) public class PeekController: NSObject {
    
    private(set) public weak var delegate: PeekControllerDelegate!
    private(set) public weak var view: UIView!
    
    private var peekViewController: PeekViewController?
    private lazy var presentationWindow: UIWindow? = {
        let window = UIWindow()
        window.backgroundColor = .clearColor()
        window.windowLevel = UIWindowLevelAlert
        return window
    }()
    
    public override init() {
        let format = "\(NSStringFromSelector(#selector(PeekController.init(view:delegate:)))) should be used instead"
        let exception = NSException(name: NSInternalInconsistencyException, reason: format, userInfo: nil)
        exception.raise()
    }
    
    public init(view: UIView, delegate: PeekControllerDelegate) {
        self.view = view
        self.delegate = delegate
        super.init()
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                                      action: #selector(handleLongPress(fromRecognizer:)))
        view.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    internal func handleLongPress(fromRecognizer gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.state {
        case .Began:
            peek(at: gestureRecognizer.locationInView(view))
            
        case .Ended, .Cancelled:
            pop()
            
        default:
            break
        }
    }
    
    private func peek(at location: CGPoint) {
        if let window = presentationWindow, context = delegate.peekController(self, peekContextForLocation: location) {
            peekViewController = PeekViewController(peekContext: context)
            window.rootViewController = peekViewController
            window.hidden = false
            peekViewController!.peek()
        }
    }
    
    private func pop() {
        peekViewController?.pop({ [weak self] _ in
            self?.presentationWindow?.hidden = true
        })
    }
    
}
