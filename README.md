# English
# iOS development - the mystical magic DataSource，help you to use TableView in an elegant way.

### If there is any mistake in this translation,please contact with me.
### Introduction

Recently，I am tring to restruct my code，and find out that every viewController includes a long gross code to define `dataSource` and `delegate`.As a result，I create CBTableViewDataSource when I was thinking how to write `dataSource` in an elegant way.


**Before using CBTableViewDataSource**

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

**After using CBTableViewDataSource**

``` objective-c
CBTableViewDataSource * dataSource = CBDataSource(self.tableView)
     .section()
     .cell([OneCell class])
     .data(self.viewModel.oneData)
     .adapter(^UITableViewCell *(OneCell * cell,NSDictionary * data,NSUInteger index){

         //bind data form data to cell

         return cell;
     })

     .section()
     .cell([TwoCell class])
     .data(self.viewModel.twoData)
     .adapter(^UITableViewCell *(TwoCell * cell,NSDictionary * data,NSUInteger index){

         //bind data form data to cell

         return cell;
     })
     // ...
     .make();

```
CBTableViewDataSource allows us to define dataSouce in functional programming，logical sequences and pages are order consistent.Each section starts with section(),behind section(),can make some configures to section。But must set up cell,data,adapter for each section.'cell' is the cell class which section is using,'data' is the data of section,and adapter binds your data with the cell.At the same time,it will set the cell height of the section,or use an auto height calculation.What's more,you can also set the title,or the click(touch?) event of the cell and so on.

CBTableViewDataSource mainly solves servel problems：

1.Avoid to use all kinds of strange macro definition.The cell class and the identifier will be registed automatically.
2.A perfect solution to solve the problems of different height of calls,provides an interface to calculate the height of  cell automatically.
3.An elegent API for dataSource development.

### DEMO
DEMO includes two pages，**First**Show multiple complex section usages in a page.The APP modeled a famous APP in China,mainly showed that the advantage of the framework when use to develop dataSource.


![IMG_0220](media/14650905664965/IMG_0220.png)![IMG_0221](media/14650905664965/IMG_0221.png)


**second**This page use a Feed page to show the usage of autoHeight.Just need to use function `autoHeight` and the calculation of the height of the cell will be solve.

![IMG_0222](media/14650905664965/IMG_0222.png)


### Usage

#### Install

The framework includes four files at all.

```
CBDataSourceMaker.h
CBDataSourceMaker.m

CBTableViewDataSource.h
CBTableViewDataSource.m
```

Download and use files from Pod directly


```
pod 'CBTableViewDataSource', '~> 1.0.0'
```
Or copy four files above into your project directly.

#### Import

``` objective-c
#import <CBTableViewDataSource/CBTableViewDataSource.h>
```

####  Declaration

``` objective-c
@property(nonatomic, retain) CBTableViewDataSource *  dataSource;
```
#### Initialization

``` objective-c
_dataSource = CBDataSource(self.tableView).section()
      .title(@"section one")
      .cell([TestCell class])
      .data(array)
      .adapter(^(TestCell * cell,NSDictionary * dic,NSUInteger index){
          cell.content.text = dic[@"content"];
          return cell;
      })
      .make()
```

**！！！ Waring！！！**
Do not reassign dataSource directly.

``` objective-c
//BAD
self.tableView.dataSource = CBDataSource(self.tableView)
    .section()
    .cell(...)
    .data(...)
    .adapter(...)
    .make()
```
Because dataSource in UITableView is a weak typing,it will be freed without any strong reference after assigned。

### API

#### CBDataSource(UITableView * tableView)
Build a `CBDataSourceMaker` object，use it  to create `CBTableViewDataSource`,assign a `tableView` object which need to be binded with `dataSource`.

#### section()
Use to spilt serveral sections，section() is needed to assigned in the beginning of every section.
#### cell(Class cell)
Give a class of cell,suck as `[UITableViewCell class]`.The current section will all use this cell.And you need to know that the framework will regists and binds identifier so the cell needed not to registes.

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

#### headerView(UIView*(`^`)())
Set tableHeaderView.The parament requests a Block，the block should contains an UIView。

#### footerView(UIView*(`^`)())
set tableFooterView.The parament is a Block,the block requests a UIView.
The extra lines will be removed in tableView when the page is empty.
Example：

``` objective-c
footerView(^(){
    //Return an empty View，there is no line when the page without any content or the content is less than one page.
    return [[UIView alloc]init];
})
```

