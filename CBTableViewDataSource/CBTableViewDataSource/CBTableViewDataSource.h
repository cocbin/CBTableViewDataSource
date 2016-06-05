//
// Created by Cocbin on 16/6/3.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBDataSourceMaker.h"

@interface CBTableViewDataSource : NSObject  <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, assign) NSUInteger sectionCount;
@property(nonatomic, retain) NSMutableArray * dataList;
@property(nonatomic, retain) NSMutableArray * dataCountOfSection;
@property(nonatomic, retain) NSMutableArray * dataBeginOfSection;
@property(nonatomic, retain) NSMutableArray * identifierOfSection;
@property(nonatomic, retain) NSMutableArray <AdaptBlock> * adapterList;

@property(nonatomic, retain) NSMutableArray * staticHeightList;
@property(nonatomic, retain) NSMutableArray * needAutoHeightList;
@property(nonatomic, retain) NSMutableArray * eventList;

@property(nonatomic, copy) void(^didScroll)(UIScrollView * scrollView);

@property(nonatomic, retain) NSMutableDictionary * title;

@end
