//
//  FirstViewModel.m
//  CBTableViewDataSourceDemo
//
//  Created by Cocbin on 16/6/4.
//  Copyright © 2016年 Cocbin. All rights reserved.
//

#import "FirstViewModel.h"

@implementation FirstViewModel

/**
 @property (nonatomic, retain) NSArray * activity;
@property (nonatomic, retain) NSArray * hotGoods;
@property (nonatomic, retain) NSArray * randGoods;
 */

- (instancetype)init {
    self = [super init];
    if(self) {
        self.ads = [NSMutableArray array];
        self.category = [NSMutableArray array];
        self.activity = [NSMutableArray array];
        self.hotGoods = [NSMutableArray array];
        self.randGoods = [NSMutableArray array];
    }
    return self;
}

- (void)fetchData {
    NSError*error;
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"index"ofType:@"json"];
    NSData *json = [[NSData alloc]initWithContentsOfFile:filePath];
    NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:json options:(NSJSONReadingOptions) kNilOptions error:&error];
    jsonObject = jsonObject[@"data"];
    [self.ads addObjectsFromArray:jsonObject[@"ads"]];
    [self.category addObjectsFromArray: jsonObject[@"category"]];
    [self.activity addObjectsFromArray:jsonObject[@"activity"]];
    [self.hotGoods addObjectsFromArray:jsonObject[@"hot_goods"]];
    [self.randGoods addObjectsFromArray: jsonObject[@"rand_goods"]];

    if(self.dataUpdate) {
        self.dataUpdate();
    }
}
@end
