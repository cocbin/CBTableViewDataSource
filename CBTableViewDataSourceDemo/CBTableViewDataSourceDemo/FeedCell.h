//
// Created by Cocbin on 16/6/5.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FeedCell : UITableViewCell

@property(nonatomic, retain) UIImageView * avatarView;
@property(nonatomic, strong) UIView * userView;
@property(nonatomic, retain) UILabel * nameView;
@property(nonatomic, retain) UILabel * dateView;
@property(nonatomic, retain) UILabel * detailView;
@property(nonatomic, retain) UIImageView * imgView;
@end