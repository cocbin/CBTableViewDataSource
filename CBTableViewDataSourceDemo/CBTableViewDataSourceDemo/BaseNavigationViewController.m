//
// Created by Cocbin on 16/5/30.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import "BaseNavigationViewController.h"


@implementation BaseNavigationViewController

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

@end