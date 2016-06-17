//
// Created by Cocbin on 16/6/16.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import "DemoTwoViewModel.h"


@implementation DemoTwoViewModel {

}

- (NSMutableArray *)data {
    if(!_data) {
        // test data
        _data = [@[
                @{@"text":@"Following",@"value":@"45"},
                @{@"text":@"Follower",@"value":@"10"},
                @{@"text":@"Star",@"value":@"234"},
                @{@"text":@"Setting",@"accessoryType":@(UITableViewCellAccessoryDisclosureIndicator)},
                @{@"text":@"Share",@"accessoryType":@(UITableViewCellAccessoryDisclosureIndicator)},
        ] mutableCopy];
    }
    return _data;
}


@end