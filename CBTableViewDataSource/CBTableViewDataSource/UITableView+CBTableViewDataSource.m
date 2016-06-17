//
// Created by Cocbin on 16/6/12.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <objc/runtime.h>
#import <objc/message.h>
#import "UITableView+CBTableViewDataSource.h"
#import "CBBaseTableViewDataSource.h"
#import "CBTableViewDataSourceMaker.h"
#import "CBTableViewSectionMaker.h"
#import "CBDataSourceSection.h"

static NSString * getIdentifier (){
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStrRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString * retStr = (__bridge NSString *) uuidStrRef;
    CFRelease(uuidStrRef);
    return retStr;
}

@implementation UITableView (CBTableViewDataSource)

- (CBBaseTableViewDataSource *)cbTableViewDataSource {
    return objc_getAssociatedObject(self,_cmd);
}

- (void)setCbTableViewDataSource:(CBBaseTableViewDataSource *)cbTableViewDataSource {
    objc_setAssociatedObject(self,@selector(cbTableViewDataSource),cbTableViewDataSource,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)cb_makeDataSource:(void(^)(CBTableViewDataSourceMaker * make))maker {
    CBTableViewDataSourceMaker * make = [[CBTableViewDataSourceMaker alloc] initWithTableView:self];
    maker(make);
    Class DataSourceClass = [CBBaseTableViewDataSource class];
    NSMutableDictionary * delegates = [[NSMutableDictionary alloc] init];
    if(make.commitEditingBlock||make.scrollViewDidScrollBlock) {
        DataSourceClass = objc_allocateClassPair([CBBaseTableViewDataSource class], [getIdentifier() UTF8String],0);
        if(make.commitEditingBlock) {
            class_addMethod(DataSourceClass,NSSelectorFromString(@"tableView:commitEditingStyle:forRowAtIndexPath:"),(IMP)commitEditing,"v@:@@@");
            delegates[@"tableView:commitEditingStyle:forRowAtIndexPath:"] = make.commitEditingBlock;
        }
        if(make.scrollViewDidScrollBlock) {
            class_addMethod(DataSourceClass,NSSelectorFromString(@"scrollViewDidScroll:"),(IMP)scrollViewDidScroll,"v@:@");
            delegates[@"scrollViewDidScroll:"] = make.scrollViewDidScrollBlock;
        }
    }

    if(!self.tableFooterView) {
        self.tableFooterView = [UIView new];
    }

    id<CBBaseTableViewDataSourceProtocol> ds = (id<CBBaseTableViewDataSourceProtocol>) [DataSourceClass  new];
    ds.sections = make.sections;
    ds.delegates = delegates;
    self.cbTableViewDataSource = ds;
    self.dataSource = ds;
    self.delegate = ds;
}

- (void)cb_makeSectionWithData:(NSArray *)data {

    NSMutableDictionary * delegates = [[NSMutableDictionary alloc] init];
    CBTableViewSectionMaker * make = [CBTableViewSectionMaker new];
    make.data(data);
    make.cell([UITableViewCell class]);
    [self registerClass:make.section.cell forCellReuseIdentifier:make.section.identifier];

    make.section.tableViewCellStyle = UITableViewCellStyleDefault;
    for(NSUInteger i = 0;i<data.count;i++) {
        if(data[i][@"detail"]) {
            make.section.tableViewCellStyle = UITableViewCellStyleSubtitle;
            break;
        }
        if(data[i][@"value"]) {
            make.section.tableViewCellStyle = UITableViewCellStyleValue1;
            break;
        }
    }
    id<CBBaseTableViewDataSourceProtocol> ds = (id<CBBaseTableViewDataSourceProtocol>) [CBSampleTableViewDataSource  new];

    if(!self.tableFooterView) {
        self.tableFooterView = [UIView new];
    }

    ds.sections = [@[make.section] mutableCopy];
    ds.delegates = delegates;
    self.cbTableViewDataSource = ds;
    self.dataSource = ds;
    self.delegate = ds;
}

- (void)cb_makeSectionWithData:(NSArray *)data withCellClass:(Class)cellClass {
    [self cb_makeDataSource:^(CBTableViewDataSourceMaker * make) {
        [make makeSection:^(CBTableViewSectionMaker * section) {
            section.data(data);
            section.cell(cellClass);
            section.adapter(^(id cell,NSDictionary * row,NSUInteger index) {
                if([cell respondsToSelector:NSSelectorFromString(@"configure:")]) {
                    objc_msgSend(cell,NSSelectorFromString(@"configure:"),row);
                } else if([cell respondsToSelector:NSSelectorFromString(@"configure:index:")]) {
                    objc_msgSend(cell,NSSelectorFromString(@"configure:index:"),row,index);
                }
            });
            section.autoHeight();
        }];
    }];
}


@end

static void commitEditing(id self, SEL cmd, UITableView *tableView,UITableViewCellEditingStyle editingStyle,NSIndexPath * indexPath)
{
    CBBaseTableViewDataSource * ds = self;
    void(^block)(UITableView *,UITableViewCellEditingStyle ,NSIndexPath * ) = ds.delegates[NSStringFromSelector(cmd)];
    if(block) {
        block(tableView,editingStyle,indexPath);
    }
}

static void scrollViewDidScroll(id self, SEL cmd, UIScrollView * scrollView) {
    CBBaseTableViewDataSource * ds = self;
    void(^block)(UIScrollView *) = ds.delegates[NSStringFromSelector(cmd)];
    if(block) {
        block(scrollView);
    }
};

