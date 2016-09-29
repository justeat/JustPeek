<p align="center"><img src ="just_peek_banner.png?raw=true" /></p>

# JustPeek

<!-- [![CI Status](http://img.shields.io/travis/Gianluca Tranchedone/JustPeek.svg?style=flat)](https://travis-ci.org/Gianluca Tranchedone/JustPeek) -->
[![Version](https://img.shields.io/cocoapods/v/JustPeek.svg?style=flat)](http://cocoapods.org/pods/JustPeek)
[![License](https://img.shields.io/cocoapods/l/JustPeek.svg?style=flat)](http://cocoapods.org/pods/JustPeek)
[![Platform](https://img.shields.io/cocoapods/p/JustPeek.svg?style=flat)](http://cocoapods.org/pods/JustPeek)

## Usage

```swift
// In a UITableViewController

import JustPeek

...

private var peekController: PeekController?

// MARK: View Lifecycle

override func viewDidLoad() {
    super.viewDidLoad()
    peekController = PeekController()
    peekController?.register(viewController: self, forPeekingWithDelegate: self, sourceView: tableView)
}

// MARK: PeekingDelegate

func peekContext(context: PeekContext, viewControllerForPeekingAt location: CGPoint) -> UIViewController? {
    let viewController = storyboard?.instantiateViewControllerWithIdentifier("DestinationViewController")
    if let viewController = viewController, let indexPath = tableView.indexPathForRowAtPoint(location) {
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
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

JustPeek is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "JustPeek"
```

## Author

[Gianluca Tranchedone](https://github.com/gtranchedone)

## License

JustPeek is available under the MIT license. See the LICENSE file for more info.
