//
//  PeekController.swift
//  JustPeek
//
//  Created by Gianluca Tranchedone for JustEat on 05/08/2016.
//

import UIKit

private extension UIDevice {
    
    var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
}

internal protocol PeekHandler {
    
    weak var peekController: PeekController? { get set }
    
    func register(viewController vc: UIViewController, forPeekingWithDelegate delegate: PeekingDelegate, sourceView: UIView)
    
}

@objc(JEPeekingDelegate) public protocol PeekingDelegate {
    
    func peekController(controller: PeekController, peekContextForLocation location: CGPoint) -> PeekContext?
    func peekController(controller: PeekController, commit viewController: UIViewController)

}

@objc(JEPeekController) public class PeekController: NSObject {
    
    private var peekHandler: PeekHandler?
    
    public func register(viewController v: UIViewController, forPeekingWithDelegate d: PeekingDelegate, sourceView: UIView) {
        if #available(iOS 9.0, *) {
            peekHandler = UIDevice.currentDevice().isSimulator ? PeekReplacementHandler() : PeekNativeHandler()
        } else {
            peekHandler = PeekReplacementHandler()
        }
        peekHandler?.peekController = self
        peekHandler?.register(viewController: v, forPeekingWithDelegate: d, sourceView: sourceView)
    }
    
}
