//
// Created by Cocbin on 16/6/12.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <objc/runtime.h>
#import "UITableView+CBTableViewDataSource.h"
#import "CBBaseTableViewDataSource.h"
#import "CBTableViewDataSourceMaker.h"

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

    id<CBBaseTableViewDataSourceProtocol> ds = (id<CBBaseTableViewDataSourceProtocol>) [DataSourceClass  new];
    ds.sections = make.sections;
    ds.delegates = delegates;
    self.cbTableViewDataSource = ds;
    self.dataSource = ds;
    self.delegate = ds;
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

