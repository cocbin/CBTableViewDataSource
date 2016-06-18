//
// Created by Cocbin on 16/6/12.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBTableViewDataSource.h"

@interface CBDataSourceSection : NSObject

@property(nonatomic, strong) NSArray * data;
@property(nonatomic, strong) Class cell;
@property(nonatomic, strong) NSString * identifier;
@property(nonatomic, copy) AdapterBlock adapter;
@property(nonatomic, copy) EventBlock event;
@property(nonatomic, strong) NSString * headerTitle;
@property(nonatomic, strong) NSString * footerTitle;
@property(nonatomic, strong) UIView * headerView;
@property(nonatomic, strong) UIView * footerView;
@property(nonatomic, assign) BOOL isAutoHeight;
@property(nonatomic, assign) CGFloat staticHeight;

@property(nonatomic, assign) UITableViewCellStyle tableViewCellStyle;
@end