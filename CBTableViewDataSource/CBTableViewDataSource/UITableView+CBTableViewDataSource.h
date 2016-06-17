//
// Created by Cocbin on 16/6/12.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBBaseTableViewDataSource;
@class CBTableViewDataSourceMaker;

@interface UITableView (CBTableViewDataSource)

@property(nonatomic, strong) CBBaseTableViewDataSource * cbTableViewDataSource;

- (void)cb_makeDataSource:(void (^)(CBTableViewDataSourceMaker * make))maker;
- (void)cb_makeSectionWithData:(NSArray *)data;
- (void)cb_makeSectionWithData:(NSArray *)data withCellClass:(Class)cellClass;

@end

__attribute__((unused)) static void commitEditing(id self, SEL cmd, UITableView * tableView, UITableViewCellEditingStyle editingStyle, NSIndexPath * indexPath);

__attribute__((unused)) static void scrollViewDidScroll(id self, SEL cmd, UIScrollView * scrollView);