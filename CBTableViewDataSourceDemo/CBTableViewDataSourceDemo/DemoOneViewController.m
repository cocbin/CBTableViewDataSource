//
// Created by Cocbin on 16/6/17.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import "CBTableViewDataSource/CBTableViewDataSource.h"
#import "DemoOneViewController.h"
#import "DemoOneViewModel.h"
#import "CustomCell.h"
#import "UINavigationBar+Awesome.h"


@implementation DemoOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableView];

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar lt_setBackgroundColor: [UIColor colorWithRed:0.27 green:0.75 blue:0.78 alpha:1.00]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}


- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_tableView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [_tableView cb_makeSectionWithData:self.viewModel.data andCellClass:[CustomCell class]];
    }
    return _tableView;
}

- (DemoOneViewModel *)viewModel {
    if(!_viewModel) {
        _viewModel = [DemoOneViewModel new];
    }
    return _viewModel;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end