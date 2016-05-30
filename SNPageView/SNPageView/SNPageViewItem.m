//
//  SNPageViewItem.m
//  SNPageView
//
//  Created by sheodon on 16/5/28.
//  Copyright © 2016年 sheodon. All rights reserved.
//

#import "SNPageViewItem.h"

@implementation SNPageViewItem

- (id) copy
{
    SNPageViewItem *item = [super copy];
    item.index = self.index;
    item.percent = self.percent;
    item.view = self.view;
    return item;
}

- (NSString*) description
{
    NSString *str = [NSString stringWithFormat:@"index:%ld, percent:%f, direction:%d", (long)self.index, self.percent, (int)self.direction];
    return str;
}

@end
