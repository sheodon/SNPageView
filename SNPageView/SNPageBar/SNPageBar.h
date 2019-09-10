//
//  SNPageBar.h
//  SNPageView
//
//  Created by sheodon on 16/1/19.
//  Copyright © 2016年 sheodon. All rights reserved.
//

#import "SNPageView.h"
#import "SNPageBarItem.h"

@interface SNPageBar : SNTabBar

@property (nonatomic, assign)  BOOL isAutoHeight; // 禁止自动调整高度
@property (nonatomic, readonly) SNPageView    *pageView;

- (void) addItem:(SNPageBarItem*)item;
- (void) addItem:(SNPageBarItem*)item atIndex:(NSUInteger)index;

- (void) updateContentFrame;

@end
