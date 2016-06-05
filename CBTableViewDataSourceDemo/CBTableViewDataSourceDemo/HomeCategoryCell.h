//
// Created by Cocbin on 16/5/30.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomeCategoryCell : UITableViewCell <UIScrollViewDelegate>

@property (nonatomic, retain) UIScrollView * scrollView;
@property (nonatomic, retain) NSArray * category;
@property (nonatomic, retain) UIPageControl * pageControl;

@end