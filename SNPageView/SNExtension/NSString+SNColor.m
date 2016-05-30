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

- (UIColor*) color {
    return [UIColor colorWithHexString:self];
}

@end
