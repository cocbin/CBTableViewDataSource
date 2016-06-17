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
#import "JustDataViewController.h"
#import "CustomCellViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (instancetype)init {
    self = [super init];
    if(self) {
        NSArray * controllersInfo = @[
                @{@"title":@"One Line",@"image":@"ic_demo1",@"selectImage":@"ic_demo1",@"controller":[[CustomCellViewController alloc]init]},
                @{@"title":@"One Line",@"image":@"ic_demo2",@"selectImage":@"ic_demo2",@"controller":[[JustDataViewController alloc]init]},
                @{@"title":@"First",@"image":@"ic_demo3",@"selectImage":@"ic_demo3",@"controller":[[FirstViewController alloc]init]},
                @{@"title":@"Second",@"image":@"ic_demo4",@"selectImage":@"ic_demo4",@"controller":[[SecondViewController alloc]init]}
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
