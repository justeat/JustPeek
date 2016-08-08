//
//  PeekController.swift
//  JustPeek
//
//  Created by Gianluca Tranchedone for JustEat on 05/08/2016.
//

import UIKit

private extension UIView {
    
    var canUseForceTouch: Bool {
        get {
            if #available(iOS 9.0, *) {
                return traitCollection.forceTouchCapability == .Available
            } else {
                return false
            }
        }
    }
    
}

internal protocol PeekHandler {
    
    func register(viewController vc: UIViewController, forPeekingWithDelegate delegate: PeekingDelegate, sourceView: UIView)
    
}

@objc(JEPeekingDelegate) public protocol PeekingDelegate {
    
    func peekContext(context: PeekContext, viewControllerForPeekingAt location: CGPoint) -> UIViewController?
    func peekContext(context: PeekContext, commit viewController: UIViewController)

}

@objc(JEPeekController) public class PeekController: NSObject {
    
    private var peekHandler: PeekHandler?
    private var sourceViewController: UIViewController?
    
    public func register(viewController v: UIViewController, forPeekingWithDelegate d: PeekingDelegate, sourceView: UIView) {
        if #available(iOS 9.0, *) {
            peekHandler = sourceView.canUseForceTouch ? PeekNativeHandler() : PeekReplacementHandler()
        } else {
            peekHandler = PeekReplacementHandler()
        }
        peekHandler?.register(viewController: v, forPeekingWithDelegate: d, sourceView: sourceView)
    }
    
}
