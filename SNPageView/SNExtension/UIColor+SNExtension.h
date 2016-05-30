//
//  UIColor+SNExtension.h
//  SNPageView
//
//  Created by sheodon on 16/5/28.
//  Copyright © 2016年 sheodon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(SNExtension)

+ (UIColor*) colorWithRed255:(CGFloat)red green255:(CGFloat)green blue255:(CGFloat)blue alpha:(CGFloat)alpha;
+ (UIColor*) colorWithHex:(NSUInteger)hex;
+ (UIColor*) colorWithAlphaHex:(NSUInteger)hex;
+ (UIColor*) colorWithHexString:(NSString*)string16;

+ (UIColor*) randomColor;

@end
