//
// Created by Cocbin on 16/5/30.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "HomeCategoryCell.h"

@interface CategoryCell : UIView
@property(nonatomic, retain) UIImageView * imageView;
@property (nonatomic, retain) UILabel * nameView;
@end

@implementation CategoryCell
- (UIImageView *)imageView {
    if (! _imageView) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker * make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-15);
            make.width.offset(30);
            make.height.offset(30);
        }];
    }
    return _imageView;
}

- (UILabel *)nameView {
    if(!_nameView) {
        _nameView = [[UILabel alloc] init];
        _nameView.font = [UIFont systemFontOfSize:14];
        _nameView.textColor = RGB(51,51,51);
        _nameView.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameView];
        [_nameView mas_makeConstraints:^(MASConstraintMaker * make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.imageView.mas_bottom).offset(8);
            make.width.equalTo(self);
            make.height.offset(22);
        }];
    }
    return _nameView;
}
@end


@implementation HomeCategoryCell

- (UIScrollView *)scrollView {
    if (! _scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        _scrollView.frame = self.bounds;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if(!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        [self addSubview:_pageControl];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker * make) {
            make.bottom.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.offset(20);
        }];
    }
    return _pageControl;
}


- (void)setCategory:(NSArray *)category {
    if (category == nil||category.count == 0) {
        return;
    }
    if (! [category isEqualToArray:_category]) {
        _category = category;
        CGFloat cellWidth = SCREEN_WIDTH / 4;
        CGFloat cellHeight = (CGFloat) ((SCREEN_WIDTH * 0.45) / 2);
        for (NSUInteger i = 0; i < category.count; i ++) {
            NSUInteger page = i / 8;
            NSUInteger row = i / 4 % 2;
            NSUInteger column = i % 4;
            CategoryCell * cell = [[CategoryCell alloc] init];
            [self.scrollView addSubview:cell];
            [cell mas_makeConstraints:^(MASConstraintMaker * make) {
                make.left.equalTo(self.scrollView).offset(page * SCREEN_WIDTH + column * cellWidth);
                make.top.equalTo(self.scrollView).offset(row * cellHeight);
                make.width.offset(cellWidth);
                make.height.offset(cellHeight);
            }];
            [cell.imageView setImage:[UIImage imageNamed:category[i][@"image"]]];
            cell.nameView.text = category[i][@"name"];
        }
        NSUInteger page = (category.count - 1) / 8 + 1;
        [self.scrollView setContentSize:CGSizeMake(page * SCREEN_WIDTH, (CGFloat) (SCREEN_WIDTH * 0.45))];
        self.pageControl.numberOfPages = page;
        self.pageControl.currentPage = 0;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = (NSInteger) (offsetX/SCREEN_WIDTH);
    self.pageControl.currentPage = index;
}
@end
