//
// Created by Cocbin on 16/6/12.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import "CBTableViewDataSourceMaker.h"
#import "CBTableViewSectionMaker.h"
#import "CBDataSourceSection.h"

#pragma mark -- Class CBTableViewDataSourceMaker

@implementation CBTableViewDataSourceMaker

- (instancetype)initWithTableView:(UITableView *)tableView {
    self = [super init];
    if (self) {
        self.tableView = tableView;
    }
    return self;
}

- (CBTableViewDataSourceMaker * (^)(UIView * (^)()))headerView {
    return ^CBTableViewDataSourceMaker *(UIView * (^view)()) {
        UIView * headerView =  view();
        [self.tableView.tableHeaderView layoutIfNeeded];
        self.tableView.tableHeaderView = headerView;
        return self;
    };
}

- (CBTableViewDataSourceMaker * (^)(UIView * (^)()))footerView {
    return ^CBTableViewDataSourceMaker *(UIView * (^view)()) {
        UIView * footerView = view();
        [self.tableView.tableFooterView layoutIfNeeded];
        self.tableView.tableFooterView = footerView;
        return self;
    };
}

- (CBTableViewDataSourceMaker * (^)(CGFloat))height {
    return ^CBTableViewDataSourceMaker *(CGFloat height) {
        self.tableView.rowHeight = height;
        return self;
    };
}

- (void)commitEditing:(void (^)(UITableView * tableView,UITableViewCellEditingStyle * editingStyle, NSIndexPath * indexPath))block {
    self.commitEditingBlock = block;
}

- (void)scrollViewDidScroll:(void (^)(UIScrollView * scrollView))block {
    self.scrollViewDidScrollBlock = block;
}


- (void)makeSection:(void (^)(CBTableViewSectionMaker * section))block {
    CBTableViewSectionMaker * sectionMaker = [CBTableViewSectionMaker new];
    block(sectionMaker);
    if (sectionMaker.section.cell) {
        [self.tableView registerClass:sectionMaker.section.cell forCellReuseIdentifier:sectionMaker.section.identifier];
    }
    [self.sections addObject:sectionMaker.section];
}

- (NSMutableArray *)sections {
    if (! _sections) {
        _sections = [NSMutableArray new];
    }
    return _sections;
}

@end