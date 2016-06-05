//
// Created by Cocbin on 16/6/5.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import "FeedCell.h"
#import "View+MASAdditions.h"


@implementation FeedCell

- (UIImageView *)avatarView {
    if (! _avatarView) {
        _avatarView = [[UIImageView alloc] init];
        [self.contentView addSubview:_avatarView];
        [_avatarView mas_makeConstraints:^(MASConstraintMaker * make) {
            make.left.equalTo(self.contentView).offset(8);
            make.top.equalTo(self.contentView).offset(8);
            make.size.offset(30);
        }];
        _avatarView.layer.cornerRadius = 15;
        _avatarView.layer.masksToBounds = YES;
    }
    return _avatarView;
}

- (UILabel *)nameView {
    if (! _nameView) {
        _nameView = [[UILabel alloc] init];
        [self.contentView addSubview:_nameView];
        [_nameView mas_makeConstraints:^(MASConstraintMaker * make) {
            make.left.equalTo(self.avatarView.mas_right).offset(8);
            make.top.equalTo(self.avatarView);
            make.bottom.equalTo(self.avatarView);
        }];
        _nameView.textColor = [UIColor colorWithRed:0.00 green:0.57 blue:0.90 alpha:1.00];
        _nameView.font = [UIFont systemFontOfSize:16];
    }
    return _nameView;
}

- (UILabel *)dateView {
    if (! _dateView) {
        _dateView = [[UILabel alloc] init];
        [self.contentView addSubview:_dateView];
        [_dateView mas_makeConstraints:^(MASConstraintMaker * make) {
            make.left.equalTo(self.nameView.mas_right).offset(8);
            make.top.equalTo(self.avatarView);
            make.bottom.equalTo(self.avatarView);
            make.right.equalTo(self.contentView).offset(- 8);
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
            make.left.equalTo(self.contentView).offset(8);
            make.top.equalTo(self.avatarView.mas_bottom).offset(8);
            make.right.equalTo(self.contentView).offset(- 8);
        }];
        _detailView.textColor = RGB(0.2,0.2,0.2);
    }
    return _detailView;
}

- (UIImageView *)imgView {
    if (! _imgView) {
        _imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker * make) {
            make.left.equalTo(self.contentView).offset(8);
            make.top.equalTo(self.detailView.mas_bottom).offset(8);
            make.right.lessThanOrEqualTo(self.contentView).offset(- 8);
            make.bottom.equalTo(self.contentView).offset(- 8);
            make.height.lessThanOrEqualTo(self.contentView.mas_width).offset(- 100);
        }];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
    }
    return _imgView;
}

@end