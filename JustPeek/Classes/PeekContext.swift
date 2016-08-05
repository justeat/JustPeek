//
//  PeekContext.swift
//  JustPeek
//
//  Created by Gianluca Tranchedone for JustEat on 05/08/2016.
//

import UIKit

@objc(JEPeekContext) public class PeekContext: NSObject {
    
    let destinationViewController: UIViewController
    let sourceRect: CGRect?
    
    private let peekAnimationInsetMultiplier = CGFloat(0.08)
    internal let animationDuration: NSTimeInterval = 0.2
    
    public init(destinationViewController: UIViewController, sourceRect: CGRect? = nil) {
        self.destinationViewController = destinationViewController
        self.sourceRect = sourceRect
        super.init()
    }
    
    internal func initalPreviewFrame() -> CGRect {
        var initialFrame = finalPreviewFrame().insetBy(percentage: peekAnimationInsetMultiplier * 2)
        if let sourceRect = sourceRect {
            initialFrame = sourceRect.insetBy(percentage: -peekAnimationInsetMultiplier)
        }
        return initialFrame
    }
    
    internal func finalPreviewFrame() -> CGRect {
        return UIScreen.mainScreen().bounds.insetBy(percentage: peekAnimationInsetMultiplier)
    }
    
}

public extension PeekContext {
    
    // for ObjC supoprt
    @objc public convenience init(destinationViewController: UIViewController, rect: CGRect) {
        self.init(destinationViewController: destinationViewController, sourceRect: rect)
    }
    
}

private extension CGRect {
    
    // percentage needs to be between 0.0 and 1.0
    func insetBy(percentage percentage: CGFloat) -> CGRect {
        return insetBy(dx: width * percentage, dy: height * percentage)
    }
    
}
