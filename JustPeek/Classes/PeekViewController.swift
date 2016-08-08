//
//  PeekViewController.swift
//  JustPeek
//
//  Created by Gianluca Tranchedone for JustEat on 05/08/2016.
//

import UIKit

internal class PeekViewController: UIViewController {
    
    private let peekContext: PeekContext
    private let contentView: UIView
    private let peekView: PeekView
    
    internal init?(peekContext: PeekContext) {
        self.peekContext = peekContext
        guard let contentViewController = peekContext.destinationViewController else { return nil }
        // NOTE: it seems UIVisualEffectView has a blur radious too high for what we want to achieve... moreover
        // it's not safe to animate it's alpha component
        peekView = PeekView(frame: peekContext.initalPreviewFrame(), contentView: contentViewController.view)
        contentView = UIScreen.mainScreen().blurredSnapshotView
        super.init(nibName: nil, bundle: nil)
        peekView.frame = convertedInitialFrame()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        contentView.addSubview(peekView)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) must not be used")
    }
    
    internal func peek(completion: ((Bool) -> ())? = nil) {
        animatePeekView(true, completion: completion)
    }
    
    internal func pop(completion: ((Bool) -> ())?) {
        animatePeekView(false, completion: completion)
    }
    
    private func convertedInitialFrame() -> CGRect {
        return self.view.convertRect(peekContext.initalPreviewFrame(), fromView: peekContext.sourceView)
    }
    
    private func animatePeekView(forBeingPresented: Bool, completion: ((Bool) -> ())?) {
        let destinationFrame = forBeingPresented ? peekContext.finalPreviewFrame() : convertedInitialFrame()
        contentView.alpha = forBeingPresented ? 0.0 : 1.0
        let contentViewAnimation = { [weak self] in
            if let strongSelf = self {
                strongSelf.contentView.alpha = 1.0 - strongSelf.contentView.alpha
            }
        }
        peekView.animateToFrame(destinationFrame, alongsideAnimation: contentViewAnimation, completion: completion)
    }
    
}

private extension UIScreen {
    
    var blurredSnapshotView: UIView {
        get {
            let view = UIScreen.mainScreen().snapshotViewAfterScreenUpdates(false)
            return view.blurredSnaphotView
        }
    }
    
}

private extension UIView {
    
    var blurredSnaphotView: UIView {
        get {
            let view = UIImageView(frame: bounds)
            if let image = snapshot {
                let radious = CGFloat(20.0) // just because with this value the result looks good
                view.image = image.applyBlurWithRadius(radious, tintColor: nil, saturationDeltaFactor: 1.0, maskImage: nil)
            }
            return view
        }
    }
    
    var snapshot: UIImage? {
        get {
            UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0)
            drawViewHierarchyInRect(bounds, afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
    }
    
}
