//
//  NSString+SNColor.m
//  SNPageView
//
//  Created by sheodon on 16/5/28.
//  Copyright © 2016年 sheodon. All rights reserved.
//

#import "NSString+SNColor.h"
#import "UIColor+SNExtension.m"

@implementation NSString(SNColor)

- (UIColor*) sn_color {
    return [UIColor sn_colorWithHexString:self];
}

@end
