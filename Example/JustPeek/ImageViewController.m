//
//  ImageViewController.m
//  JustPeek
//
//  Created by Gianluca Tranchedone for JustEat on 05/08/2016.
//


#import "ImageViewController.h"
#import <JustPeek/JustPeek-Swift.h>

@interface ImageViewController () <JEPeekingDelegate>

@property (nonatomic, strong) JEPeekController *peekController;

@end

@implementation ImageViewController

#pragma mark - JEPeekingDelegate

- (UIViewController *)peekContext:(JEPeekContext *)context viewControllerForPeekingAt:(CGPoint)location {
    UIViewController *viewController = [[UIViewController alloc] init];
    return viewController;
}

- (void)peekContext:(JEPeekContext *)context commit:(UIViewController *)viewController {
    // no-op
}

@end
