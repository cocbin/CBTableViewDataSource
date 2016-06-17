//
// Created by Cocbin on 16/6/5.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import "FeedCell.h"
#import "View+MASAdditions.h"


@implementation FeedCell

- (UIView *)userView {
    if(!_userView) {
        _userView = [UIView new];
        [self.contentView addSubview:_userView];
        [_userView mas_makeConstraints:^(MASConstraintMaker * make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
        }];
        _userView.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.96 alpha:1.00];
    }
    return _userView;
}

- (UIImageView *)avatarView {
    if (! _avatarView) {
        _avatarView = [UIImageView new];
        [self.userView addSubview:_avatarView];

        [_avatarView mas_makeConstraints:^(MASConstraintMaker * make) {
            make.left.equalTo(self.userView).offset(15);
            make.top.equalTo(self.userView).offset(15);
            make.size.offset(42);
            make.bottom.equalTo(self.userView).offset(-15);
        }];
        _avatarView.layer.cornerRadius = 21;
        _avatarView.layer.masksToBounds = YES;
    }
    return _avatarView;
}

- (UILabel *)nameView {
    if (! _nameView) {
        _nameView = [[UILabel alloc] init];
        [self.userView addSubview:_nameView];
        [_nameView mas_makeConstraints:^(MASConstraintMaker * make) {
            make.left.equalTo(self.avatarView.mas_right).offset(15);
            make.top.equalTo(self.avatarView);
        }];
        _nameView.textColor = [UIColor colorWithRed:0.00 green:0.57 blue:0.90 alpha:1.00];
        _nameView.font = [UIFont systemFontOfSize:16];
    }
    return _nameView;
}

- (UILabel *)dateView {
    if (! _dateView) {
        _dateView = [[UILabel alloc] init];
        [self.userView addSubview:_dateView];
        [_dateView mas_makeConstraints:^(MASConstraintMaker * make) {
            make.left.equalTo(self.nameView);
            make.top.equalTo(self.nameView.mas_bottom).offset(4);
            make.right.equalTo(self.contentView).offset(-15);
        }];
        _dateView.font = [UIFont systemFontOfSize:12];
        _dateView.textColor = [UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1.00];
    }
    return _dateView;
}

- (UILabel *)detailView {
    if (! _detailView) {
        _detailView = [[UILabel alloc] init];
        [self.contentView addSubview:_detailView];
        _detailView.numberOfLines = 0;
        [_detailView mas_makeConstraints:^(MASConstraintMaker * make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(- 15);
            make.top.equalTo(self.userView.mas_bottom).offset(15);
        }];
        _detailView.textColor = [UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1.00];
    }
    return _detailView;
}

- (UIImageView *)imgView {
    if (! _imgView) {
        _imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker * make) {
            make.left.equalTo(self.contentView).offset(8);
            make.right.equalTo(self.contentView).offset(-8);
            make.height.lessThanOrEqualTo(self.contentView.mas_width).offset(- 100);
            make.top.equalTo(self.detailView.mas_bottom).offset(15);
        }];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;

        UIView * border = [UIView new];
        [self.contentView addSubview:border];
        [border mas_makeConstraints:^(MASConstraintMaker * make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.top.equalTo(_imgView.mas_bottom).offset(15);
            make.height.offset(10);
        }];
        border.backgroundColor = [UIColor colorWithRed:0.94 green:0.95 blue:0.96 alpha:1.00];
        border.layer.borderColor = [UIColor colorWithRed:0.84 green:0.85 blue:0.86 alpha:1.00].CGColor;
        border.layer.borderWidth = 0.5;
    }
    return _imgView;
}

@end