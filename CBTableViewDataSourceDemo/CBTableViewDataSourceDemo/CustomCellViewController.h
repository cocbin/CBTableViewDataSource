//
// Created by Cocbin on 16/6/17.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomCellViewModel;

@interface CustomCellViewController : UIViewController
@property(nonatomic, strong) CustomCellViewModel * viewModel;
@property(nonatomic, strong) UITableView * tableView;
@end