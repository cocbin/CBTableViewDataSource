# CBTableViewDataSource
### An elegant way to write `DataSource` and `Delegate` for `UITableView`.

#### If there is any mistake in this document, please contact with me.
 [中文文档 (Document in Chinese)](https://github.com/cocbin/CBTableViewDataSource/blob/master/README_ZH.md)
 
### Introduction

Recently,I am trying to restruct my code,and found out that every viewController includes some long gross code to define `dataSource` and `delegate`. As a result,I create CBTableViewDataSource when I was thinking how to rewrite `dataSource` in an elegant way.


**Without using CBTableViewDataSource**

``` objective-c

// define a enum to split section

typedef NS_ENUM(NSInteger, SectionNameDefine) {
    SECTION_ONE,
    SECTION_TWO,
    SECTION_THREE,
    SECTION_FOUR,
    //...
    COUNT_OF_STORE_SECTION
};

// define identifier for section

#define IDENTIFIER_ONE  @"IDENTIFIER_ONE"
#define IDENTIFIER_TWO  @"IDENTIFIER_TWO"
#define IDENTIFIER_THREE  @"IDENTIFIER_THREE"
#define IDENTIFIER_FOUR @"IDENTIFIER_FOUR"
//...


// register cell class for section

[self.tableView registerClass:[OneCell class] forCellWithReuseIdentifier:IDENTIFIER_ONE];
[self.tableView registerClass:[TwoCell class] forCellWithReuseIdentifier:IDENTIFIER_TWO];
[self.tableView registerClass:[ThreeCell class] forCellWithReuseIdentifier:IDENTIFIER_THREE];
[self.tableView registerClass:[FourCell class] forCellWithReuseIdentifier:IDENTIFIER_FOUR];


// implementation datasource protocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return COUNT_OF_STORE_SECTION;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray*)self.data[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = (NSUInteger) indexPath.section;
    NSUInteger index = (NSUInteger) indexPath.row;
    switch(section) {
        case SECTION_ONE:
        // to do something
            return cell;
        case SECTION_TWO:
        // to do something
            return cell;
        case SECTION_THREE:
        // to do something
            return cell;

            //...
    }

    return cell;
}
// ...

```

**Using CBTableViewDataSource**

``` objective-c
[_tableView cb_makeDataSource:^(CBTableViewDataSourceMaker * make) {
    // section one
    [make makeSection:^(CBTableViewSectionMaker *section) {
        section.cell([OneCell class])
            .data(self.viewModel.oneDate)
            .adapter(^(OneCell * cell,id data,NSUInteger index){
                [cell configure:data];
            })
            .autoHeight();
    }];
    // section two
    [make makeSection:^(CBTableViewSectionMaker *section) {
        section.cell([TwoCell class])
            .data(self.viewModel.twoData)
            .adapter(^(FeedCell * cell,id data,NSUInteger index){
                [cell configure:data];
            })
            .autoHeight();
    }];

    // ... so on    
}];

```
CBTableViewDataSource allows us to define `dataSouce` in a functional programming way，logical sequences and pages are order consistent.Each section starts with `section()`,behind `section()`,can make some configures to the section.But we must to set up cell,data,adapter for each section.`cell` is the cell class which section is using,`data` is the data of the section,and `adapter` binds your data with the cell.At the same time,it will set the cell height of the section,or to use an height auto calculation.What's more,you can also set the title,or the touch event of the cell and so on.

CBTableViewDataSource mainly solves servel problems：

1.Avoid to use all kinds of strange macro definition.The cell class and the identifier will be registed automatically.
2.A perfect solution to solve the problems of different height of calls,provides an interface to calculate the height of  cell automatically.
3.An elegent API for dataSource development.

### DEMO
DEMO includes two pages，**First** Show multiple complex section usages in a page.The APP modeled a famous APP in China,mainly showed that the advantage of the framework when it was used to develop dataSource.


 <img src="media/IMG_0220.png" width = "400" alt="demo" align=center />

<img src="media/IMG_0221.png" width = "400" alt="demo" align=center />


**second** This page use a Feed page to show the usage of autoHeight.Just need to use function `autoHeight` and the calculation of the height of the cell will be solved.

<img src="media/IMG_0222.png" width = "400" alt="demo" align=center />


### Usage

#### Install

The framework contains the following files.

```
CBBaseTableViewDataSource.h
CBBaseTableViewDataSource.m
CBDataSourceHelper.h
CBDataSourceHelper.m
CBDataSourceSection.h
CBDataSourceSection.m
CBTableViewDataSource.h
CBTableViewDataSourceMaker.h
CBTableViewDataSourceMaker.m
CBTableViewSectionMaker.h
CBTableViewSectionMaker.m

```

Download and use files from Pod directly


```
pod 'CBTableViewDataSource'
```
Or copy those files above into your project directly.

#### Import

``` objective-c
#import <CBTableViewDataSource/CBTableViewDataSource.h>
```

#### Set DataSource for your TableView

``` objective-c
[_tableView cb_makeDataSource:^(CBTableViewDataSourceMaker * make) {
    // section one
    [make makeSection:^(CBTableViewSectionMaker *section) {
        section.cell([OneCell class])
            .data(self.viewModel.oneDate)
            .adapter(^(OneCell * cell,id data,NSUInteger index){
                [cell configure:data];
            })
            .autoHeight();
    }];
    // section two
    [make makeSection:^(CBTableViewSectionMaker *section) {
        section.cell([TwoCell class])
            .data(self.viewModel.twoData)
            .adapter(^(FeedCell * cell,id data,NSUInteger index){
                [cell configure:data];
            })
            .autoHeight();
    }];

    // ... so on    
}];
```

## API

### CBTableViewDataSourceMaker

CBTableViewDataSourceMaker was used to create dataSource，like this：

``` objective-c
[_tableView cb_makeDataSource:^(CBTableViewDataSourceMaker * make) {
    // ... do somethings
}];
```

#### headerView(UIView*( ^ )())
Set tableHeaderView.The parament requests a Block，the block should contains an UIView。

#### footerView(UIView*( ^ )())
set tableFooterView.The parament is a Block,the block requests a UIView.
The extra lines will be removed in tableView when the page is empty.
Example：

``` objective-c
footerView(^(){
    //Return an empty View，there is no line when the page without any content or the content is less than one page.
    return [[UIView alloc]init];
})
```

#### - (void)commitEditing:(void (^ )(UITableView * tableView,UITableViewCellEditingStyle * editingStyle, NSIndexPath * indexPath))block
 call the method,you can make the cell able to sideslip,and show the delete button.

#### - (void)scrollViewDidScroll:(void (^ )(UIScrollView * scrollView))block 
call the method to listen in the tableView scrolling event.


#### - (void)makeSection:(void (^ )(CBTableViewSectionMaker * section))block 
call the method to make a section.



### CBTableViewSectionMaker

#### CBDataSource(UITableView * tableView)
Build a `CBDataSourceMaker` object，use it to create `CBTableViewDataSource`,assign a `tableView` object which is needed to be binded with `dataSource`.

#### section()
Use to spilt sections，section() is needed to assign in the beginning of every section.
#### cell(Class cell)
Give a class of cell,such as `[UITableViewCell class]`.All current sections willuse the same cell. And you need to know that the framework will regists and binds identifier so the cell needed not to be registed.

#### data(NSArray * data)
Give an array with the data which will be showed in the page.

#### adapter(`^`(id cell,id data,NSUInteger index))
Adapter,use this function to binds data with cell.
Parament is a block,which contains a cell object,a data object and an index.
The block is allowed to be casted.
Example：

``` objective-c
adapter(^(GoodsCell * cell,GoodsModel * goods,NSUInterger index){
    cell.goods = goods;
    return cell;
})
```

#### height(CGFloat * height)
Set a fixed height for each section separately.

- This function will be unavailable after using autoHeight.

#### autoHeight()
This function is to calculate the height of the cell automatically, for the situation which the heights of cells are unfixed.
**Warning：**

- If the height of the cell is fixed,please do not use autoHeight.Any dispensable calculation of autoHeight will reduce the performence.Even through framework has been designed with a perfect cache model,we'd better make good use of any performence.
- This function only available to **autolayout**.

**Must set up right constrains:**

- All cells must be put into cell.contentView, else will be calculated wrongly
- SET UP RIGHT COMPLETE CONSTRAINS!!!

**Make sure that a constrain should inclues two principles.**

1.Any independent widget inside the cell should have a certain positon and a certain size.Such as the upper left corner is fixed on the upper left corner of the cell, set height and width，or set lower right corner to calculate the size when the positions of widgets are able to assign.
What' more,the widget includes UILabel and UIImageView,just need to assign the size of one direction,another direction will be calculate automatically.For example, knows the width and the content of label, the height will be calculatable.


 2.To the cell itself,the size must be assigned.Size can be calculated by restricting its upper and lower,right and left widgets,these widgets with content should be definited positions and sizes.It is worth mentioning that it is easy to loss the restrain of the bottom.Because no exception will be raised even the cell lose a restrain of the bottom.The necessary conditions for the calculation of the height of the cell are not satisfied.



#### event( ^ (NSUInteger index,id data))
Parament requests a Block，which used to set up the click event of the cell,and 'index' is the index touch positon of the current section,'data' is the data of current click position.

#### title(NSString * title)
Set title for each section.

#### make()
Run after finished the setup.


