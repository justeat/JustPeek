//
//  PeekNativeHandler.swift
//  JustPeek
//
//  Created by Gianluca Tranchedone for JustEat on 05/08/2016.
//

import UIKit

@available(iOS 9.0, *)
internal class PeekNativeHandler: NSObject, PeekHandler, UIViewControllerPreviewingDelegate {
    
    weak var peekController: PeekController?
    private var delegate: PeekingDelegate?
    
    func register(viewController vc: UIViewController, forPeekingWithDelegate delegate: PeekingDelegate, sourceView: UIView) {
        vc.registerForPreviewingWithDelegate(self, sourceView: sourceView)
    }
    
    func previewingContext(context: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let peekController = peekController else { return nil }
        let peekContext = delegate?.peekController(peekController, peekContextForLocation: location)
        if let sourceRect = peekContext?.sourceRect {
            context.sourceRect = sourceRect
        }
        return peekContext?.destinationViewController
    }
    
    func previewingContext(context: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        delegate?.peekController(PeekController(), commit: viewControllerToCommit)
    }
    
}
