//
//  PeekNativeHandler.swift
//  JustPeek
//
//  Copyright 2016 Just Eat Holdings Ltd.
//

import UIKit

@available(iOS 9.0, *)
internal class PeekNativeHandler: NSObject, PeekHandler, UIViewControllerPreviewingDelegate {
    
    fileprivate var delegate: PeekingDelegate?
    fileprivate var peekContext: PeekContext?
    
    func register(viewController vc: UIViewController, forPeekingWithDelegate d: PeekingDelegate, sourceView: UIView) {
        peekContext = PeekContext(sourceViewController: vc, sourceView: sourceView)
        delegate = d
        vc.registerForPreviewing(with: self, sourceView: sourceView)
    }
    
    func previewingContext(_ context: UIViewControllerPreviewing, viewControllerForLocation l: CGPoint) -> UIViewController? {
        peekContext?.destinationViewController = delegate?.peekContext(peekContext!, viewControllerForPeekingAt: l)
        return peekContext?.destinationViewController
    }
    
    func previewingContext(_ context: UIViewControllerPreviewing, commit viewController: UIViewController) {
        if let peekContext = peekContext {
            delegate?.peekContext(peekContext, commit: viewController)
        }
    }
    
}
