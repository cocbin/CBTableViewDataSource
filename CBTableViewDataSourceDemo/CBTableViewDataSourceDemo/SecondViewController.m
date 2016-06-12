//
// Created by Cocbin on 16/6/4.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

//#import <CBTableViewDataSource/CBTableViewDataSource.h>
#import "SecondViewController.h"
#import "SecondViewModel.h"
#import "FeedCell.h"
#import "UINavigationBar+Awesome.h"
#import <CBTableViewDataSource/CBTableViewDataSource.h>

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar lt_setBackgroundColor: [UIColor colorWithRed:0.00 green:0.57 blue:0.90 alpha:1.00]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    __weak typeof(self) weakSelf = self;
    self.viewModel.dataUpdate = ^(){
        [weakSelf.tableView reloadData];
    };

    [self.viewModel fetchData];;
}


- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_tableView];
        [_tableView cb_makeDataSource:^(CBTableViewDataSourceMaker * make) {
            [make makeSection:^(CBTableViewSectionMaker *section) {
                section.cell([FeedCell class])
                        .data(self.viewModel.feed)
                        .adapter(^(FeedCell * cell,NSDictionary * data,NSUInteger index){
                            [cell.avatarView setImage:[UIImage imageNamed:data[@"avatar"]]];
                            [cell.nameView setText:data[@"user"]];
                            [cell.dateView setText:data[@"date"]];
                            [cell.detailView setText:data[@"content"]];
                            [cell.imgView setImage:[UIImage imageNamed:data[@"image"]]];
                        })
                        .autoHeight();
            }];
        }];
    }
    return _tableView;
}

- (SecondViewModel *)viewModel {
    if(!_viewModel) {
        _viewModel = [[SecondViewModel alloc] init];
    }
    return _viewModel;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end