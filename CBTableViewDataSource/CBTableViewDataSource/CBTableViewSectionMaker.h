//
// Created by Cocbin on 16/6/12.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark -- Class CBDataSourceSectionMaker
@class CBDataSourceSection;

@interface CBTableViewSectionMaker : NSObject

- (CBTableViewSectionMaker * (^)(Class))cell;

- (CBTableViewSectionMaker * (^)(NSArray *))data;

- (CBTableViewSectionMaker * (^)(void(^)(id cell, id data, NSUInteger index)))adapter;

- (CBTableViewSectionMaker * (^)(CGFloat))height;

- (CBTableViewSectionMaker * (^)())autoHeight;

- (CBTableViewSectionMaker * (^)(void(^)(NSUInteger index, id data)))event;

- (CBTableViewSectionMaker * (^)(NSString *))headerTitle;
- (CBTableViewSectionMaker * (^)(NSString *))footerTitle;

@property(nonatomic, strong) CBDataSourceSection * section;

@end
