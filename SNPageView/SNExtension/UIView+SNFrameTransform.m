//
//  UIView+SNFrameTransform.m
//  SNPageView
//
//  Created by sheodon on 16/5/28.
//  Copyright © 2016年 sheodon. All rights reserved.
//

#import "UIView+SNFrameTransform.h"

@implementation UIView (WBFrameTransform)

#pragma mark position
- (CGPoint) sn_position {
    return self.frame.origin;
}

- (void) setSn_position:(CGPoint)sn_position {
    self.frame = CGRectMake(sn_position.x, sn_position.y, self.sn_width, self.sn_height);
}

#pragma mark positionx
- (CGFloat) sn_positionx {
    return self.sn_position.x;
}

- (void) setSn_positionx:(CGFloat)positionx {
    self.frame = CGRectMake(positionx, self.sn_positiony, self.sn_width, self.sn_height);
}

#pragma mark positiony
- (CGFloat) sn_positiony {
    return self.frame.origin.y;
}

- (void) setSn_positiony:(CGFloat)positiony {
    self.frame = CGRectMake(self.sn_positionx, positiony, self.sn_width, self.sn_height);
}

#pragma mark sn_size
- (CGSize) sn_size {
    return self.frame.size;
}

- (void) setSn_size:(CGSize)size {
    self.frame = CGRectMake(self.sn_positionx, self.sn_positiony, size.width, size.height);
}

#pragma mark sn_width
- (CGFloat) sn_width {
    return self.sn_size.width;
}

- (void) setSn_width:(CGFloat)sn_width {
    self.sn_size = CGSizeMake(sn_width, self.sn_height);
}

#pragma mark sn_height
- (CGFloat) sn_height {
    return self.sn_size.height;
}

- (void) setSn_height:(CGFloat)sn_height {
    self.sn_size = CGSizeMake(self.sn_width, sn_height);
}

#pragma mark sn_right
- (CGFloat) sn_right {
    return self.sn_left + self.sn_width;
}

- (void) setSn_right:(CGFloat)sn_right {
    self.sn_positionx = sn_right - self.sn_width;
}

#pragma mark sn_left
- (CGFloat) sn_left {
    return self.sn_positionx;
}

- (void) setSn_left:(CGFloat)sn_left {
    self.sn_positionx = sn_left;
}

#pragma mark sn_top
- (CGFloat) sn_top {
    return self.sn_positiony;
}

- (void) setSn_top:(CGFloat)sn_top {
    self.sn_positiony = sn_top;
}

#pragma mark sn_bottom
- (CGFloat) sn_bottom {
    return self.sn_top + self.sn_height;
}

- (void) setSn_bottom:(CGFloat)sn_bottom {
    self.sn_positiony = sn_bottom - self.sn_height;
}

#pragma mark
- (CGPoint) sn_position_0_0 {
    return  self.sn_position;
}

- (void) setSn_position_0_0:(CGPoint)sn_position_0_0 {
    self.sn_position = sn_position_0_0;
}

#pragma mark sn_position_0_m
- (CGPoint) sn_position_0_m {
    return CGPointMake(self.sn_positionx, self.center.y);
}

- (void) setSn_position_0_m:(CGPoint)sn_position_0_m {
    [self sn_setPosition:sn_position_0_m anchorPoint:CGPointMake(0, 0.5)];
}

#pragma mark sn_position_0_1
- (CGPoint) sn_position_0_1 {
    return CGPointMake(self.sn_positionx, self.sn_bottom);
}

- (void) setSn_position_0_1:(CGPoint)sn_position_0_1 {
    [self sn_setPosition:sn_position_0_1 anchorPoint:CGPointMake(0, 1)];
}

#pragma mark sn_position_1_0
- (CGPoint)sn_position_1_0 {
   return CGPointMake(self.sn_right, self.sn_top);
}

- (void) setSn_position_1_0:(CGPoint)sn_position_1_0 {
    [self sn_setPosition:sn_position_1_0 anchorPoint:CGPointMake(1, 0)];
}

#pragma mark sn_position_1_m
- (CGPoint) sn_position_1_m {
    return CGPointMake(self.sn_right, self.center.y);
}

- (void) setSn_position_1_m:(CGPoint)sn_position_1_m {
    [self sn_setPosition:sn_position_1_m anchorPoint:CGPointMake(1, 0.5)];
}

#pragma mark sn_position_1_1
- (CGPoint) sn_position_1_1 {
    return CGPointMake(self.sn_right, self.sn_bottom);
}

- (void) setSn_position_1_1:(CGPoint)sn_position_1_1 {
    [self sn_setPosition:sn_position_1_1 anchorPoint:CGPointMake(1, 1)];
}

#pragma mark sn_position_m_0
- (CGPoint) sn_position_m_0 {
    return CGPointMake(self.center.x, self.sn_top);
}

- (void) setSn_position_m_0:(CGPoint)sn_position_m_0 {
    [self sn_setPosition:sn_position_m_0 anchorPoint:CGPointMake(0.5, 0)];
}

#pragma mark sn_position_m_m
- (CGPoint) sn_position_m_m {
    return self.center;
}

- (void) setSn_position_m_m:(CGPoint)sn_position_m_m {
    self.center = sn_position_m_m;
}

#pragma mark sn_position_m_1
- (CGPoint) sn_position_m_1 {
    return CGPointMake(self.center.x, self.sn_bottom);
}

- (void) setSn_position_m_1:(CGPoint)sn_position_m_1 {
    [self sn_setPosition:sn_position_m_1 anchorPoint:CGPointMake(0.5, 1)];
}

#pragma mark
- (CGFloat) sn_widthHalf {
    return self.sn_width * 0.5f;
}

- (CGFloat) sn_heightHalf {
    return  self.sn_height * 0.5;
}

/// 设置frame之后才有效
- (void) sn_setPosition:(CGPoint)position anchorPoint:(CGPoint)anchorPoint {
    CGRect frame = self.frame;
    float pointx = position.x - frame.size.width * anchorPoint.x;
    float pointy = position.y - frame.size.height * anchorPoint.y;
    
    if (frame.origin.x != pointx || frame.origin.y != pointy) {
        self.frame = CGRectMake(pointx, pointy, frame.size.width, frame.size.height);
    }
}

@end
