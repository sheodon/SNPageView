//
//  SNPageBarContent.m
//  SNPageView
//
//  Created by sheodon on 16/1/19.
//  Copyright © 2016年 sheodon. All rights reserved.
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

- (void) setBarItem:(SNPageBarItem *)barItem {
    _barItem = barItem;
    if (!_isViewInitialized) {
        _isViewInitialized = YES;
        [self viewInitialized];
    }
}

- (void) viewInitialized
{
    
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
