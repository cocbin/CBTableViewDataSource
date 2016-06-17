//
// Created by Cocbin on 16/6/16.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <CBTableViewDataSource/UITableView+CBTableViewDataSource.h>
#import "JustDataViewController.h"
#import "JustDataViewModel.h"


@implementation JustDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableView];
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.backgroundColor = [UIColor colorWithRed:0.94 green:0.95 blue:0.96 alpha:1.00];
        [_tableView setContentInset:UIEdgeInsetsMake(15,0,0,0)];
        [self.view addSubview:_tableView];

        // just one line here
        [_tableView cb_makeSectionWithData:self.viewModel.data];
    }
    return _tableView;
}

- (JustDataViewModel *)viewModel {
    if(!_viewModel) {
        _viewModel = [JustDataViewModel new];
    }
    return _viewModel;
}

@end