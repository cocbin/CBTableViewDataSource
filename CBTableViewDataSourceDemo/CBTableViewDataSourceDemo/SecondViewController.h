//
// Created by Cocbin on 16/6/4.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBTableViewDataSource;
@class SecondViewModel;


@interface SecondViewController : UIViewController

@property(nonatomic, retain) SecondViewModel * viewModel;

@property(nonatomic, retain) CBTableViewDataSource * dataSource;
@property(nonatomic, retain) UITableView * tableView;
@end