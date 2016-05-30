//
//  UIColor+SNExtension.m
//  SNPageView
//
//  Created by sheodon on 16/5/28.
//  Copyright © 2016年 sheodon. All rights reserved.
//

#import "UIColor+SNExtension.h"

@implementation UIColor(SNExtension)

+ (UIColor*) colorWithRed255:(CGFloat)red green255:(CGFloat)green blue255:(CGFloat)blue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

+ (UIColor*) colorWithHex:(NSUInteger)hex
{
    CGFloat red = (hex & 0xFF0000)>>16;
    CGFloat green = (hex & 0xFF00)>>8;
    CGFloat blue = (hex & 0xFF);
    
    return [UIColor colorWithRed255:red green255:green blue255:blue alpha:1];
}

+ (UIColor*) colorWithAlphaHex:(NSUInteger)hex
{
    CGFloat alpha = (hex & 0xFF000000)>>24;
    CGFloat red = (hex & 0xFF0000)>>16;
    CGFloat green = (hex & 0xFF00)>>8;
    CGFloat blue = (hex & 0xFF);
    
    return [UIColor colorWithRed255:red green255:green blue255:blue alpha:alpha/255];
}

+(UIColor*) colorWithHexString:(NSString*)string16
{
    NSString *color16 = [[string16 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // 去除前缀
    if ([color16 hasPrefix:@"0X"]){
        color16 = [color16 substringFromIndex:2];
    }
    else if ([color16 hasPrefix:@"#"]){
        color16 = [color16 substringFromIndex:1];
    }
    
    unsigned int hex;
    [[NSScanner scannerWithString:color16] scanHexInt:&hex];
    
    if (color16.length > 6) {
        return [UIColor colorWithAlphaHex:hex];
    }
    else {
        return [UIColor colorWithHex:hex];
    }
}

+ (UIColor*) randomColor
{
    UIColor *color;
    float randomRed   = (arc4random()%255)/255.0f;
    float randomGreen = (arc4random()%255)/255.0f;
    float randomBlue  = (arc4random()%255)/255.0f;
    
    color= [UIColor colorWithRed:randomRed green:randomGreen blue:randomBlue alpha:1.0];
    
    return color;
}

@end
