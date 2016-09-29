//
//  ViewController.swift
//  JustPeek
//
//  Copyright 2016 Just Eat Holdings Ltd.
//


import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var loadingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.alpha = 0.0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC))
        dispatch_after(delay, dispatch_get_main_queue()) { [weak self] in
            self?.updateView()
        }
    }
    
    private func updateView() {
        titleLabel.text = title ?? NSStringFromClass(ViewController.self)
        UIView.animateWithDuration(0.25) { [weak self] in
            self?.loadingView.alpha = 0.0
            self?.titleLabel.alpha = 1.0
        }
    }

}

