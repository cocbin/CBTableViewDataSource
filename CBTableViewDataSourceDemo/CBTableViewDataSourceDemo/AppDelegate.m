//
//  AppDelegate.m
//  CBTableViewDataSourceDemo
//
//  Created by Cocbin on 16/6/4.
//  Copyright © 2016年 Cocbin. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "CBIconfont.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[CBIconfont instance] initWithConfig:@{
                                            @(IFFontPath):@"iconfont.ttf",
                                            @(IFFontIdentify):@{
                                                    @"ic_star":@"\ue600",
                                                    @"ic_fire":@"\ue602",
                                                    @"ic_coffee":@"\ue601",
                                                    }
                                            }];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[MainViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
