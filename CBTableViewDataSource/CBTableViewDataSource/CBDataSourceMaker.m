//
// Created by Cocbin on 16/6/3.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import "CBDataSourceMaker.h"
#import "CBTableViewDataSource.h"


@implementation CBDataSourceMaker {
    UITableView * _tableView;
    NSUInteger _currentSection;
    NSUInteger _sectionCount;
    NSMutableArray * _dataList;
    NSMutableArray * _dataCountOfSection;
    NSMutableArray * _dataBeginOfSection;
    NSMutableArray * _identifierOfSection;
    NSMutableArray * _adapterList;

    NSMutableArray * _staticHeightList;
    NSMutableArray * _needAutoHeightList;

    NSMutableArray * _eventList;

    NSMutableDictionary * _titleDictionary;

    void(^_didScrollBlock)(UIScrollView * scrollView);
}

- (CBDataSourceMaker *)initWithUITableView:(UITableView *)tableView {
    self = [super init];
    if (self) {
        _tableView = tableView;

        _dataList = [[NSMutableArray alloc] init];
        _dataCountOfSection = [[NSMutableArray alloc] init];
        _dataBeginOfSection = [[NSMutableArray alloc] init];
        _identifierOfSection = [[NSMutableArray alloc] init];
        _adapterList = [[NSMutableArray alloc] init];

        _needAutoHeightList = [[NSMutableArray alloc] init];
        _staticHeightList = [[NSMutableArray alloc] init];

        _eventList = [[NSMutableArray alloc] init];

        _titleDictionary = [[NSMutableDictionary alloc] init];

        _currentSection = 0;
        _sectionCount = 0;
    }
    return self;
}

- (CBDataSourceMaker * (^)())section {
    return ^CBDataSourceMaker * {

        if (_dataCountOfSection.count > 0) {
            NSInteger begin = [_dataBeginOfSection[_currentSection] integerValue];
            NSInteger count = [_dataCountOfSection[_currentSection] integerValue];
            [_dataBeginOfSection addObject:@(begin + count)];
            _currentSection ++;
            _sectionCount ++;
        } else {
            [_dataBeginOfSection addObject:@0];
            _currentSection = 0;
            _sectionCount ++;
        }
        [_dataCountOfSection addObject:@0];
        [_needAutoHeightList addObject:@(NO)];
        [_staticHeightList addObject:@0];
        [_adapterList addObject:[NSNull null]];
        [_eventList addObject:[NSNull null]];
        return self;
    };
}

- (CBDataSourceMaker * (^)(Class))cell {
    return ^CBDataSourceMaker *(Class c) {
        NSString * identifier = [self getIdentifier];
        [_tableView registerClass:c forCellReuseIdentifier:identifier];
        [_identifierOfSection addObject:identifier];
        return self;
    };
}

- (CBDataSourceMaker * (^)(NSArray *))data {
    return ^CBDataSourceMaker *(NSArray * d) {
        NSInteger nowCount = [_dataCountOfSection[_currentSection] integerValue];
        _dataCountOfSection[_currentSection] = @(nowCount + 1);
        [_dataList addObject:d];
        return self;
    };
}

- (CBDataSourceMaker * (^)(AdaptBlock))adapter {
    return ^CBDataSourceMaker *(AdaptBlock adaptBlock) {
        _adapterList[_currentSection] = adaptBlock;
        return self;
    };
}

- (CBTableViewDataSource * (^)())make {
    return ^CBTableViewDataSource * {
        CBTableViewDataSource * dataSource = [[CBTableViewDataSource alloc] init];
        _tableView.dataSource = dataSource;
        _tableView.delegate = dataSource;
        dataSource.dataList = _dataList;
        dataSource.dataCountOfSection = _dataCountOfSection;
        dataSource.adapterList = _adapterList;
        dataSource.dataBeginOfSection = _dataBeginOfSection;
        dataSource.dataCountOfSection = _dataCountOfSection;
        dataSource.sectionCount = _sectionCount;
        dataSource.identifierOfSection = _identifierOfSection;
        dataSource.staticHeightList = _staticHeightList;
        dataSource.needAutoHeightList = _needAutoHeightList;
        dataSource.eventList = _eventList;
        dataSource.title = _titleDictionary;
        dataSource.didScroll = _didScrollBlock;
        return dataSource;
    };
}


- (CBDataSourceMaker * (^)(UIView * (^)()))headerView {
    return ^CBDataSourceMaker *(UIView * (^view)()) {
        _tableView.tableHeaderView = view();
        return self;
    };
}


- (CBDataSourceMaker * (^)(UIView * (^)()))footerView {
    return ^CBDataSourceMaker *(UIView * (^view)()) {
        _tableView.tableFooterView = view();
        return self;
    };
}

- (CBDataSourceMaker * (^)(CGFloat))height {
    return ^CBDataSourceMaker *(CGFloat height) {
        if (_staticHeightList.count == 0) {
            _tableView.rowHeight = height;
        } else {
            _staticHeightList[_currentSection] = @(height);
        }
        return self;
    };
}

- (CBDataSourceMaker * (^)())autoHeight {
    return ^CBDataSourceMaker * {
        _needAutoHeightList[_currentSection] = @(YES);
        return self;
    };
}

- (CBDataSourceMaker * (^)(EventBlock))event {
    return ^CBDataSourceMaker *(EventBlock pFunction) {
        _eventList[_currentSection] = pFunction;
        return self;
    };
}

- (CBDataSourceMaker * (^)(NSString *))title {
    return ^CBDataSourceMaker *(NSString * string) {
        _titleDictionary[@(_currentSection)] = string;
        return self;
    };
}

- (CBDataSourceMaker * (^)(void(^)(UIScrollView *)))didScroll {
    return ^CBDataSourceMaker *(void (^pFunction)(UIScrollView *)) {
        _didScrollBlock = pFunction;
        return self;
    };
}


- (NSString *)getIdentifier {
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStrRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString * retStr = (__bridge NSString *) uuidStrRef;
    CFRelease(uuidStrRef);
    return retStr;
}

@end

CBDataSourceMaker * CBDataSource(UITableView * tableView) {
    CBDataSourceMaker * make = [[CBDataSourceMaker alloc] initWithUITableView:tableView];
    return make;
}