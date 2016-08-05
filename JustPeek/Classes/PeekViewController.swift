//
//  PeekViewController.swift
//  JustPeek
//
//  Created by Gianluca Tranchedone for JustEat on 05/08/2016.
//

import UIKit

internal class PeekViewController: UIViewController {
    
    private let peekView: PeekView
    private let peekContext: PeekContext
    private let contentView: UIView
    
    internal init(peekContext: PeekContext) {
        self.peekContext = peekContext
        let contentViewController = peekContext.destinationViewController
        contentViewController.view.backgroundColor = .greenColor() // TODO: remove me
        peekView = PeekView(frame: peekContext.initalPreviewFrame(), contentView: contentViewController.view)
        // NOTE: it seems UIVisualEffectView has a blur radious too high for what we want to achieve... moreover
        // it's not safe to animate it's alpha component
        contentView = UIScreen.mainScreen().blurredSnapshotView
        super.init(nibName: nil, bundle: nil)
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
    
    private func animatePeekView(forBeingPresented: Bool, completion: ((Bool) -> ())?) {
        contentView.alpha = forBeingPresented ? 0.0 : 1.0
        let tempFrame = forBeingPresented ? peekContext.finalPreviewFrame() : peekContext.initalPreviewFrame()
        let destinationFrame = peekView.convertRect(tempFrame, fromView: peekContext.destinationViewController.view)
        peekView.layoutIfNeeded()
        let animations: () -> () = { [weak self] in
            if let strongSelf = self {
                strongSelf.contentView.alpha = 1.0 - strongSelf.contentView.alpha
                strongSelf.peekView.frame = destinationFrame
                strongSelf.peekView.layoutIfNeeded()
            }
        }
        UIView.animateWithDuration(peekContext.animationDuration, animations: animations, completion: completion)
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
                let radious = CGFloat(4.0) // just because with this value the result looks good
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
