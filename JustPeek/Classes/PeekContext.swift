//
//  PeekContext.swift
//  JustPeek
//
//  Copyright 2016 Just Eat Holdings Ltd.
//

import UIKit

@objc(JEPeekContext) open class PeekContext: NSObject {
    
    internal struct AnimationConfiguration {
        static let peekAnimationInsetMultiplier = CGFloat(0.05) // 5%
        static let animationDuration: TimeInterval = 0.2
        
        static func initalPreviewFrame() -> CGRect {
            return finalPreviewFrame().insetBy(percentage: AnimationConfiguration.peekAnimationInsetMultiplier)
        }
        
        static func finalPreviewFrame() -> CGRect {
            return UIScreen.main.bounds.insetBy(percentage: AnimationConfiguration.peekAnimationInsetMultiplier)
        }
    }
    
    open let sourceViewController: UIViewController
    open let sourceView: UIView
    
    internal(set) open var destinationViewController: UIViewController?
    open var sourceRect: CGRect
    
    internal init(sourceViewController: UIViewController, sourceView: UIView) {
        self.sourceViewController = sourceViewController
        self.sourceView = sourceView
        sourceRect = AnimationConfiguration.initalPreviewFrame()
        super.init()
    }
    
    internal func initalPreviewFrame() -> CGRect {
        return sourceRect
    }
    
    internal func finalPreviewFrame() -> CGRect {
        return AnimationConfiguration.finalPreviewFrame()
    }
    
}

private extension CGRect {
    
    // percentage needs to be between 0.0 and 1.0
    func insetBy(percentage: CGFloat) -> CGRect {
        return insetBy(dx: width * percentage, dy: height * percentage)
    }
    
}
