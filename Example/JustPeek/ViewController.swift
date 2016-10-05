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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let delay = DispatchTime.now() + Double(Int64(1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delay) { [weak self] in
            self?.updateView()
        }
    }
    
    fileprivate func updateView() {
        titleLabel.text = title ?? NSStringFromClass(ViewController.self)
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.loadingView.alpha = 0.0
            self?.titleLabel.alpha = 1.0
        }) 
    }

}

