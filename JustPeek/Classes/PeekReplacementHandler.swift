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
    
    private let longPressDurationForCommitting = 3.0
    private var commitOperation: Operation?
    private var peekStartLocation: CGPoint?
    private var preventFromPopping = false
    
    private var peekViewController: PeekViewController?
    private lazy var presentationWindow: UIWindow! = {
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        window.windowLevel = UIWindowLevelAlert
        window.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPreview)))
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
            peekStartLocation = gestureRecognizer.location(in: gestureRecognizer.view)
            peek(at: peekStartLocation!)
            let commitOperation = BlockOperation(block: { [weak self] in
                self?.commit()
            })
            self.commitOperation = commitOperation
            let delayTime = DispatchTime.now() + Double(Int64(longPressDurationForCommitting * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                if !commitOperation.isCancelled {
                    OperationQueue.main.addOperation(commitOperation)
                }
            }
            
        case .changed:
            let currentLocation = gestureRecognizer.location(in: gestureRecognizer.view)
            if let startLocation = peekStartLocation , abs(currentLocation.y - startLocation.y) > 50 {
                preventFromPopping = true
                commitOperation?.cancel()
            }
            break
            
        case .ended, .cancelled:
            commitOperation?.cancel()
            if !preventFromPopping {
                // delay for UI Tests
                let delayTime = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) { [weak self] in
                    self?.pop()
                }
            }
            
        default:
            break
        }
    }
    
    @objc(peekAtLocation:) internal func peek(at location: CGPoint) {
        guard let peekContext = peekContext else { return }
        peekContext.destinationViewController = delegate?.peekContext(peekContext, viewControllerForPeekingAt: location)
        peekViewController = PeekViewController(peekContext: peekContext)
        guard let peekViewController = peekViewController else { return }
        presentationWindow.rootViewController = peekViewController
        presentationWindow.isHidden = false
        peekViewController.peek()
    }
    
    @objc internal func pop(_ completion: (() -> Void)? = nil) {
        preventFromPopping = false
        let window = presentationWindow
        peekViewController?.pop({ (_) in
            window?.isHidden = true
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
    
    // This function purely exists to make objc happy when trying to call pop from the UIGestureRecognizer selector
    @objc internal func dismissPreview() {
        pop()
    }
    
}
