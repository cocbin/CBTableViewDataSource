//
// Created by Cocbin on 16/6/4.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import "GoodsCell.h"
#import "MASConstraintMaker.h"
#import "View+MASAdditions.h"


@implementation GoodsCell


- (UIImageView *)imgView {
    if(!_imgView) {
        _imgView = [[UIImageView alloc] init];
        [self addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(8);
            make.left.equalTo(self).offset(8);
            make.bottom.equalTo(self).offset(-8);
            make.width.equalTo(_imgView.mas_height);
        }];
        _imgView.backgroundColor = [UIColor grayColor];
    }
    return _imgView;
}

- (UILabel *)nameView {
    if(!_nameView) {
        _nameView = [[UILabel alloc] init];
        [self addSubview:_nameView];
        _nameView.textColor = [UIColor blackColor];
        _nameView.numberOfLines = 2;
        _nameView.font = [UIFont systemFontOfSize:14];
        [_nameView mas_makeConstraints:^(MASConstraintMaker * make) {
            make.top.equalTo(self).offset(8);
            make.left.equalTo(self.imgView.mas_right).offset(20);
            make.right.equalTo(self).offset(-15);
        }];
    }
    return _nameView;
}

- (UILabel *)priceView {
    if(!_priceView) {
        _priceView = [[UILabel alloc] init];
        _priceView.font = [UIFont systemFontOfSize:16];
        [self addSubview:_priceView];
        _priceView.textColor = [UIColor blackColor];
        [_priceView mas_makeConstraints:^(MASConstraintMaker * make) {
            make.top.equalTo(self.nameView.mas_bottom).offset(16);
            make.left.equalTo(self.imgView.mas_right).offset(20);
            make.right.equalTo(self).offset(-15);
        }];
    }
    return _priceView;
}

@end