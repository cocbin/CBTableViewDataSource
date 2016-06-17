//
// Created by Cocbin on 16/6/17.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <CBTableViewDataSource/CBTableViewDataSource.h>
#import "CustomCellViewController.h"
#import "CustomCellViewModel.h"
#import "CustomCell.h"


@implementation CustomCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableView];
}


- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_tableView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView cb_makeSectionWithData:self.viewModel.data withCellClass:[CustomCell class]];
    }
    return _tableView;
}

- (CustomCellViewModel *)viewModel {
    if(!_viewModel) {
        _viewModel = [CustomCellViewModel new];
    }
    return _viewModel;
}

@end