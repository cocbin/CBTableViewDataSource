//
// Created by Cocbin on 16/5/29.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import "CBIconfont.h"

@implementation CBIconfont {
    NSString * _fontPath;
    NSString * _fontName;
    NSDictionary * _fontIdentify;
}

+ (CBIconfont *)instance {
    static CBIconfont * _instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}


- (void)initWithConfig:(NSDictionary * )config {
    NSAssert(config[@(IFFontPath)]!=nil,@"IFFontPath not found");
    _fontPath = config[@(IFFontPath)];
    if(config[@(IFFontName)]) {
        _fontName = config[@(IFFontName)];
    } else {
        NSRange range = [_fontPath rangeOfString:@"."];
        _fontName = [_fontPath substringToIndex:range.location];
    };
    if(config[@(IFFontIdentify)]) {
        _fontIdentify = config[@(IFFontIdentify)];
    }
    [self registerFontWithURL:[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:_fontPath]];
}

- (BOOL)registerFontWithURL:(NSURL *)fontFileURL {
    NSError *err = nil;

    if (fontFileURL.isFileURL && [[NSFileManager defaultManager] fileExistsAtPath:fontFileURL.path]) {
        CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontFileURL);
        CGFontRef font = CGFontCreateWithDataProvider(fontDataProvider);
        CGDataProviderRelease(fontDataProvider);
        CFErrorRef registerError = NULL;
        CTFontManagerRegisterGraphicsFont(font, &registerError);
        CGFontRelease(font);
        err = (__bridge NSError *)registerError;
    } else {
        err = [NSError errorWithDomain:@"IconFontKitErrorDomain"
                                  code:-1
                              userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"fontFileURL(%@) does not exist.", fontFileURL]}];
    }
    return !err;
}

- (UIFont *) fontWithSize:(CGFloat)size {
    return [UIFont fontWithName:_fontName size:size];
}

- (NSString *) iconTextWithIdentify:(NSString *) identify {
    return _fontIdentify[identify];
}

- (UIImage * ) imageWithIdentify:(NSString * )identify
                           color:(UIColor*)color
                 size:(CGFloat)size {
    return [self imageWithIdentify:identify
                             color:color
                   backgroundColor:[UIColor clearColor]
                          fontSize:size
                    backgroundSize:CGSizeMake(size,size)];
}

- (UIImage * ) imageWithIdentify:(NSString * )identify
                           color:(UIColor*)color
                            size:(CGFloat)size
                  backgroundSize:(CGSize)backgroundSize {
    return [self imageWithIdentify:identify
                             color:color
                   backgroundColor:[UIColor clearColor]
                          fontSize:size
                    backgroundSize:backgroundSize];
}

- (UIImage * ) imageWithIdentify:(NSString * )identify
                           color:(UIColor*)color
                 backgroundColor:(UIColor *)bgColor
                        fontSize:(CGFloat)fontSize
                  backgroundSize:(CGSize)backgroundSize {
    UIGraphicsBeginImageContextWithOptions(backgroundSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //background
    [bgColor setFill];
    CGContextFillRect(context, CGRectMake(0, 0, backgroundSize.width, backgroundSize.height));

    //text
    CGFloat x = (backgroundSize.width - fontSize)/2;
    CGFloat y = (backgroundSize.height - fontSize)/2;
    if(x<0) {
        x = 0;
    }
    if(y<0) {
        y = 0;
    }
    [_fontIdentify[identify] drawAtPoint:CGPointMake(x,y) withAttributes:
            @{
                    NSFontAttributeName: [self fontWithSize:fontSize],
                    NSForegroundColorAttributeName:color
            }];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIButton * )buttonWithIdentify:(NSString *) identify
                            color:(UIColor *)color
                             size:(CGFloat)size {
    UIButton * btn = [[UIButton alloc] init];
    btn.titleLabel.font = [UIFont fontWithName:_fontName size:size];
    [btn setTitle:_fontIdentify[identify] forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    return btn;
}

- (UILabel * )labelWithIdentify:(NSString *)identify
                          color:(UIColor *)color
                           size:(CGFloat)size {
    UILabel * label = [[UILabel alloc] init];
    label.font =  [UIFont fontWithName:_fontName size:size];
    label.text = _fontIdentify[identify];
    label.textColor = color;
    return label;
}

@end

UIButton * IFButtonMake(NSString * identify,UIColor *color,CGFloat size) {
    return [[CBIconfont instance] buttonWithIdentify:identify color:color size:size];
}

UILabel * IFLabelMake(NSString * identify,UIColor *color,CGFloat size) {
    return [[CBIconfont instance] labelWithIdentify:identify color:color size:size];
}
UIImage * IFImageMake(NSString * identify,UIColor *color,CGFloat size) {
    return [[CBIconfont instance] imageWithIdentify:identify color:color size:size];
}