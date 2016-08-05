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
        layer.cornerRadius = min(frame.height, frame.width) * 0.05 // 5% of the smallest side
    }
    
}
