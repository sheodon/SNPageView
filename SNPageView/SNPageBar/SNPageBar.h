//
//  SNPageBar.h
//  weibang
//
//  Created by sheodon on 16/1/19.
//  Copyright © 2016年 weibang. All rights reserved.
//

#import "SNPageView.h"
#import "SNPageBarItem.h"

@interface SNPageBar : SNTabBar

@property (nonatomic, readonly) SNPageView    *pageView;

- (void) addItem:(SNPageBarItem*)item;
- (void) addItem:(SNPageBarItem*)item atIndex:(NSUInteger)index;

- (void) updateContentFrame;

@end
