//
//  PeekNativeHandler.swift
//  JustPeek
//
//  Copyright 2016 Just Eat Holdings Ltd.
//

import UIKit

@available(iOS 9.0, *)
internal class PeekNativeHandler: NSObject, PeekHandler, UIViewControllerPreviewingDelegate {
    
    private var delegate: PeekingDelegate?
    private var peekContext: PeekContext?
    
    func register(viewController vc: UIViewController, forPeekingWithDelegate d: PeekingDelegate, sourceView: UIView) {
        peekContext = PeekContext(sourceViewController: vc, sourceView: sourceView)
        delegate = d
        vc.registerForPreviewingWithDelegate(self, sourceView: sourceView)
    }
    
    func previewingContext(context: UIViewControllerPreviewing, viewControllerForLocation l: CGPoint) -> UIViewController? {
        peekContext?.destinationViewController = delegate?.peekContext(peekContext!, viewControllerForPeekingAt: l)
        return peekContext?.destinationViewController
    }
    
    func previewingContext(context: UIViewControllerPreviewing, commitViewController viewController: UIViewController) {
        if let peekContext = peekContext {
            delegate?.peekContext(peekContext, commit: viewController)
        }
    }
    
}
