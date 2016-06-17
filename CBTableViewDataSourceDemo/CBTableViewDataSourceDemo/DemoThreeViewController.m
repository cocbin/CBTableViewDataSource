//
//  DemoThreeViewController.m
//  CBTableViewDataSourceDemo
//
//  Created by Cocbin on 16/6/4.
//  Copyright © 2016年 Cocbin. All rights reserved.
//

#import "DemoThreeViewController.h"
#import "DemoThreeViewModel.h"
#import "CycleScrollViewCell.h"
#import "HomeCategoryCell.h"
#import "HomeActivityCell.h"
#import "GoodsCell.h"
#import "UINavigationBar+Awesome.h"
#import <CBTableViewDataSource/CBTableViewDataSource.h>

@interface DemoThreeViewController ()

@end

@implementation DemoThreeViewController

void(^didScroll)(UIScrollView * scrollView);

- (void)viewDidLoad {
    [super viewDidLoad];

    didScroll = ^(UIScrollView * scrollView) {
            UIColor * color = [UIColor colorWithRed:0.27 green:0.75 blue:0.78 alpha:1.00];
            CGFloat offsetY = scrollView.contentOffset.y;
            if (offsetY > 50) {
                CGFloat alpha = MIN(1, 1 - ((50 + 64 - offsetY) / 64));
                [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
            } else {
                [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
            }
    };

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    __weak typeof(self) weakSelf = self;
    self.viewModel.dataUpdate = ^(){
        [weakSelf.tableView reloadData];
    };
    [self.viewModel fetchData];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if(didScroll) {
        didScroll(self.tableView);
    }
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

- (DemoThreeViewModel *)viewModel {
    if(!_viewModel) {
        _viewModel = [[DemoThreeViewModel alloc]init];
    }
    return _viewModel;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];

        [_tableView cb_makeDataSource:^(CBTableViewDataSourceMaker * make) {
            [make scrollViewDidScroll:didScroll];
            [make makeSection:^(CBTableViewSectionMaker * section) {
                section.cell([CycleScrollViewCell class])
                        .data(@[self.viewModel.ads])
                        .adapter(^(CycleScrollViewCell * cell,NSArray * data,NSUInteger index){
                            cell.data = data;
                        })
                        .height(SCREEN_WIDTH * 0.48f);
            }];
            [make makeSection:^void(CBTableViewSectionMaker * section) {
                section.cell([HomeCategoryCell class])
                        .data(@[self.viewModel.category])
                        .adapter(^(HomeCategoryCell * cell,NSArray * data,NSUInteger index){
                            cell.category = data;
                        })
                        .height(SCREEN_WIDTH * 0.48f);
            }];
            [make makeSection:^void(CBTableViewSectionMaker * section) {
                section
                    .cell([HomeActivityCell class])
                    .data(self.viewModel.activity)
                    .adapter(^(HomeActivityCell * cell,NSDictionary * data,NSUInteger index){
                        [cell.imgView setImage:[UIImage imageNamed:data[@"image"]]];
                    })
                    .height(SCREEN_WIDTH * 0.36f);
            }];
            [make makeSection:^void(CBTableViewSectionMaker * section) {
                section
                    .cell([GoodsCell class])
                    .data(self.viewModel.hotGoods)
                    .adapter(^(GoodsCell * cell,NSDictionary * data,NSUInteger index){
                        if(index&1) {
                            cell.backgroundColor = [UIColor whiteColor];
                        } else {
                            cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.96 alpha:1.00];
                        }
                        [cell.imgView setImage:[UIImage imageNamed:data[@"image"]]];
                        [cell.nameView setText:data[@"name"]];
                        [cell.priceView setText:[NSString stringWithFormat:@"￥%@",data[@"price"]]];
                        [cell.infoView setText:data[@"info"]];
                    })
                    .height(160);
            }];
        }];
    }
    return _tableView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
