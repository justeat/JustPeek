//
//  PeekReplacementHandler.swift
//  JustPeek
//
//  Copyright 2016 Just Eat Holdings Ltd.
//

import UIKit

class PeekReplacementHandler: PeekHandler {
    
    fileprivate var peekContext: PeekContext?
    fileprivate weak var delegate: PeekingDelegate?
    
    fileprivate var peekViewController: PeekViewController?
    fileprivate lazy var presentationWindow: UIWindow! = {
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        window.windowLevel = UIWindowLevelAlert
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
        case .began:
            peek(at: gestureRecognizer.location(in: gestureRecognizer.view))
            
        case .ended, .cancelled:
            pop()
            
        default:
            break
        }
    }
    
    fileprivate func peek(at location: CGPoint) {
        guard let peekContext = peekContext else { return }
        peekContext.destinationViewController = delegate?.peekContext(peekContext, viewControllerForPeekingAt: location)
        peekViewController = PeekViewController(peekContext: peekContext)
        guard let peekViewController = peekViewController else { return }
        presentationWindow.rootViewController = peekViewController
        presentationWindow.isHidden = false
        peekViewController.peek()
    }
    
    fileprivate func pop() {
        let window = presentationWindow!
        peekViewController?.pop({ (_) in
            window.isHidden = true
        })
    }
    
}
