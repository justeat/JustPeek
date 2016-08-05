//
//  ImageViewController.m
//  JustPeek
//
//  Created by Gianluca Tranchedone on 05/08/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

#import "ImageViewController.h"
#import <JustPeek/JustPeek-Swift.h>

@interface ImageViewController () <JEPeekingDelegate>

@property (nonatomic, strong) JEPeekController *peekController;

@end

@implementation ImageViewController

#pragma mark - JEPeekingDelegate

- (JEPeekContext * _Nullable)peekController:(JEPeekController * _Nonnull)controller peekContextForLocation:(CGPoint)location {
    UIViewController *viewController = [[UIViewController alloc] init];
    return [[JEPeekContext alloc] initWithDestinationViewController:viewController rect:self.view.bounds];
}

- (void)peekController:(JEPeekController * _Nonnull)controller commit:(UIViewController * _Nonnull)viewController {
    // do something
}

@end
