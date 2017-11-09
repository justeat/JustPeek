//
//  PeekNativeHandler.swift
//  JustPeek
//
//  Copyright 2016 Just Eat Holdings Ltd.
//

import UIKit

fileprivate let ObservingKeyPath = "state"

@available(iOS 9.0, *)
internal class PeekNativeHandler: NSObject, PeekHandler, UIViewControllerPreviewingDelegate {
    
    fileprivate weak var delegate: PeekingDelegate?
    fileprivate var peekContext: PeekContext?
    
    func register(viewController vc: UIViewController, forPeekingWithDelegate d: PeekingDelegate, sourceView: UIView) {
        peekContext = PeekContext(sourceViewController: vc, sourceView: sourceView)
        delegate = d
        vc.registerForPreviewing(with: self, sourceView: sourceView)
    }
    
    func previewingContext(_ context: UIViewControllerPreviewing, viewControllerForLocation l: CGPoint) -> UIViewController? {
        peekContext?.destinationViewController = delegate?.peekContext(peekContext!, viewControllerForPeekingAt: l)
        
        if peekContext?.destinationViewController != nil {
            let gesture = context.previewingGestureRecognizerForFailureRelationship
            gesture.addObserver(self, forKeyPath: ObservingKeyPath, options: .new, context: nil)
        }
        return peekContext?.destinationViewController
    }
    
    func previewingContext(_ context: UIViewControllerPreviewing, commit viewController: UIViewController) {
        if let peekContext = peekContext {
            delegate?.peekContext(peekContext, commit: viewController)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let gesture = object as? AnyObject else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        guard keyPath == ObservingKeyPath else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        let newValue = (change![.newKey] as! NSNumber).intValue
        let state = UIGestureRecognizerState(rawValue: newValue)!
        
        switch state {
        case .ended, .failed, .cancelled:
            peekContext?.destinationViewController = nil
            
            gesture.removeObserver(self, forKeyPath: ObservingKeyPath)
            
        default:
            break
        }
    }
}
