//
// Created by Cocbin on 16/6/4.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

//#import <CBTableViewDataSource/CBTableViewDataSource.h>
#import "DemoFourViewController.h"
#import "DemoFourViewModel.h"
#import "FeedCell.h"
#import "UINavigationBar+Awesome.h"
#import <CBTableViewDataSource/CBTableViewDataSource.h>

@implementation DemoFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar lt_setBackgroundColor: [UIColor colorWithRed:0.27 green:0.75 blue:0.78 alpha:1.00]];
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (DemoFourViewModel *)viewModel {
    if(!_viewModel) {
        _viewModel = [[DemoFourViewModel alloc] init];
    }
    return _viewModel;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end