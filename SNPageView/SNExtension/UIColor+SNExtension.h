//
//  UIColor+SNExtension.h
//  SNPageView
//
//  Created by sheodon on 16/5/28.
//  Copyright © 2016年 sheodon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(SNExtension)

+ (UIColor*) sn_colorWithRed255:(CGFloat)red green255:(CGFloat)green blue255:(CGFloat)blue alpha:(CGFloat)alpha;
+ (UIColor*) sn_colorWithHex:(NSUInteger)hex;
+ (UIColor*) sn_colorWithAlphaHex:(NSUInteger)hex;
+ (UIColor*) sn_colorWithHexString:(NSString*)string16;

+ (UIColor*) sn_randomColor;

@end
