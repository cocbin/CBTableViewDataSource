#
#  Be sure to run `pod spec lint CBCategoryView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "CBTableViewDataSource"
  s.version      = "1.1.0"
  s.summary      = "An elegant style of writing for UITableViewDataSource"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
  # CBTableViewDataSource
 ![demo](media/demo.jpg)

 Just one line to create `DataSource` and `Delegate` for `UITableView`.
  [中文文档 (Document in Chinese)](https://github.com/cocbin/CBTableViewDataSource/blob/master/README_ZH.md)

 ## Introduction

 `CBTableViewDataSource` is a lightweight Framework which was used to create `DataSource` and `Delegate` for `UITableView` quickly. It provides a simple API to create logical and easily maintained code.

 The most lazy way to create `DataSource` like this:

 ``` objective-c
 [_tableView cb_makeSectionWithData:self.viewModel.data andCellClass:[CustomCell class]];
 ```

 Of course, you must follow some convention in this way. At the same time, I also provides others flexible way to create `DataSource`.

 Details as document below.

 ## Why use

 We always spend a lot of time and energy to create `DataSource` and `Delegate` for `UITableView` when we develop an App. While those code tend to repetitive and hard maintenance, because them located in each position of each delegate method.  We must found them from corner to corner, and modified them when we maintain program.

 However, `CBTableViewDataSource` changed all this, and provides a simple API to help us create logical and easily maintained code.

 In order to make everyone notice advantages of this framework, let's do a compare.

 Native way below:

 ``` objective-c

 // Native vision

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

 It is cumbersome and hard maintenance in this way.

 While using `CBTableViewDataSource`:

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

 It has been concise and layered. Most important is that it make codes accord with the man's thought better.

 ## Usage
 ### Install

 using `cocoapods`：

 ``` ruby
 pod 'CBTableViewDataSource'
 ```

 ### Import

 ``` objective-c
 #import <CBTableViewDataSource/CBTableViewDataSource.h>
 ```

 ### Create `DataSource` and `Delegate`

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

 ## Example

 ### Just using data

 ``` objective-c
 UITableView tableView = [UITableView new];
 [tableView cb_makeSectionWithData:data];
 ```

 It will use default `UITalbeViewCell` as Cell Class in this way.

 The data must follow convention as follows：

 1. data is a NSArray (NSArray < NSDictionary * >*).
 2. The key of dictionary as follows:
     - `text`                use to set text for `UITableViewCell`'s textLabel
     - `detail`              use to set text for `UITableViewCell`'s detailTextLabel
     - `value`               use to set text for `UITableViewCell`'s detailTextLabel
     - `image`               use to set image for `UITableViewCell`'s imageView
     - `accessoryType`       use to set accessory type for `UITableViewCell`

     `value` and `detail` both be used to set text for `UITableViewCell`'s detailTextLabel. If use `detail` as key, the `detailTextLabel` will show at the bottom of `textLabel`. If use `value` as key, the `detailTextLabel` will show at the right of `textLabel`. Do not use both of them in the same time，and the first appear in array priority.

 For example：

 ``` objective-c
 _data = @[
     @{@"text":@"Following",@"value":@"45"},
     @{@"text":@"Follower",@"value":@"10"},
     @{@"text":@"Star",@"value":@"234"},
     @{@"text":@"Setting",@"accessoryType":@(UITableViewCellAccessoryDisclosureIndicator)},
     @{@"text":@"Share",@"accessoryType":@(UITableViewCellAccessoryDisclosureIndicator)}];
 ```

 UI as follows:

 <img src = "media/IMG_0238.png" width = "375" style="margin:0 auto;"/>

 Check detail on file named `DemoTwoViewController.h` and `DemoTwoViewController.m`.

 ### Using custom cell

 ``` objective-c
 [tableView cb_makeSectionWithData:data andCellClass:[CustomCell class]];
 ```

 `CustomCell` must provides a `Configuer:` method or `Configuer:index:` method to adapt data.

 For example:

 ``` objective-c
 - (void)configure:(NSDictionary *)row index:(NSNumber * )index {
     if (row[@"avatar"]) {
         [self.avatarView setImage:[UIImage imageNamed:row[@"avatar"]]];
     } else {
         [self.avatarView setImage:nil];
     }
     [self.nameLabel setText:row[@"name"]];
     [self.titleLabel setText:row[@"title"]];
     [self.detailLabel setText:row[@"detail"]];
     self.circleView.hidden = row[@"unread"] == nil;

     if([index intValue] &1) {
         self.contentView.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.96 alpha:1.00];
     } else {
         self.contentView.backgroundColor = [UIColor whiteColor];
     }
 }
 ```
 Check detail on file named `CustomCell.h` and `CustomCell.m`

 UI as follows:

 <img src = "media/IMG_0237.png" width = "375" style="margin:0 auto;"/>

 Check detail on file named `DemoOneViewController.h` and `DemoOneViewController.m`.

 ### More flexible setting

 ``` objective-c
 [tableView cb_makeSection:^(CBTableViewSectionMaker * section) {
 	section.data(@[]);
 	section.cell([CustomCell class]);
 	section.adapter(^(CustomCell cell,id row,NSUInteger index) {
 		cell.configure(row);
 	});
 	section.event(^() {
 		// do something
 	})
 	// other setting
 }];
 ```

 Here show the case of single section.

 #### CBTableViewSectionMaker

 `CBTableViewSectionMaker` was used to setting some attribute for section.
 Available attribute as follows :

 ##### data

 Setting the data be used show in `UITableView`,argument was required a NSArray.

 For example:

 ``` objective-c
 section.data(@[@(goods1),@(goods2),...]);
 ```

 ##### cell

 Setting the `Cell Class` which was used to show data.
 The identifier of cell will be register automatically.

 For example:

 ``` objective-c
 section.cell([CustomCell class]);
 ```

 ##### adapter

 Was used to adapt cell and date.

 For example:

 ``` objection-c
 section.adapter(^(CustomCell * cell,id row,NSUInteger index) {
     [cell configure:row];
     // ...
 });
 ```

 ##### event

 Was used to setting event when cell be touch, for example:

 ``` objective-c
 section.event(^(NSUInteger index,id row) {
     CustomViewController * controller = [CustomViewController new];
     controller.viewModel.data = row;
     [self.navigationController pushViewController:controller animated:YES];
 });
 ```

 ##### height

 Used to setting height for `cell`. Is required a static value.
 This height just vail for current section.

 ``` objective-c
 section.height(100);
 ```

 ##### autoHeight

 Used to setting dynamic calculate height for cell.

 ``` objective-c
 section.autoHeight();
 ```

 If has setting `autoHeight`,the `height` will be invalid.

 ##### headerTitle;

 Used to setting header title for section. For example:

 ``` objective-c
 section.headerTitle("title");
 ```

 ##### footerTitle;

 Used to setting footer title for section. ditto.

 ##### headerView;

 Used to setting header view for section. For example

 ``` objective-c
 section.headerView(^(){
     UIView * headerView = [UIView alloc]initWithFrame:CGRectMake(0,0,320,40);
     // ...
     return headerView;
 })
 ```

 If has setting `headerView`,`headerTitle` will be invalid.

 ##### footerView;

 Used to setting footer view for section. ditto.

 ###  Multiple Section

 ``` objective-c
 [tableView cb_makeDataSource:^(CBTableViewDataSourceMaker * make) {
 	[make headerView:^{
 		return [HeaderView new];
 	}];
 	[make makeSection: ^(CBTableViewSectionMaker * section) {
 		section.data(@[]);
 		section.cell();
 		section.adapter();
 		section.event();
 		// ... so on
 	}];
 	[make makeSection: ^(CBTableViewSectionMaker * section) {
 		section.data(@[]);
 		section.cell();
 		section.adapter();
 		section.event();
 		// ... so on
 	}];
 	[make makeSection: ^(CBTableViewSectionMaker * section) {
 		section.data(@[]);
 		section.cell();
 		section.adapter();
 		section.event();
 		// ... so on
 	}];
 	// .. so on
 	[make footView:^{
 		return [FooterView new];
 	}];
 }]
 ```

 UI as follows:


 <img src = "media/IMG_0239.png" width = "375" style="margin:0 auto;"/>

 <img src = "media/IMG_0240.png" width = "375" style="margin:0 auto;"/>

 Check detail on file named `DemoThreeViewController.h` and `DemoThreeViewController.m`.

 #### CBTableViewDataSourceMaker
 `CBTableViewDataSourceMaker` was used to setting some attribute for `UITableView`.
 Available attribute as follows :

 ##### makeSection
 Used to add a section for `UITableView`.For example:

 ``` objective-c
 [tableView cb_makeDataSource:^(CBTableViewDataSourceMaker * make) {
 	[make makeSection: ^(CBTableViewSectionMaker * section) {
 	   // ...
 	}
 }]
 ```

 ##### height
 Used to setting default height for `UITableView`

 ``` objective-c
 make.height(100);
 ```

 If you had setting `height` or `autoHeight` for section, the `height` of here will invalid. Default is 40.

 ##### headerView
 Used to setting tableHeaderView for `UITableView`.Notice the difference between `tableHeaderView` and section‘s `headerView`.

 For example:

 ``` objective-c
 make.headerView(^(){
     UIView * headerView = [[UIView alloc]init];
     // ...
     return headerView;
 });
 ```

 ##### footerView
 Used to setting tableFooterView for `UITableView`. ditto.

 ##### commitEditing
 Used to setting `commitEditing` method for `UITableViewDelegate`.

 ``` objective-c
  [make commitEditing:^(UITableView * tableView, UITableViewCellEditingStyle * editingStyle, NSIndexPath * indexPath) {
     // do somethings.
 }];
 ```

 ##### scrollViewDidScroll
 Used to setting `scrollViewDidScroll` method for `UITableViewDelegate`

 ````objective-c
 [make scrollViewDidScroll:^(UIScrollView * scrollView) {
     // do somethings
 }];
 ````

 ## Thinks

 Thank you for using and supporting. Welcome to issue and pull request. I will deal  with at first time.

 I refer to many masters in this framework. For example, I refer to famous `autolayout` framework `Masonary` when I design API. The way to dynamic calculate cell height is refer to `@forkingdog`'s `UITableView-FDTemplateLayoutCell`.

 Thinks them for bring inspiration to me.

 Contact me by email :460469837@qq.com

                   DESC

  s.homepage     = "https://github.com/cocbin/CBTableViewDataSource"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "Cocbin" => "460469837@qq.com" }
  # Or just: s.author    = "Cocbin"
  # s.authors            = { "Cocbin" => "460469837@qq.com" }
  # s.social_media_url   = "http://twitter.com/Cocbin"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # s.platform     = :ios
  s.platform     = :ios, "8.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/cocbin/CBTableViewDataSource.git", :tag => "1.1.0" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = "CBTableViewDataSource/*.{h,m}"
  # s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
