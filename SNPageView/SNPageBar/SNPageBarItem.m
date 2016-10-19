//
//  SNPageBarItem.m
//  SNPageView
//
//  Created by sheodon on 16/1/19.
//  Copyright © 2016年 sheodon. All rights reserved.
//

#import "SNPageBarItem.h"
#import "SNPageBar.h"

@implementation SNPageBarItem

- (void) setContentView:(SNPageBarContent *)contentView
{
    if (_contentView == contentView) {
        return;
    }
    _contentView = contentView;
    _contentView.barItem = self;
}

- (void) selectedWill
{
    if (self.status == SNTabBarItemStatusSelected) {
        return;
    }
    [super selectedWill];
    if (_contentView) {
        if (!_contentView.viewLoaded) {
            [_contentView viewLoaded];
            _contentView.viewLoaded = YES;
        }
        [_contentView viewWillAppear];
    }
}

- (void) selectedDid
{
    [super selectedDid];
    if (_contentView) {
        _contentView.viewVisible = YES;
        [_contentView viewDidAppear];
    }
}

- (void) unselectedWill
{
    if (self.status == SNTabBarItemStatusNormal) {
        return;
    }
    
    [super unselectedWill];
    if (_contentView) {
        [_contentView viewWillDisappear];
    }
}

- (void) unselectedDid
{
    [super unselectedDid];
    
    if (_contentView) {
        _contentView.viewVisible = NO;
        [_contentView viewDidDisappear];
    }
}

@end

