//
// Created by Cocbin on 16/6/17.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import "CustomCell.h"
#import "View+MASAdditions.h"


@implementation CustomCell

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
        [self.contentView addSubview:_avatarView];
        [_avatarView mas_makeConstraints:^(MASConstraintMaker * make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(15);
            make.width.offset(60);
            make.height.offset(60);
            make.bottom.equalTo(self.contentView).offset(-15);
        }];
        _avatarView.layer.cornerRadius = 30;
        _avatarView.layer.masksToBounds = YES;
    }
    return _avatarView;
}

- (UILabel *)nameLabel {
    if (! _nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker * make) {
            make.left.equalTo(self.avatarView.mas_right).offset(20);
            make.top.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(- 20);
        }];
        _nameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nameLabel;
}

- (UILabel *)titleLabel {
    if (! _titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker * make) {
            make.left.equalTo(self.nameLabel);
            make.right.equalTo(self.nameLabel);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(4);
        }];
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (! _detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_detailLabel];
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker * make) {
            make.left.equalTo(self.nameLabel);
            make.right.equalTo(self.nameLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
        }];
        _detailLabel.font = [UIFont systemFontOfSize:12];
        _detailLabel.textColor = [UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1.00];
    }
    return _detailLabel;
}

- (UIView *)circleView {
    if (! _circleView) {
        _circleView = [[UIView alloc] init];
        [self.contentView addSubview:_circleView];
        [_circleView mas_makeConstraints:^(MASConstraintMaker * make) {
            make.right.equalTo(self.contentView).offset(- 15);
            make.centerY.equalTo(self.contentView);
            make.size.offset(10);
        }];
        _circleView.layer.masksToBounds = YES;
        _circleView.layer.cornerRadius = 5;
        _circleView.backgroundColor = [UIColor colorWithRed:0.25 green:0.85 blue:0.98 alpha:1.00];
    }
    return _circleView;
}

- (void)configure:(NSDictionary *)row index:(NSNumber * )index {
    if (row[@"avatar"]) {
        [self.avatarView setImage:[UIImage imageNamed:row[@"avatar"]]];
    } else {
        [self.avatarView setImage:nil];
    }
    [self.nameLabel setText:row[@"name"]];
    [self.titleLabel setText:row[@"title"]];
    [self.detailLabel setText:row[@"detail"]];
    self.circleView.hidden = row[@"unread"] == nil;

    if([index intValue] &1) {
        self.contentView.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.96 alpha:1.00];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

@end