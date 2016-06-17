//
//  SNPageViewItem.h
//  SNPageView
//
//  Created by sheodon on 16/5/28.
//  Copyright © 2016年 sheodon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SNPageViewScrollDirectionNone,
    SNPageViewScrollDirectionRight,
    SNPageViewScrollDirectionLeft,
} SNPageViewScrollDirection;

@interface SNPageViewItem : NSObject

@property (nonatomic, strong) UIView    *view;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) SNPageViewScrollDirection direction;

/// 出现或者消失百分百(appear or disappear percent)
@property (nonatomic, assign) CGFloat   percent;

- (id) copy;

@end
