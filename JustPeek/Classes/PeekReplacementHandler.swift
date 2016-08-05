//
//  PeekReplacementHandler.swift
//  Pods
//
//  Created by Gianluca Tranchedone on 05/08/2016.
//
//

import UIKit

class PeekReplacementHandler: PeekHandler {
    
    var peekController: PeekController?
    private weak var delegate: PeekingDelegate?
    
    private var peekViewController: PeekViewController?
    private lazy var presentationWindow: UIWindow! = {
        let window = UIWindow()
        window.backgroundColor = .clearColor()
        window.windowLevel = UIWindowLevelAlert
        return window
    }()
    
    func register(viewController vc: UIViewController, forPeekingWithDelegate delegate: PeekingDelegate, sourceView: UIView) {
        self.delegate = delegate
        let selector = #selector(handleLongPress(fromRecognizer:))
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: selector)
        sourceView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc internal func handleLongPress(fromRecognizer gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.state {
        case .Began:
            peek(at: gestureRecognizer.locationInView(gestureRecognizer.view))
            
        case .Ended, .Cancelled:
            pop()
            
        default:
            break
        }
    }
    
    private func peek(at location: CGPoint) {
        guard let peekController = peekController else { return }
        guard let context = delegate?.peekController(peekController, peekContextForLocation: location) else { return }
        peekViewController = PeekViewController(peekContext: context)
        presentationWindow.rootViewController = peekViewController
        presentationWindow.hidden = false
        peekViewController!.peek()
    }
    
    private func pop() {
        let window = presentationWindow
        peekViewController?.pop({ (_) in
            window.hidden = true
        })
    }
    
}
