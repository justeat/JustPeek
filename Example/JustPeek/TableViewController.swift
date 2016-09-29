//
//  TableViewController.swift
//  JustPeek
//
//  Created by Gianluca Tranchedone for JustEat on 05/08/2016.
//

import UIKit
import JustPeek

class TableViewController: UITableViewController, PeekingDelegate {
    
    enum SegueIdentifiers: String {
        case ShowDetails = "ShowDetailsSegueIdentifier"
    }
    
    private var peekController: PeekController?
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peekController = PeekController()
        peekController?.register(viewController: self, forPeekingWithDelegate: self, sourceView: tableView)
    }
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifiers.ShowDetails.rawValue {
            guard let indexPath = sender as? NSIndexPath else { return }
            configureViewController(segue.destinationViewController, withItemAtIndexPath: indexPath)
        }
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(SegueIdentifiers.ShowDetails.rawValue, sender: indexPath)
    }
    
    // MARK: PeekingDelegate
    
    func peekContext(context: PeekContext, viewControllerForPeekingAt location: CGPoint) -> UIViewController? {
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("ViewController")
        if let viewController = viewController, indexPath = tableView.indexPathForRowAtPoint(location) {
            configureViewController(viewController, withItemAtIndexPath: indexPath)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                context.sourceRect = cell.frame
            }
            return viewController
        }
        return nil
    }
    
    func peekContext(context: PeekContext, commit viewController: UIViewController) {
        showViewController(viewController, sender: self)
    }
    
    // MARK: Helpers
    
    private func configureViewController(viewController: UIViewController, withItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) else { return }
        viewController.title = cell.textLabel?.text
    }
    
}
