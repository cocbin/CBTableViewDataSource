//
// Created by Cocbin on 16/6/16.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JustDataViewModel;


@interface JustDataViewController : UIViewController

@property(nonatomic, strong) UITableView * tableView;
@property(nonatomic, strong) JustDataViewModel * viewModel;

@end