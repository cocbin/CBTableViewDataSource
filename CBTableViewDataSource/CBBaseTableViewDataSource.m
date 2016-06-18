//
// Created by Cocbin on 16/6/12.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <objc/runtime.h>
#import "CBBaseTableViewDataSource.h"
#import "CBDataSourceSection.h"

@implementation CBBaseTableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sections[(NSUInteger) section].data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = (NSUInteger) indexPath.section;
    NSUInteger index = (NSUInteger) indexPath.row;
    id cell = [tableView dequeueReusableCellWithIdentifier:self.sections[section].identifier forIndexPath:indexPath];
    AdapterBlock adaptBlock = self.sections[section].adapter;
    //NSLog(@"adaptBlock %@", [adaptBlock isEqual:nil]);
    if(!adaptBlock) {
#if DEBUG
        NSLog(@"Warning : adapter block for section %ld is null. please use dataSourceMake.adapter(^block) set it", (long) section);
#endif
        return cell;
    }
    id data = self.sections[section].data[index];
    adaptBlock(cell,data,index);
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sections[(NSUInteger) section].headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return self.sections[(NSUInteger) section].footerTitle;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.sections[(NSUInteger) section].headerView;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.sections[(NSUInteger) section].footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(self.sections[(NSUInteger) section].headerView) {
        return self.sections[(NSUInteger) section].headerView.frame.size.height;
    } else if(self.sections[(NSUInteger) section].headerTitle) {
        return 40;
    } else {
        return 0;
    };
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(self.sections[(NSUInteger) section].footerView) {
        return self.sections[(NSUInteger) section].footerView.frame.size.height;
    } else if(self.sections[(NSUInteger) section].footerTitle) {
        return 40;
    } else {
        return 0;
    };
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = (NSUInteger) indexPath.section;
    NSUInteger index = (NSUInteger) indexPath.row;
    NSString * identifier = self.sections[section].identifier;
    if(self.sections[section].isAutoHeight) {
        AdapterBlock adapterBlock = self.sections[section].adapter;
        id data = self.sections[section].data[index];

        NSNumber * numHeight = objc_getAssociatedObject(data, NSSelectorFromString(identifier));

        if(!numHeight) {
            UITableViewCell * cell = [self cellForReuseIdentifier:identifier withTableView:tableView];
            [cell prepareForReuse];

            if(![adapterBlock isEqual:[NSNull null]]) {
                adapterBlock(cell,data,index);
            }
            CGFloat height = [self systemFittingHeightForConfiguratedCell:cell withTalbView:tableView];
            objc_setAssociatedObject(data,NSSelectorFromString(identifier),@(height),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            return height;
        } else {
            return [numHeight floatValue];
        }
    } else if(self.sections[section].staticHeight >0){
        return self.sections[section].staticHeight;
    } else {
        return tableView.rowHeight;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = (NSUInteger) indexPath.section;
    EventBlock event= (EventBlock) self.sections[section].event;

    if(!event) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return ;
    }

    NSUInteger index = (NSUInteger) indexPath.row;
    id data = self.sections[section].data[index];
    event(index,data);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (NSMutableArray<CBDataSourceSection *> *)sections {
    return objc_getAssociatedObject(self,_cmd);
}

- (void)setSections:(NSMutableArray<CBDataSourceSection *> *)sections {
    objc_setAssociatedObject(self,@selector(sections),sections,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary * )delegates {
    return objc_getAssociatedObject(self,_cmd);
}

- (void)setDelegates:(NSMutableDictionary *)delegates {
    objc_setAssociatedObject(self,@selector(delegates),delegates,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation CBSampleTableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = (NSUInteger) indexPath.section;
    NSUInteger index = (NSUInteger) indexPath.row;


    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:self.sections[section].identifier];
    if(cell) {
        cell = [[UITableViewCell alloc] initWithStyle:self.sections[section].tableViewCellStyle reuseIdentifier:self.sections[section].identifier];
    }

    NSDictionary * row = self.sections[section].data[index];
    cell.textLabel.text = row[@"text"];
    if(row[@"detail"]) {
        cell.detailTextLabel.text = row[@"detail"];
    }
    if(row[@"value"]) {
        cell.detailTextLabel.text = row[@"value"];
    }
    if(row[@"image"]) {
        [cell.imageView setImage:[UIImage imageNamed:row[@"image"]]];
    }
    if(row[@"accessoryType"]) {
        cell.accessoryType = (UITableViewCellAccessoryType) [row[@"accessoryType"] integerValue];
    }


    return cell;
}

@end