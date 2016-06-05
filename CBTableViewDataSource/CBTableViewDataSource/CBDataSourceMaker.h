//
// Created by Cocbin on 16/6/3.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBTableViewDataSource;

typedef UITableViewCell * (^AdaptBlock)(id cell,id data,NSUInteger index);
typedef void (^EventBlock)(NSUInteger index,id data);

@interface CBDataSourceMaker:NSObject

- (CBDataSourceMaker * )initWithUITableView:(UITableView * )tableView;
- (CBDataSourceMaker * (^)())section;
- (CBDataSourceMaker * (^)(Class))cell;
- (CBDataSourceMaker * (^)(NSArray * ))data;
- (CBDataSourceMaker * (^)(AdaptBlock))adapter;
- (CBTableViewDataSource *  (^)())make;
- (CBDataSourceMaker * (^)(UIView *(^)()))headerView;
- (CBDataSourceMaker * (^)(UIView *(^)()))footerView;

- (CBDataSourceMaker * (^)(CGFloat)) height;
- (CBDataSourceMaker * (^)()) autoHeight;

- (CBDataSourceMaker * (^)(EventBlock))event;

- (CBDataSourceMaker * (^)(NSString *)) title;

- (CBDataSourceMaker * (^)(void(^)(UIScrollView * )))didScroll;

@end

CBDataSourceMaker * CBDataSource(UITableView * tableView);