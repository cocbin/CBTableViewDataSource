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
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.masksToBounds = YES;
        [_imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(8);
            make.left.equalTo(self).offset(8);
            make.bottom.equalTo(self).offset(-8);
            make.width.equalTo(_imgView.mas_height);
        }];
    }
    return _imgView;
}

- (UILabel *)nameView {
    if(!_nameView) {
        _nameView = [[UILabel alloc] init];
        [self addSubview:_nameView];
        _nameView.textColor = [UIColor blackColor];
        _nameView.numberOfLines = 2;
        _nameView.font = [UIFont systemFontOfSize:16];
        [_nameView mas_remakeConstraints:^(MASConstraintMaker * make) {
            make.top.equalTo(self).offset(15);
            make.left.equalTo(self.imgView.mas_right).offset(20);
            make.right.equalTo(self).offset(-15);
        }];
    }
    return _nameView;
}

- (UILabel *)priceView {
    if(!_priceView) {
        _priceView = [[UILabel alloc] init];
        _priceView.font = [UIFont systemFontOfSize:18];
        _priceView.textColor = [UIColor colorWithRed:0.77 green:0.00 blue:0.00 alpha:1.00];
        [self addSubview:_priceView];
        [_priceView mas_makeConstraints:^(MASConstraintMaker * make) {
            make.top.equalTo(self.nameView.mas_bottom).offset(8);
            make.left.equalTo(self.nameView);
            make.right.equalTo(self).offset(-15);
        }];
    }
    return _priceView;
}

- (UILabel *)infoView {
    if(!_infoView) {
        _infoView = [UILabel new];
        [self addSubview:_infoView];
        [_infoView mas_makeConstraints:^(MASConstraintMaker * make) {
            make.left.equalTo(self.priceView);
            make.bottom.equalTo(self).offset(-15);
        }];
        _infoView.font = [UIFont systemFontOfSize:12];
        _infoView.textColor = [UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1.00];
    }
    return _infoView;
}


@end