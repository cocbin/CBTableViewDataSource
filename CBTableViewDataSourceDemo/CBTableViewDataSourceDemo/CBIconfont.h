//
// Created by Cocbin on 16/5/29.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

UIButton * IFButtonMake(NSString * identify,UIColor *color,CGFloat size);
UILabel * IFLabelMake(NSString * identify,UIColor *color,CGFloat size);
UIImage * IFImageMake(NSString * identify,UIColor *color,CGFloat size);

@interface CBIconfont : NSObject

typedef NS_ENUM(NSInteger,IFConfigKeys) {
    IFFontPath,
    IFFontName,
    IFFontIdentify
};

+ (CBIconfont *)instance;
- (void)initWithConfig:(NSDictionary * )config;


- (NSString *) iconTextWithIdentify:(NSString *) identify;

- (UIImage * ) imageWithIdentify:(NSString * )identify
                           color:(UIColor*)color
                            size:(CGFloat)size;

- (UIImage * ) imageWithIdentify:(NSString * )identify
                           color:(UIColor*)color
                            size:(CGFloat)size
                  backgroundSize:(CGSize)backgroundSize;

- (UIImage * ) imageWithIdentify:(NSString * )identify
                           color:(UIColor*)color
                 backgroundColor:(UIColor *)bgColor
                        fontSize:(CGFloat)fontSize
                  backgroundSize:(CGSize)backgroundSize;

- (UIButton * )buttonWithIdentify:(NSString *) identify
                            color:(UIColor *)color
                             size:(CGFloat)size;

- (UILabel * )labelWithIdentify:(NSString *)identify
                          color:(UIColor *)color
                           size:(CGFloat)size;

@end
