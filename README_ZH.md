# CBTableViewDataSource
### 更优雅的书写TableView的`delegate`和`dataSource`

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


