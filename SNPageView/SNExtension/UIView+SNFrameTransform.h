//
//  UIView+SNFrameTransform.h
//  SNPageView
//
//  Created by sheodon on 16/5/28.
//  Copyright © 2016年 sheodon. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark WBFrameTransform
@interface UIView (WBFrameTransform)

/// CGFrame origin
@property (nonatomic) CGPoint   sn_position;
/// CGFrame origin.x
@property (nonatomic) CGFloat   sn_positionx;
/// CGFrame origin.y
@property (nonatomic) CGFloat   sn_positiony;

/// CGFrame size
@property (nonatomic) CGSize    sn_size;
/// CGFrame size.width
@property (nonatomic) CGFloat   sn_width;
/// CGFrame size.height
@property (nonatomic) CGFloat   sn_height;

/// UIView 右边的 x 坐标
@property (nonatomic) CGFloat   sn_right;
/// UIView 左边的 x 坐标
@property (nonatomic) CGFloat   sn_left;
/// UIView 上边的 y 坐标
@property (nonatomic) CGFloat   sn_top;
/// UIView 下边的 y 坐标
@property (nonatomic) CGFloat   sn_bottom;

/// 左 上 点
@property (nonatomic) CGPoint   sn_position_0_0;
/// 左 中 点
@property (nonatomic) CGPoint   sn_position_0_m;
/// 左 下 点
@property (nonatomic) CGPoint   sn_position_0_1;
/// 右 上 点
@property (nonatomic) CGPoint   sn_position_1_0;
/// 右 中 点
@property (nonatomic) CGPoint   sn_position_1_m;
/// 右 下 点
@property (nonatomic) CGPoint   sn_position_1_1;
/// 上 中 点
@property (nonatomic) CGPoint   sn_position_m_0;
/// 正 中 点
@property (nonatomic) CGPoint   sn_position_m_m;
/// 下 中 点
@property (nonatomic) CGPoint   sn_position_m_1;

/// 宽度的一半
- (CGFloat) sn_widthHalf;
/// 高度的一半
- (CGFloat) sn_heightHalf;

/// 设置frame之后才有效
- (void) sn_setPosition:(CGPoint)position anchorPoint:(CGPoint)anchorPoint;

@end
