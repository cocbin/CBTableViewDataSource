//
// Created by Cocbin on 16/5/30.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "CycleScrollViewCell.h"

@interface CycleScrollViewCell()<UIScrollViewDelegate>
@end

@implementation CycleScrollViewCell {
    NSMutableArray * _imageViews;
    NSInteger _imageCount;
    NSTimer * _timer;
}

- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [self addSubview:_scrollView];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
        [_scrollView mas_makeConstraints:^(MASConstraintMaker * make){
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
        }];

        //mask
        CAGradientLayer *gradientLayer;
        gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0,0,self.frame.size.width,40);
        gradientLayer.startPoint = CGPointMake(0,0);
        gradientLayer.endPoint = CGPointMake(0,1);
        gradientLayer.colors = @[(__bridge id) [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor,(__bridge id)[UIColor clearColor].CGColor];
        [self.layer addSublayer:gradientLayer];
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if(!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        [self addSubview:_pageControl];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = 1;
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker * make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.offset(20);
        }];
    }
    return _pageControl;
}

- (void)setData:(NSArray *)data {

    if(data == nil||data.count == 0) {
         return ;
    }
    if(! [_data isEqualToArray:data]) {
        if(_imageViews&&_imageViews.count>0) {
            for (NSUInteger i = 0; i < _imageViews.count ; ++ i) {
                [((UIImageView *) _imageViews[i]) removeFromSuperview];
            }
            _imageViews = nil;
        }

        if(_timer) {
            [_timer invalidate];
            _timer = nil;
        }

        //last image
        _imageViews = [[NSMutableArray alloc] init];
        UIImageView * lastView = [[UIImageView alloc]init];
        [self.scrollView addSubview:lastView];
        [lastView mas_makeConstraints:^(MASConstraintMaker * make) {
            make.left.equalTo(self.scrollView);
            make.top.equalTo(self.scrollView);
            make.height.equalTo(self);
            make.width.equalTo(self);
        }];
        [lastView setImage:[UIImage imageNamed:data[data.count-1][@"url"]]];
        [_imageViews addObject:lastView];

        //inside image
        for(NSUInteger i = 0 ; i< data.count;i++) {
            UIImageView * view = [[UIImageView alloc] init];
            [self.scrollView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker * make) {
                make.left.equalTo(lastView.mas_right);
                make.top.equalTo(lastView);
                make.height.equalTo(lastView);
                make.width.equalTo(lastView);
            }];
            [view setImage:[UIImage imageNamed:data[i][@"url"]]];
            lastView = view;
            view.userInteractionEnabled = YES;
            UITapGestureRecognizer * gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewClick)];
            gestureRecognizer.numberOfTapsRequired = 1;
            [view addGestureRecognizer:gestureRecognizer];
            [_imageViews addObject:view];
        }

        // first image
        _imageViews = [[NSMutableArray alloc] init];
        UIImageView * firstView = [[UIImageView alloc]init];
        [self.scrollView addSubview:firstView];
        [firstView mas_makeConstraints:^(MASConstraintMaker * make) {
            make.left.equalTo(lastView.mas_right);
            make.top.equalTo(lastView);
            make.height.equalTo(lastView);
            make.width.equalTo(lastView);
        }];
        [firstView setImage:[UIImage imageNamed:data[0][@"url"]]];
        [_imageViews addObject:firstView];
        _imageCount = data.count;
        self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH,0);

        self.scrollView.contentSize = CGSizeMake((data.count+2)*SCREEN_WIDTH,_scrollView.frame.size.height);
        self.pageControl.numberOfPages = data.count;
        self.pageControl.currentPage = 0;
        _data = data;
        _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];

    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = (NSInteger) (offsetX/SCREEN_WIDTH);
    if(index > _imageCount) {
        scrollView.contentOffset = CGPointMake(SCREEN_WIDTH,0);
    } else if(index == 0) {
        scrollView.contentOffset = CGPointMake(_imageCount * SCREEN_WIDTH,0);
    }
    if(index ==0) {
        self.pageControl.currentPage = _imageCount -1;
    } else {
        self.pageControl.currentPage = (index-1)%_imageCount;
    }
}

- (void) autoScroll {
    [UIView animateWithDuration:0.4 animations:^(){
        [self.scrollView setContentOffset:CGPointMake((self.pageControl.currentPage+2)*SCREEN_WIDTH,0)];
    } completion:^(BOOL finish){
        [self scrollViewDidEndDecelerating:self.scrollView];
    }];
}

- (void) onViewClick {
    if(self.delegate) {
        [self.delegate onCycleScrollViewClick:self.pageControl.currentPage];
    }
}

@end