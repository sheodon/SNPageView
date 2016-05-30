//
//  SNPageBarContent.m
//  weibang
//
//  Created by sheodon on 16/1/19.
//  Copyright © 2016年 weibang. All rights reserved.
//

#import "SNPageBarContent.h"
#import "SNPageBarItem.h"
#import "SNPageBar.h"

@implementation SNPageBarContent

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (self.barItem && self.barItem.status == SNTabBarItemStatusSelected) {
        SNPageBar *pageBar = (SNPageBar*)self.barItem.tabBar;
        if (pageBar) {
            [pageBar updateContentFrame];
        }
    }
}

- (void) viewLoaded {
    self.viewLoaded = YES;
}

- (void) viewWillDisappear {
    
}

- (void) viewDidDisappear {
    self.viewVisible = NO;
}

- (void) viewWillAppear
{
    
}

- (void) viewDidAppear {
    self.viewVisible = YES;
}

@end
