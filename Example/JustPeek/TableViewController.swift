//
//  TableViewController.swift
//  JustPeek
//
//  Copyright 2016 Just Eat Holdings Ltd.
//

import UIKit
import JustPeek

class TableViewController: UITableViewController, PeekingDelegate {
    
    enum SegueIdentifiers: String {
        case ShowDetails = "ShowDetailsSegueIdentifier"
    }
    
    fileprivate var peekController: PeekController?
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peekController = PeekController()
        peekController?.register(viewController: self, forPeekingWithDelegate: self, sourceView: tableView)
    }
    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.ShowDetails.rawValue {
            guard let indexPath = sender as? IndexPath else { return }
            configureViewController(segue.destination, withItemAtIndexPath: indexPath)
        }
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueIdentifiers.ShowDetails.rawValue, sender: indexPath)
    }
    
    // MARK: PeekingDelegate
    
    func peekContext(_ context: PeekContext, viewControllerForPeekingAt location: CGPoint) -> UIViewController? {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "ViewController")
        if let viewController = viewController, let indexPath = tableView.indexPathForRow(at: location) {
            configureViewController(viewController, withItemAtIndexPath: indexPath)
            if let cell = tableView.cellForRow(at: indexPath) {
                context.sourceRect = cell.frame
            }
            return viewController
        }
        return nil
    }
    
    func peekContext(_ context: PeekContext, commit viewController: UIViewController) {
        show(viewController, sender: self)
    }
    
    // MARK: Helpers
    
    fileprivate func configureViewController(_ viewController: UIViewController, withItemAtIndexPath indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        viewController.title = cell.textLabel?.text
    }
    
}
