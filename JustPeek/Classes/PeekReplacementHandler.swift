//
//  PeekReplacementHandler.swift
//  JustPeek
//
//  Copyright 2016 Just Eat Holdings Ltd.
//

import UIKit

internal class PeekReplacementHandler: PeekHandler {
    
    private var peekContext: PeekContext?
    private weak var delegate: PeekingDelegate?
    
    private let longPressDurationForCommitting = 5.0
    private var commitOperation: NSOperation?
    private var peekStartLocation: CGPoint?
    private var preventFromPopping = false
    
    private var peekViewController: PeekViewController?
    private lazy var presentationWindow: UIWindow! = {
        let window = UIWindow()
        window.backgroundColor = .clearColor()
        window.windowLevel = UIWindowLevelAlert
        window.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pop)))
        return window
    }()
    
    func register(viewController vc: UIViewController, forPeekingWithDelegate delegate: PeekingDelegate, sourceView: UIView) {
        self.delegate = delegate
        self.peekContext = PeekContext(sourceViewController: vc, sourceView: sourceView)
        let selector = #selector(handleLongPress(fromRecognizer:))
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: selector)
        sourceView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc internal func handleLongPress(fromRecognizer gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.state {
        case .Began:
            peekStartLocation = gestureRecognizer.locationInView(gestureRecognizer.view)
            peek(at: peekStartLocation!)
            commitOperation = NSBlockOperation(block: { [weak self] in
                self?.commit()
            })
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(longPressDurationForCommitting * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) { [weak self] in
                if let commitOperation = self?.commitOperation where !commitOperation.cancelled {
                    NSOperationQueue.mainQueue().addOperation(commitOperation)
                }
            }
            
        case .Changed:
            let currentLocation = gestureRecognizer.locationInView(gestureRecognizer.view)
            if let startLocation = peekStartLocation where abs(currentLocation.y - startLocation.y) > 50 {
                preventFromPopping = true
                commitOperation?.cancel()
            }
            break
            
        case .Ended, .Cancelled:
            if !preventFromPopping {
                // delay for UI Tests
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) { [weak self] in
                    self?.pop()
                }
            }
            
        default:
            break
        }
    }
    
    @objc internal func peek(at location: CGPoint) {
        guard let peekContext = peekContext else { return }
        peekContext.destinationViewController = delegate?.peekContext(peekContext, viewControllerForPeekingAt: location)
        peekViewController = PeekViewController(peekContext: peekContext)
        guard let peekViewController = peekViewController else { return }
        presentationWindow.rootViewController = peekViewController
        presentationWindow.hidden = false
        peekViewController.peek()
    }
    
    @objc internal func pop(completion: (Void -> Void)? = nil) {
        preventFromPopping = false
        let window = presentationWindow
        peekViewController?.pop({ (_) in
            window.hidden = true
            completion?()
        })
    }
    
    @objc internal func commit() {
        preventFromPopping = false
        pop { [weak self] in
            guard let strongSelf = self, let peekContext = strongSelf.peekContext else { return }
            guard let destinationViewController = peekContext.destinationViewController else { return }
            strongSelf.delegate?.peekContext(peekContext, commit: destinationViewController)
        }
    }
    
}
