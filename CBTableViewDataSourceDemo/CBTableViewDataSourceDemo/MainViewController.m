//
//  MainViewController.m
//  CBFundationDemo
//
//  Created by Cocbin on 16/5/23.
//  Copyright © 2016年 Cocbin. All rights reserved.
//

#import "CBIconfont.h"
#import "MainViewController.h"
#import "FirstViewController.h"
#import "BaseNavigationViewController.h"
#import "SecondViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (instancetype)init {
    self = [super init];
    if(self) {
        NSArray * controllersInfo = @[
                @{@"title":@"First",@"image":@"ic_fire",@"selectImage":@"ic_fire",@"controller":[[FirstViewController alloc]init]},
                @{@"title":@"Second",@"image":@"ic_coffee",@"selectImage":@"ic_coffee",@"controller":[[SecondViewController alloc]init]}
        ];

        for (NSUInteger i = 0; i < controllersInfo.count; ++ i) {
            UIViewController * vc = controllersInfo[i][@"controller"];
            vc.title = controllersInfo[i][@"title"];
            vc.tabBarItem.image = IFImageMake(controllersInfo[i][@"image"], [UIColor blackColor],30);
            vc.tabBarItem.selectedImage = IFImageMake(controllersInfo[i][@"selectImage"], [UIColor blackColor],30);
            [self addChildViewController:[[BaseNavigationViewController alloc] initWithRootViewController:vc]];
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}


@end
