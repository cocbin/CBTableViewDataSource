//
//  MainViewController.m
//  CBFundationDemo
//
//  Created by Cocbin on 16/5/23.
//  Copyright © 2016年 Cocbin. All rights reserved.
//

#import "CBIconfont.h"
#import "MainViewController.h"
#import "DemoThreeViewController.h"
#import "BaseNavigationViewController.h"
#import "DemoFourViewController.h"
#import "DemoTwoViewController.h"
#import "DemoOneViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        NSArray * controllersInfo = @[
                @{@"title" : @"DEMO ONE", @"image" : @"ic_demo1", @"selectImage" : @"ic_demo1", @"controller" : [[DemoOneViewController alloc] init]},
                @{@"title" : @"DEMO TWO", @"image" : @"ic_demo2", @"selectImage" : @"ic_demo2", @"controller" : [[DemoTwoViewController alloc] init]},
                @{@"title" : @"DEMO THREE", @"image" : @"ic_demo3", @"selectImage" : @"ic_demo3", @"controller" : [[DemoThreeViewController alloc] init]},
                @{@"title" : @"DEMO FOUR", @"image" : @"ic_demo4", @"selectImage" : @"ic_demo4", @"controller" : [[DemoFourViewController alloc] init]}
        ];

        for (NSUInteger i = 0; i < controllersInfo.count; ++ i) {
            UIViewController * vc = controllersInfo[i][@"controller"];
            vc.title = controllersInfo[i][@"title"];
            vc.tabBarItem.image = IFImageMake(controllersInfo[i][@"image"], [UIColor blackColor], 30);
            vc.tabBarItem.selectedImage = IFImageMake(controllersInfo[i][@"selectImage"], [UIColor blackColor], 30);
            [self addChildViewController:[[BaseNavigationViewController alloc] initWithRootViewController:vc]];
        }
        self.tabBar.tintColor = [UIColor colorWithRed:0.27 green:0.75 blue:0.78 alpha:1.00];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}


@end
