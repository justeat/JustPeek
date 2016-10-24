<p align="center"><img src="just_peek_banner.png?raw=true" alt="JustPeek Banner" /></p>

# JustPeek

[![CI Status](http://img.shields.io/travis/justeat/JustPeek.svg?style=flat)](https://travis-ci.org/justeat/JustPeek)
[![Version](https://img.shields.io/cocoapods/v/JustPeek.svg?style=flat)](http://cocoapods.org/pods/JustPeek)
[![License](https://img.shields.io/cocoapods/l/JustPeek.svg?style=flat)](http://cocoapods.org/pods/JustPeek)
[![Platform](https://img.shields.io/cocoapods/p/JustPeek.svg?style=flat)](http://cocoapods.org/pods/JustPeek)

JustPeek is an iOS Library that adds support for Force Touch-like Peek and Pop interactions on devices that do not natively support this kind of interaction. Under the hood it uses the native implementation if available, otherwise a custom implementation based on `UILongPressGestureRecognizer`.

<p align="center"><img src="https://github.com/justeat/JustPeek/blob/master/just_peek_demo.gif?raw=true" alt="JustPeek Demo"  width="320px" height="568px" /></p>

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

If you use Swift 3 in your project, you can either point to the `swift3` branch or add the following code to your `Podfile`:

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == "JustPeek" do
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '2.3'
      end
    end
  end
end
```

## License

JustPeek is available under the Apache License, Version 2.0. See the LICENSE file for more info.
