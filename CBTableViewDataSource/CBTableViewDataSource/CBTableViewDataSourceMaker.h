//
// Created by Cocbin on 16/6/12.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -- Class CBTableViewDataSourceMaker
@class CBTableViewSectionMaker;

@interface CBTableViewDataSourceMaker : NSObject

- (void)makeSection:(void (^)(CBTableViewSectionMaker * section))block;

@property(nonatomic, weak) UITableView * tableView;
@property(nonatomic, strong) NSMutableArray * sections;

- (instancetype)initWithTableView:(UITableView *)tableView;
- (CBTableViewDataSourceMaker * (^)(CGFloat))height;
- (CBTableViewDataSourceMaker * (^)(UIView * (^)()))headerView;
- (CBTableViewDataSourceMaker * (^)(UIView * (^)()))footerView;

- (void)commitEditing:(void(^)(UITableView * tableView,UITableViewCellEditingStyle * editingStyle,NSIndexPath * indexPath))block;
- (void)scrollViewDidScroll:(void(^)(UIScrollView *scrollView))block;

@property(nonatomic, copy) void(^commitEditingBlock)(UITableView * tableView,UITableViewCellEditingStyle * editingStyle,NSIndexPath * indexPath);
@property(nonatomic, copy) void(^scrollViewDidScrollBlock)(UIScrollView *scrollView);
@end