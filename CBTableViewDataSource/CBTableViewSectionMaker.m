//
// Created by Cocbin on 16/6/12.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import "CBTableViewSectionMaker.h"
#import "CBDataSourceSection.h"


#pragma mark -- Class CBDataSourceSectionMaker

@implementation CBTableViewSectionMaker

- (CBTableViewSectionMaker * (^)(Class))cell {
    return ^CBTableViewSectionMaker *(Class cell) {
        self.section.cell = cell;
        if (! self.section.identifier) {
            self.section.identifier = [self getIdentifier];
        }
        return self;
    };
}

- (CBTableViewSectionMaker * (^)(NSArray *))data {
    return ^CBTableViewSectionMaker *(NSArray * data) {
        self.section.data = data;
        return self;
    };
}

- (CBTableViewSectionMaker * (^)(AdapterBlock))adapter {
    return ^CBTableViewSectionMaker *(AdapterBlock adapterBlock) {
        self.section.adapter = adapterBlock;
        return self;
    };
}

- (CBTableViewSectionMaker * (^)(CGFloat))height {
    return ^CBTableViewSectionMaker *(CGFloat height) {
        self.section.staticHeight = height;
        return self;
    };
}

- (CBTableViewSectionMaker * (^)())autoHeight {
    return ^CBTableViewSectionMaker * {
        self.section.isAutoHeight = YES;
        return self;
    };
}

- (CBTableViewSectionMaker * (^)(EventBlock))event {
    return ^CBTableViewSectionMaker *(EventBlock event) {
        self.section.event = event;
        return self;
    };
}

- (CBTableViewSectionMaker * (^)(NSString *))headerTitle {
    return ^CBTableViewSectionMaker *(NSString * title) {
        self.section.headerTitle = title;
        return self;
    };
}

- (CBTableViewSectionMaker * (^)(NSString *))footerTitle {
    return ^CBTableViewSectionMaker *(NSString * title) {
        self.section.footerTitle = title;
        return self;
    };
}

- (CBDataSourceSection *)section {
    if (! _section) {
        _section = [CBDataSourceSection new];
    }
    return _section;
}


- (NSString *)getIdentifier {
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStrRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString * retStr = (__bridge NSString *) uuidStrRef;
    CFRelease(uuidStrRef);
    return retStr;
}

- (CBTableViewSectionMaker * (^)(UIView * (^)()))headerView {
    return ^CBTableViewSectionMaker *(UIView * (^view)()) {
        self.section.headerView = view();
        return self;
    };
}

- (CBTableViewSectionMaker * (^)(UIView * (^)()))footerView {
    return ^CBTableViewSectionMaker *(UIView * (^view)()) {
        self.section.footerView = view();
        return self;
    };
}

@end