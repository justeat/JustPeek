<p align="center"><img src="just_peek_banner.png?raw=true" alt="JustPeek Banner" /></p>

# JustPeek

[![Version](https://img.shields.io/cocoapods/v/JustPeek.svg?style=flat)](http://cocoapods.org/pods/JustPeek)
[![License](https://img.shields.io/cocoapods/l/JustPeek.svg?style=flat)](http://cocoapods.org/pods/JustPeek)
[![Platform](https://img.shields.io/cocoapods/p/JustPeek.svg?style=flat)](http://cocoapods.org/pods/JustPeek)

### Warning: <span style="color:red">This library is not supported anymore by Just Eat and therefore considered deprecated.</span>

JustPeek is an iOS Library that adds support for Force Touch-like Peek and Pop interactions on devices that do not natively support this kind of interaction. Under the hood it uses the native implementation if available, otherwise a custom implementation based on `UILongPressGestureRecognizer`.

<p align="center"><img src="https://github.com/justeat/JustPeek/blob/master/just_peek_demo.gif?raw=true" alt="JustPeek Demo"  width="320px" height="568px" /></p>

## Usage

**NOTE: JustPeek requires Swift 3**

```swift
// In a UITableViewController

import JustPeek

...

var peekController: PeekController?

// MARK: View Lifecycle

override func viewDidLoad() {
    super.viewDidLoad()
    peekController = PeekController()
    peekController?.register(viewController: self, forPeekingWithDelegate: self, sourceView: tableView)
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
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

JustPeek is available through [CocoaPods](http://cocoapods.org).
To install it, simply add the following line to your Podfile:

```ruby
pod "JustPeek"
```

## License

JustPeek is available under the Apache License, Version 2.0. See the LICENSE file for more info.