#### height(CGFloat * height)
Set a fixed height for each section separately.
**Two special examples：**
- This function will be unavailable after using autoHeight.
- The height is public for all section if set it before all sections.


#### autoHeight()
In order to calculate the height of the cell automatically,for the situation which the heights of cells are unfixed.
**Warning：**

- If the the height of cell is fixed,please do not user autoHeight.Any dispensable calculation of autoHeight will reduce the performence.Even through that framework has been designed with a perfect cache model,we'd better make good use of any performence.
- This function only available to **autolayout**.

** Must set up right constrains：**

- All cells must be put into cell.contentView,else will be calculated wrongly
- SET UP RIGHT COMPLETE CONSTRAINS!!!

**Make sure that a constrain should inclues two principles.**

1.Any independent widget inside the cell should has a certain positon and a certain size。Such as the upper left corner is fixed on the upper left corner of the cell,set size with height and width，or set lower right corner to calculate the size when the positions of widgets are able to assign.
What' more,the widget includes UILabel and UIImageView,just need to assign the size of one direction,another direction will be calculate automatically.For example, knows the width and the content of label, the height is calculatable.


 2.To the cell itself,the size must be assigned.Size can be calculated by restricting its upper and lower,right and left widgets,these widgets with content should be definited positions and sizes.It is worth mentioning that it is easy to loss the restrain of the bottom.Because no exception will be raised even the cell lose a restrain of the bottom.The necessary conditions for the calculation of the height of the cell are not satisfied.





#### event(`^`(NSUInteger index,id data))
Parament requests a Block，which used to set up the click event of the cell,and 'index' is the index touch positon of the current section,'data' is the data of current click position.

#### title(NSString* title)
Set title for each section.

#### make()
Run after finished setup.







# 中文
# iOS开发之DataSource神奇魔法，优雅的写法让你轻松驾驭TableView

### 简介

最近在重构之前写的代码的时候，发现基本每个viewController里面都有一段又臭又长的代码用于定义tableView的`dataSource`和`delegate`，于是我在想，有没有更优雅的方式来书写`dataSource`，于是乎就产生了CBTableViewDataSource。


**使用CBTableViewDataSource之前**

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

**使用CBTableViewDataSource之后**

``` objective-c
CBTableViewDataSource * dataSource = CBDataSource(self.tableView)
     .section()
     .cell([OneCell class])
     .data(self.viewModel.oneData)
     .adapter(^UITableViewCell *(OneCell * cell,NSDictionary * data,NSUInteger index){

         //bind data form data to cell

         return cell;
     })

     .section()
     .cell([TwoCell class])
     .data(self.viewModel.twoData)
     .adapter(^UITableViewCell *(TwoCell * cell,NSDictionary * data,NSUInteger index){

         //bind data form data to cell

         return cell;
     })
     // ...
     .make();

```
CBTableViewDataSource允许我们以函数式的方式定义dataSouce，逻辑顺序和页面的呈现顺序一致。
每个section以section()开头，在section()之后，可以对该section进行一些配置，要求每个section必须设置cell，data，和adapter。cell表示该section使用的cell类，data表示该section的数据，adapter用于将数据和cell绑定起来。同时还能配置section中cell的高度，或者设置自动计算高度。也可是设置section的标题，cell的点击事件等等。

CBTableViewDataSource主要解决了以下几个问题：

1. 避免了书写各种乱七八糟的宏定义，自动注册cell类，自动设置identifier。
2. 提供了一套完美解决不同高度cell的计算问题，提供自动计算cell高度的接口。
3. 提供一套优雅的api，十分优雅并且有逻辑地书写dataSource。

### DEMO解读
DEMO包括两个页面，**First**展示了复杂多section页面时的用法，通过一个仿各种市面上流行的APP的首页，体现了该框架书写dataSource条理清晰，逻辑顺序和页面呈现的顺序完全一致的优点。


![IMG_0220](media/14650905664965/IMG_0220.png)![IMG_0221](media/14650905664965/IMG_0221.png)


**second**页面通过一个Feed页面，展示了autoHeight的用法。只要调用`autoHeight`函数，一句话解决cell高度计算问题。

![IMG_0222](media/14650905664965/IMG_0222.png)


### 用法

#### Install

框架一共包括四个文件

```
CBDataSourceMaker.h
CBDataSourceMaker.m

CBTableViewDataSource.h
CBTableViewDataSource.m
```

