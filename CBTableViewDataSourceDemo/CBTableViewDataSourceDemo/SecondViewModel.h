//
// Created by Cocbin on 16/6/5.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SecondViewModel : NSObject

@property(nonatomic, retain) NSMutableArray * feed;
@property (nonatomic, copy) void(^dataUpdate)();

- (void)fetchData ;

@end