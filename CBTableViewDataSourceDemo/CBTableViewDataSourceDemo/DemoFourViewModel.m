//
// Created by Cocbin on 16/6/5.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import "DemoFourViewModel.h"

@implementation DemoFourViewModel

- (instancetype)init {
    self = [super init];
    if(self) {
        self.feed = [NSMutableArray array];
    }
    return self;
}

- (void)fetchData {
    NSError*error;
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"feed"ofType:@"json"];
    NSData *json = [[NSData alloc]initWithContentsOfFile:filePath];
    NSArray * jsonObject = [NSJSONSerialization JSONObjectWithData:json options:(NSJSONReadingOptions) kNilOptions error:&error];
    [self.feed addObjectsFromArray:jsonObject];
    if(self.dataUpdate) {
        self.dataUpdate();
    }
}

@end