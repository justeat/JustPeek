//
//  PeekView.swift
//  JustPeek
//
//  Created by Gianluca Tranchedone for JustEat on 05/08/2016.
//

import UIKit

internal class PeekView: UIView {
    
    init(frame: CGRect, contentView: UIView) {
        super.init(frame: frame)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        userInteractionEnabled = false
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) must not be used")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadiusFor(frame: frame)
    }
    
    func animateToFrame(frame: CGRect, alongsideAnimation otherAnimation: (() -> ())? = nil, completion: ((Bool) -> ())? = nil) {
        layoutIfNeeded()
        let animations: () -> () = { [weak self] in
            if let strongSelf = self {
                otherAnimation?()
                strongSelf.frame = frame
                strongSelf.layoutIfNeeded()
            }
        }
        let borderRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
        borderRadiusAnimation.fromValue = layer.cornerRadius
        borderRadiusAnimation.toValue = cornerRadiusFor(frame: frame)
        borderRadiusAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        layer.addAnimation(borderRadiusAnimation, forKey: "cornerRadiusAnimation")
        let animationDuration = PeekContext.AnimationConfiguration.animationDuration
        UIView.animateWithDuration(animationDuration, animations: animations, completion: completion)
    }
    
    private func cornerRadiusFor(frame frame: CGRect) -> CGFloat {
        return min(frame.height, frame.width) * 0.05 // 5% of the smallest side
    }
    
}