可以直接通过Pod下载使用

```
pod 'CBTableViewDataSource', '~> 1.0.0'
```
或者直接将上述四个文件复制到你的项目中即可使用。

#### Import

``` objective-c
#import <CBTableViewDataSource/CBTableViewDataSource.h>
```

#### 声明

``` objective-c
@property(nonatomic, retain) CBTableViewDataSource *  dataSource;
```
#### 初始化

``` objective-c
_dataSource = CBDataSource(self.tableView).section()
      .title(@"section one")
      .cell([TestCell class])
      .data(array)
      .adapter(^(TestCell * cell,NSDictionary * dic,NSUInteger index){
          cell.content.text = dic[@"content"];
          return cell;
      })
      .make()
```

**！！！注意！！！**
不能直接为dataSource赋值

``` objective-c
//BAD
self.tableView.dataSource = CBDataSource(self.tableView)
    .section()
    .cell(...)
    .data(...)
    .adapter(...)
    .make()
```
因为UITableView的dataSource声明的是weak，赋值完因为没有任何强引用导致它的内存会被直接释放。

### API

#### CBDataSource(UITableView * tableView)
创建一个`CBDataSourceMaker`对象，用于创建`CBTableViewDataSource`,传入一个需要绑定该`dataSource`的`tableView`对象

#### section()
用于分割多个section，每个section的开头到要使用section()声明一个section的开始

#### cell(Class cell)
传入一个cell的class，如`[UITableViewCell class]`。
表示当前section都使用这个cell，注意，cell不需要注册，框架会自动注册并绑定identifier

#### data(NSArray * data)
传入一个数组，表示用于呈现在界面上的数据

#### adapter(`^`(id cell,id data,NSUInteger index))
适配器,使用该方法将数据和cell绑定起来。
参数是一个block，该block会传来一个cell对象，一个data对象，一个index。
可以直接在block上对参数类型进行强制转换。
如：

``` objective-c
adapter(^(GoodsCell * cell,GoodsModel * goods,NSUInterger index){
    cell.goods = goods;
    return cell;
})
```

#### headerView(UIView*(`^`)())
设置tableHeaderView
参数是一个Block，要求返回一个UIView。

#### footerView(UIView*(`^`)())
设置tableFooterView
参数是一个Block，要求返回一个UIView。
常用于取消当页面空白时，tableView呈现多余的下划线。
如：

``` objective-c
footerView(^(){
    //返回一个空白View，这样页面没内容时或者内容不足一页，就不会出现多余的线条。
    return [[UIView alloc]init];
})
```

#### height(CGFloat * height)
单独为每个section设置一个固定的高度。
**有两个特例：**

- 当使用了autoHeight之后，该设置失效
- 当在所有section之前设置height，将为所有section公共的height


#### autoHeight()
自动计算cell高度，用于cell高度不固定的情况。

**注意：**

- 当cell的高度固定时，请不要使用autoHeight，因为autoHeight计算高度会消耗一定性能，尽管该框架已经对高度计算做了非常完美的缓存处理，但是对于高性能的追求一定要做到精益求精。
- 该设置只对**autolayout有效**。

**一定要正确设置好约束：**

- 所有cell里面的组件一定要放在cell.contentView里面，不然会计算错误
- 一定要有完整的约束。

**确定一个约束是否完整有两个原则**

1. 对于cell内部每个独立的控件，都能确定位置和尺寸，比如左上角定在cell的左上角，然后设置高度宽度确定尺寸，或者设置右下角确定尺寸，前提是右下角相对的组件是能确定位置的。另外，UILabel和UIImageView，这种有内容的控件，只需要确定一个方向的尺寸，就会更具内容自动计算出另一个方向的尺寸，比如label知道宽度，和内容，就能算高度。
2. 对于cell本身，必须能确定其尺寸。尺寸会通过约束其上下左右的控件来计算，这些所以约束其下和右的控件必须能确定位置和尺寸。值得说的是，这里很容易遗漏掉底部的约束，因为cell就算没有底部约束，也不会报错，但是不能满足计算出cell高度的必要条件。





#### event(`^`(NSUInteger index,id data))
参数要求一个Block，用于设置cell的点击事件，index表示点击了当前section的index位置，data表示当前点击位置的数据。


#### title(NSString* title)
用于设置每个section的标题。

#### make()
在设置完毕之后执行，表示已经设置完毕了。
