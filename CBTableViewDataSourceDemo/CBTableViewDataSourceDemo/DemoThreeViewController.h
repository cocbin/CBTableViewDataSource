//
//  DemoThreeViewController.h
//  CBTableViewDataSourceDemo
//
//  Created by Cocbin on 16/6/4.
//  Copyright © 2016年 Cocbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DemoThreeViewModel;
@class CBTableViewDataSource;

@interface DemoThreeViewController : UIViewController

@property(nonatomic, retain) DemoThreeViewModel * viewModel;
@property(nonatomic, retain) UITableView * tableView;

@end
