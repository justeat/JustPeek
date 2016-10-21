//
//  PeekReplacementHandler.swift
//  JustPeek
//
//  Copyright 2016 Just Eat Holdings Ltd.
//

import UIKit

class PeekReplacementHandler: PeekHandler {
    
    private var peekContext: PeekContext?
    private weak var delegate: PeekingDelegate?
    
    private var preventFromPopping: Bool = false
    private var startingLocation: CGPoint?
    
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
            startingLocation = gestureRecognizer.locationInView(gestureRecognizer.view)
            peek(at: startingLocation!)
            
        case .Changed:
            let currentLocation = gestureRecognizer.locationInView(gestureRecognizer.view)
            if let startLocation = startingLocation where abs(currentLocation.y - startLocation.y) > 50 {
                preventFromPopping = true
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
    
    @objc internal func pop() {
        preventFromPopping = false
        let window = presentationWindow
        peekViewController?.pop({ (_) in
            window.hidden = true
        })
    }
    
}
