//
// Created by Cocbin on 16/6/17.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DemoOneViewModel;

@interface DemoOneViewController : UIViewController
@property(nonatomic, strong) DemoOneViewModel * viewModel;
@property(nonatomic, strong) UITableView * tableView;
@end