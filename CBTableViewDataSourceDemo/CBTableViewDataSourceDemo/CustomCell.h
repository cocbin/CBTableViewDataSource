//
// Created by Cocbin on 16/6/17.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property(nonatomic, strong) UIImageView * avatarView;
@property(nonatomic, strong) UILabel * nameLabel;
@property(nonatomic, strong) UILabel * titleLabel;
@property(nonatomic, strong) UILabel * detailLabel;

@property(nonatomic, strong) UIView * circleView;

-(void)configure:(NSDictionary * )row index:(NSUInteger)index;

@end