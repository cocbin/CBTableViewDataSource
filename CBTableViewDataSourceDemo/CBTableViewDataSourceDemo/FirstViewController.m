//
//  FirstViewController.m
//  CBTableViewDataSourceDemo
//
//  Created by Cocbin on 16/6/4.
//  Copyright © 2016年 Cocbin. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstViewModel.h"
#import "CycleScrollViewCell.h"
#import "HomeCategoryCell.h"
#import "HomeActivityCell.h"
#import "GoodsCell.h"
#import "SplitView.h"
#import "UINavigationBar+Awesome.h"
#import <CBTableViewDataSource/CBTableViewDataSource.h>

@interface FirstViewController ()

@end

@implementation FirstViewController

void(^didScroll)(UIScrollView * scrollView);

- (void)viewDidLoad {
    [super viewDidLoad];

    didScroll = ^(UIScrollView * scrollView) {
            UIColor * color = [UIColor colorWithRed:0.00 green:0.57 blue:0.90 alpha:1.00];
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
    [self dataSource];
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

- (FirstViewModel *)viewModel {
    if(!_viewModel) {
        _viewModel = [[FirstViewModel alloc]init];
    }
    return _viewModel;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (CBTableViewDataSource *)dataSource {
    if(!_dataSource) {
        _dataSource = CBDataSource(self.tableView)
                //-------------- advertisement section --------------
                .section()
                .cell([CycleScrollViewCell class])
                .data(@[self.viewModel.ads])
                .adapter(^UITableViewCell *(CycleScrollViewCell * cell,NSArray * data,NSUInteger index){
                    cell.data = self.viewModel.ads;
                    return cell;
                })
                .height(SCREEN_WIDTH * 0.48f)

                        //-------------- category section --------------
                .section()
                .cell([HomeCategoryCell class])
                .data(@[self.viewModel.category])
                .adapter(^UITableViewCell * (HomeCategoryCell * cell,NSArray * data,NSUInteger index){
                    cell.category = data;
                    return cell;
                })
                .height(SCREEN_WIDTH * 0.48f)

                        //-------------- activity section --------------
                .section()
                .cell([SplitView class])
                .data(@[@"热门活动"])
                .adapter(^UITableViewCell * (SplitView * cell,NSString * data,NSUInteger index){
                    cell.label.text = [NSString stringWithFormat:@"—  %@ —",data];
                    return cell;
                })
                .height(60)


                .section()
                .cell([HomeActivityCell class])
                .data(self.viewModel.activity)
                .adapter(^UITableViewCell * (HomeActivityCell * cell,NSDictionary * data,NSUInteger index){
                    [cell.imgView setImage:[UIImage imageNamed:data[@"image"]]];
                    return cell;
                })
                .height(SCREEN_WIDTH * 0.36f)

                        //-------------- hot goods section --------------
                .section()
                .cell([SplitView class])
                .data(@[@"热门商品"])
                .adapter(^UITableViewCell * (SplitView * cell,NSString * data,NSUInteger index){
                    cell.label.text = [NSString stringWithFormat:@"—  %@ —",data];
                    return cell;
                })
                .height(60)


                .section()
                .cell([GoodsCell class])
                .data(self.viewModel.hotGoods)
                .adapter(^UITableViewCell * (GoodsCell * cell,NSDictionary * data,NSUInteger index){
                    [cell.imgView setImage:[UIImage imageNamed:data[@"image"]]];
                    [cell.nameView setText:data[@"name"]];
                    [cell.priceView setText:[NSString stringWithFormat:@"$%@",data[@"price"]]];
                    return cell;
                })
                .height(100)

                        //-------------- rand goods section --------------//随机

                .section()
                .cell([SplitView class])
                .data(@[@"猜你喜欢"])
                .adapter(^UITableViewCell * (SplitView * cell,NSString * data,NSUInteger index){
                    cell.label.text = [NSString stringWithFormat:@"— %@ —",data];
                    return cell;
                })
                .height(60)

                .section()
                .cell([GoodsCell class])
                .data(self.viewModel.hotGoods)
                .adapter(^UITableViewCell * (GoodsCell * cell,NSDictionary * data,NSUInteger index) {
                    [cell.imgView setImage:[UIImage imageNamed:data[@"image"]]];
                    [cell.nameView setText:data[@"name"]];
                    [cell.priceView setText:[NSString stringWithFormat:@"$%@",data[@"price"]]];
                    return cell;
                })
                .height(100)
                .didScroll(didScroll)
                .make();
    }
    return _dataSource;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
