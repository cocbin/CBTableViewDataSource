//
//  FirstViewController.h
//  CBTableViewDataSourceDemo
//
//  Created by Cocbin on 16/6/4.
//  Copyright © 2016年 Cocbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FirstViewModel;
@class CBTableViewDataSource;

@interface FirstViewController : UIViewController

@property(nonatomic, retain) FirstViewModel * viewModel;
@property(nonatomic, retain) UITableView * tableView;
@property(nonatomic, retain) CBTableViewDataSource * dataSource;

@end
