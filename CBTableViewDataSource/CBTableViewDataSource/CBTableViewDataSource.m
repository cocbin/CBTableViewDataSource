//
// Created by Cocbin on 16/6/3.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <objc/runtime.h>
#import "CBTableViewDataSource.h"

@implementation CBTableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger beginOfSection = [self.dataBeginOfSection[(NSUInteger) section] unsignedIntValue];
    NSInteger  count = ((NSArray *)self.dataList[beginOfSection]).count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = (NSUInteger) indexPath.section;
    NSUInteger index = (NSUInteger) indexPath.row;
    id cell = [tableView dequeueReusableCellWithIdentifier:self.identifierOfSection[section] forIndexPath:indexPath];
    AdaptBlock adaptBlock = self.adapterList[section];
    //NSLog(@"adaptBlock %@", [adaptBlock isEqual:nil]);
    if([adaptBlock isEqual:  [NSNull null]]) {
#if DEBUG
        NSLog(@"Warning : adapter block for section %ld is null. please use dataSourceMake.adapter(^block) set it", (long) section);
#endif
        return cell;
    }
    NSUInteger beginOfSection = [self.dataBeginOfSection[section] unsignedIntValue];
    id data = self.dataList[beginOfSection][index];


    if([data isKindOfClass:[NSDictionary class]]) {
        NSUInteger countOfSection = [self.dataCountOfSection[section] unsignedIntValue];
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:self.dataList[beginOfSection][index]];
        if(countOfSection > 1) {
            NSInteger i = 1;
            while(countOfSection != 0) {
                [dic addEntriesFromDictionary:self.dataList[beginOfSection+i][index]];
                countOfSection --;
            }
        }
        cell =  adaptBlock(cell,dic,index);
    } else {
        cell =  adaptBlock(cell,data,index);
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.title[@(section)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = (NSUInteger) indexPath.section;
    NSUInteger index = (NSUInteger) indexPath.row;
    NSString * identifier = _identifierOfSection[section];
    if([self.needAutoHeightList[section] boolValue]) {
        NSUInteger beginOfSection = [self.dataBeginOfSection[section] unsignedIntValue];
        AdaptBlock adaptBlock = self.adapterList[section];
        id data = self.dataList[beginOfSection][index];

        NSNumber * numHeight = objc_getAssociatedObject(data, NSSelectorFromString(identifier));

        if(!numHeight) {
            UITableViewCell * cell = [self cellForReuseIdentifier:identifier withTableView:tableView];
            [cell prepareForReuse];

            if(![adaptBlock isEqual:[NSNull null]]) {
                if([data isKindOfClass:[NSDictionary class]]) {
                    NSUInteger countOfSection = [self.dataCountOfSection[section] unsignedIntValue];
                    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:self.dataList[beginOfSection][index]];
                    if(countOfSection > 1) {
                        NSInteger i = 1;
                        while(countOfSection != 0) {
                            [dic addEntriesFromDictionary:self.dataList[beginOfSection+i][index]];
                            countOfSection --;
                        }
                    }
                    adaptBlock(cell,dic,index);
                } else {
                    adaptBlock(cell,data,index);
                }
            }

            CGFloat height = [self systemFittingHeightForConfiguratedCell:cell withTalbView:tableView];

            objc_setAssociatedObject(data,NSSelectorFromString(identifier),@(height),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            return height;
        } else {
            return [numHeight floatValue];
        }
    } else if([self.staticHeightList[section] floatValue]>0){
        return [self.staticHeightList[section] floatValue];
    } else {
        return tableView.rowHeight;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = (NSUInteger) indexPath.section;
    EventBlock event= self.eventList[section];

    if([event isEqual:[NSNull null]]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return ;
    }

    NSUInteger index = (NSUInteger) indexPath.row;
    NSUInteger beginOfSection = [self.dataBeginOfSection[section] unsignedIntValue];
    id data = self.dataList[beginOfSection][index];

    if([data isKindOfClass:[NSDictionary class]]) {
        NSUInteger countOfSection = [self.dataCountOfSection[section] unsignedIntValue];
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:self.dataList[beginOfSection][index]];
        if(countOfSection > 1) {
            NSInteger i = 1;
            while(countOfSection != 0) {
                [dic addEntriesFromDictionary:self.dataList[beginOfSection+i][index]];
                countOfSection --;
            }
        }
        event(index,dic);
    } else {
        event(index,data);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(self.didScroll) {
        self.didScroll(scrollView);
    }
}

- (__kindof UITableViewCell *)cellForReuseIdentifier:(NSString *)identifier withTableView:(UITableView*)tableView{
    NSAssert(identifier.length > 0, @"Expect a valid identifier - %@", identifier);

    NSMutableDictionary<NSString *, UITableViewCell *> *templateCellsByIdentifiers = objc_getAssociatedObject(self, _cmd);
    if (!templateCellsByIdentifiers) {
        templateCellsByIdentifiers = @{}.mutableCopy;
        objc_setAssociatedObject(self, _cmd, templateCellsByIdentifiers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    UITableViewCell *templateCell = templateCellsByIdentifiers[identifier];

    if (!templateCell) {
        templateCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        NSAssert(templateCell != nil, @"Cell must be registered to table view for identifier - %@", identifier);
        templateCell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        templateCellsByIdentifiers[identifier] = templateCell;
    }

    return templateCell;
}

- (CGFloat)systemFittingHeightForConfiguratedCell:(UITableViewCell *)cell withTalbView:(UITableView*)tableView {

    CGFloat contentViewWidth = CGRectGetWidth(tableView.frame);

    if (cell.accessoryView) {
        contentViewWidth -= 16 + CGRectGetWidth(cell.accessoryView.frame);
    } else {
        static const CGFloat systemAccessoryWidths[5] = {
                [UITableViewCellAccessoryNone] = 0,
                [UITableViewCellAccessoryDisclosureIndicator] = 34,
                [UITableViewCellAccessoryDetailDisclosureButton] = 68,
                [UITableViewCellAccessoryCheckmark] = 40,
                [UITableViewCellAccessoryDetailButton] = 48
        };
        contentViewWidth -= systemAccessoryWidths[cell.accessoryType];
    }

    CGFloat fittingHeight = 0;

    if (contentViewWidth > 0) {
        NSLayoutConstraint *widthFenceConstraint =
                [NSLayoutConstraint
                        constraintWithItem:cell.contentView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:contentViewWidth];
        [cell.contentView addConstraint:widthFenceConstraint];

        fittingHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        [cell.contentView removeConstraint:widthFenceConstraint];
    }

    if (fittingHeight == 0) {
#if DEBUG
        if (cell.contentView.constraints.count > 0) {
            if (!objc_getAssociatedObject(self, _cmd)) {
                NSLog(@"Warning: Cannot get a proper cell height (now 0) from '- systemFittingSize:'(AutoLayout). You should check how constraints are built in cell, making it into 'self-sizing' cell.");
                objc_setAssociatedObject(self, _cmd, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
#endif
    }

    if (fittingHeight == 0) {
        fittingHeight = 44;
    }

    if (tableView.separatorStyle != UITableViewCellSeparatorStyleNone) {
        fittingHeight += 1.0 / [UIScreen mainScreen].scale;
    }

    return fittingHeight;
}


@end