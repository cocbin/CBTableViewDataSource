//
// Created by Cocbin on 16/6/4.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBTableViewDataSource;
@class DemoFourViewModel;


@interface DemoFourViewController : UIViewController

@property(nonatomic, retain) DemoFourViewModel * viewModel;

@property(nonatomic, retain) UITableView * tableView;
@end