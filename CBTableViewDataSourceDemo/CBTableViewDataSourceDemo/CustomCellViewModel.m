//
// Created by Cocbin on 16/6/17.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import "CustomCellViewModel.h"


@implementation CustomCellViewModel

- (NSMutableArray *)data {
    if(!_data) {
        _data = [@[
                @{@"avatar":@"avatar_01.jpg",@"name":@"John Doe",@"title":@"Hello there",@"detail":@"I am a placeholder for this row balabala ...",@"unread":@YES},
                @{@"avatar":@"avatar_02.jpg",@"name":@"John Doe",@"title":@"Hello there",@"detail":@"I am a placeholder for this row balabala ...",@"unread":@YES},
                @{@"avatar":@"avatar_03.jpg",@"name":@"John Doe",@"title":@"Hello there",@"detail":@"I am a placeholder for this row balabala ...",@"unread":@YES},
                @{@"avatar":@"avatar_04.jpg",@"name":@"John Doe",@"title":@"Hello there",@"detail":@"I am a placeholder for this row balabala ...",@"unread":@YES},
                @{@"avatar":@"avatar_05.jpg",@"name":@"John Doe",@"title":@"Hello there",@"detail":@"I am a placeholder for this row balabala ..."},
                @{@"avatar":@"avatar_06.jpg",@"name":@"John Doe",@"title":@"Hello there",@"detail":@"I am a placeholder for this row balabala ..."},
                @{@"avatar":@"avatar_07.jpg",@"name":@"John Doe",@"title":@"Hello there",@"detail":@"I am a placeholder for this row balabala ...",@"unread":@YES},
                @{@"avatar":@"avatar_08.jpg",@"name":@"John Doe",@"title":@"Hello there",@"detail":@"I am a placeholder for this row balabala ..."},
                @{@"avatar":@"avatar_01.jpg",@"name":@"John Doe",@"title":@"Hello there",@"detail":@"I am a placeholder for this row balabala ..."},
                @{@"avatar":@"avatar_02.jpg",@"name":@"John Doe",@"title":@"Hello there",@"detail":@"I am a placeholder for this row balabala ..."}
        ] mutableCopy];
    }
    return _data;
}

@end