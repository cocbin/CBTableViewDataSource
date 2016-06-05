//
// Created by Cocbin on 16/5/30.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "HomeActivityCell.h"


@implementation HomeActivityCell

- (UIImageView *)imgView {
    if(!_imgView) {
        self.backgroundColor = [UIColor whiteColor];
        _imgView = [[UIImageView alloc] init];
        [self addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker * make) {
            make.bottom.equalTo(self).offset(-8);
            make.left.equalTo(self).offset(8);
            make.width.equalTo(self).offset(-16);
            make.height.equalTo(self).offset(-8);
        }];
    }
    return _imgView;
}

@end