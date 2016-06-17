//
// Created by Cocbin on 16/6/16.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DemoTwoViewModel;


@interface DemoTwoViewController : UIViewController

@property(nonatomic, strong) UITableView * tableView;
@property(nonatomic, strong) DemoTwoViewModel * viewModel;

@end