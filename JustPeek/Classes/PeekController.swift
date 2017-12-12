//
//  PeekController.swift
//  JustPeek
//
//  Copyright 2016 Just Eat Holdings Ltd.
//

import UIKit

private extension UIDevice {
    
    var isSimulator: Bool {
        get {
            return TARGET_OS_SIMULATOR != 0
        }
    }
    
}

private extension UIView {
    
    var hasNativeForceTouchEnabled: Bool {
        get {
            guard !UIDevice.current.isSimulator else { return false }
            if #available(iOS 9.0, *) {
                return traitCollection.forceTouchCapability == .available
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
    
    func peekContext(_ context: PeekContext, viewControllerForPeekingAt location: CGPoint) -> UIViewController?
    func peekContext(_ context: PeekContext, commit viewController: UIViewController)

}

@objc(JEPeekController) @objcMembers open class PeekController: NSObject {
    
    fileprivate var peekHandler: PeekHandler?
    fileprivate var sourceViewController: UIViewController?
    
    open func register(viewController v: UIViewController, forPeekingWithDelegate d: PeekingDelegate, sourceView: UIView) {
        if #available(iOS 9.0, *) {
            peekHandler = sourceView.hasNativeForceTouchEnabled ? PeekNativeHandler() : PeekReplacementHandler()
        } else {
            peekHandler = PeekReplacementHandler()
        }
        peekHandler?.register(viewController: v, forPeekingWithDelegate: d, sourceView: sourceView)
    }
    
}
