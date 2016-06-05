//
// Created by Cocbin on 16/5/30.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  CycleScrollViewDelegate

- (void) onCycleScrollViewClick:(NSInteger)index;

@end

@interface CycleScrollViewCell : UITableViewCell

@property (nonatomic, retain) UIScrollView * scrollView;
@property (nonatomic, retain) UIPageControl * pageControl;
@property (nonatomic, retain) NSArray * data;

@property (nonatomic, weak) id <CycleScrollViewDelegate>delegate;

@end