# CBTableViewDataSource
### 更优雅的书写TableView的`delegate`和`dataSource`

### 简介
CBTableViewDataSource是一个为了简化UITableView的`dataSource`和`delegate`协议重写而产生的框架，使用这个框架，可以快速而有条理的书写`dataSource`和`delegate`，从而使代码的可读性大大提高，减轻了UIViewController的代码负担。


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
使用CBTableViewDataSource，你不需要：

1. 你不需要为每个`cell`类定义一个`identifier`。
2. 你不需要为每个`cell`注册`identifier`。
3. 你不需要使用宏或枚举值标记不同的`section`。
4. 你不需要实现复杂的`delegate`和`dataSource`协议。
5. 你不需要写一些重复性很强的代码。

使用CBTableViewDataSource，你需要：

1. 使用`cell()`方法设置`section`的`cell`类。
2. 使用`data()`方法设置`section`的数据。
3. 使用`adapter()`方法设置section的适配器，用于适配单个cell和单个data。

使用CBTableViewDataSource，你还可以：

1. 可以使用`headerTitle()`方法，为单个`section`设置`section header`的标题
2. 可以使用`footerTitle()`方法，为单个`section`设置`section footer`的标题
3. 可以使用`height()`方法，为单个`section`设置固定的高度
4. 可以使用`autoHeight()`方法为当个`section`设置自动动态计算高度
5. 可以使用`event()`方法为单个`section`中的`row`设置触摸事件

### DEMO
为此我制作了两个DEMO用于展示该框架的用法
#### **First**
展示了复杂多section页面时的用法，通过一个仿各种市面上流行的APP的首页，体现了该框架书写dataSource条理清晰，逻辑顺序和页面呈现的顺序完全一致的优点。

 <img src="media/IMG_0220.png" width = "400" alt="demo" align=center />
 
  <img src="media/IMG_0221.png" width = "400" alt="demo" align=center />



#### **second**
通过一个Feed页面，展示了autoHeight的用法。只要调用`autoHeight`函数，一句话解决cell高度计算问题。

<img src="media/IMG_0222.png" width = "400" alt="demo" align=center />



### 用法

#### Install

框架一共包括以下文件

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

可以直接通过Pod下载使用

```
pod 'CBTableViewDataSource'
```

或者直接将上述四个文件复制到你的项目中即可使用。

#### Import

``` objective-c
#import <CBTableViewDataSource/CBTableViewDataSource.h>
```

#### 为TableView设置dataSource

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
### CBTableViewDataSourceMaker对象

CBTableViewDataSourceMaker对象用于创建dataSource，其上的方法是针对整个dataSource来说的。可是使用UITableView对象的`cb_makeDataSource`方法创建，如下：

``` objective-c
[_tableView cb_makeDataSource:^(CBTableViewDataSourceMaker * make) {
    // ... do somethings
}];
```
#### headerView(UIView*(^ )())
设置tableHeaderView
参数是一个Block，要求返回一个UIView。

#### footerView(UIView*(^ )())
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

#### height（CGFloat height）
设置整个tableView所有row的公共高度，当section未设置固定高度或未设置动态计算高度时，则会自动使用该高度

#### - (void)commitEditing:(void (^ )(UITableView * tableView,UITableViewCellEditingStyle * editingStyle, NSIndexPath * indexPath))block
设置编辑状态，当设置了这个block之后，侧滑`row`可以出现删除按钮，可也在该block对其设置点击事件。

#### - (void)scrollViewDidScroll:(void (^ )(UIScrollView * scrollView))block 
设置滚动代理，当tableView滚动时，会自动调用该方法。

#### - (void)makeSection:(void (^ )(CBTableViewSectionMaker * section))block 
使用block创建一个section。

### CBTableViewSectionMaker对象
CBTableViewSectionMaker对象可以针对当个section进行设置，可以使用CBTableViewDataSourceMaker对象的makeSection方法创建

``` objective-c
[make makeSection:^(CBTableViewSectionMaker *section) {
    // ... do somethings
}];
```

#### cell(Class cell)
传入一个cell的class，如`[UITableViewCell class]`。
表示当前section都使用这个cell，注意，cell不需要注册，框架会自动注册并绑定identifier

#### data(NSArray * data)
传入一个数组，表示用于呈现在界面上的数据

#### adapter(^ (id cell,id data,NSUInteger index))
适配器,使用该方法将数据和cell绑定起来。
参数是一个block，该block会传来一个cell对象，一个data对象，一个index。
可以直接在block上对参数类型进行强制转换。
如：

``` objective-c
adapter(^(id * cell,id * data,NSUInterger index){
    cell.data = data;
})
```


#### height(CGFloat * height)
单独为每个section设置一个固定的高度。

- 当使用了autoHeight之后，该设置失效


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


#### event(^ (NSUInteger index,id data))
参数要求一个Block，用于设置cell的点击事件，index表示点击了当前section的index位置，data表示当前点击位置的数据。


#### headerTitle(NSString* title)
用于设置每个section的Section Header显示的标题。

#### footerTitle(NSString* title)
用于设置每个section的Section Footer显示的标题。

