//
//  SNPageBar.m
//  SNPageView
//
//  Created by sheodon on 16/1/19.
//  Copyright © 2016年 sheodon. All rights reserved.
//

#import "SNPageBar.h"
#import "UIView+SNFrameTransform.h"


@interface SNPageBar ()<SNPageViewDelegate>


@end

@implementation SNPageBar

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _initPageBar];
    }
    
    return self;
}

- (void) _initPageBar
{
    _pageView = [SNPageView.alloc initWithFrame:CGRectMake(0, 0, self.sn_width, 0)];
    _pageView.sn_position_0_0 = CGPointMake(0, self.tabBarHeight);
    _pageView.delegate = self;
    [self addSubview:_pageView];
}

- (void) relayout
{
    BOOL isLoaded = self.pageView.loaded;
    [super relayout];
    if (isLoaded || !self.pageView.loaded) {
        [self.pageView reloadData];
    }
}

- (void) addItem:(SNPageBarItem*)item
{
    [super addItem:item];
}

- (void) addItem:(SNPageBarItem *)item atIndex:(NSUInteger)index
{
    [super addItem:item atIndex:index];
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (self.pageView) {
        self.pageView.frame = CGRectMake(0, self.tabBarHeight, self.sn_width, self.sn_height - self.tabBarHeight);
    }
}

- (void) updateContentFrame
{
    SNPageBarItem *item = (SNPageBarItem*)self.items[self.selectedIndex];
    if (item.contentView) {
        self.sn_height = item.contentView.sn_height + self.tabBarHeight;
    }
    else{
        self.sn_height = self.tabBarHeight;
    }
    
    self.pageView.sn_height = self.sn_height - self.tabBarHeight;
}

- (void) selectItemWithIndex:(NSInteger)index animated:(BOOL)animated force:(BOOL)force
{
    BOOL pageAnimated = (ABS(self.selectedIndex - index) == 1) && animated;
   
    SNPageBarItem *item = (SNPageBarItem*)self.items[index];
    self.pageView.blockDispatchEvent = YES;
    if (item.contentView) {
        self.sn_height = item.contentView.sn_height+self.tabBarHeight;
    }
    [self.pageView scrollToPageAtIndex:index animated:pageAnimated];
    self.pageView.blockDispatchEvent = NO;
    
    [super selectItemWithIndex:index animated:animated force:force];
    if (!item.contentView) {
        self.sn_height = self.tabBarHeight;
    }
}

#pragma mark
#pragma mark WBPageViewDelegate
- (NSInteger) sn_pageViewForPageNumbers:(SNPageView*)pageView
{
    return self.items.count;
}

- (UIView*) sn_pageView:(SNPageView *)pageView viewAtIndex:(NSInteger)index
{
    SNPageBarItem *item = (SNPageBarItem*)self.items[index];
    
    return item.contentView;
}

- (void) sn_pageView:(SNPageView *)pageView itemWillAppear:(SNPageViewItem *)item
{
    SNPageBarItem *itemBar = (SNPageBarItem*)self.items[item.index];
    [itemBar selectedWill];
    
    //    NSLog(@"itemWillAppear %@", item);
}

- (void) sn_pageView:(SNPageView *)pageView itemWillDisappear:(SNPageViewItem *)item
{
    SNPageBarItem *itemBar = (SNPageBarItem*)self.items[item.index];
    [itemBar unselectedWill];
    
    //    NSLog(@"itemWillDisappear %@", item);
}

- (void) sn_pageView:(SNPageView *)pageView itemWillAppear:(SNPageViewItem *)appearItem itemWillDisappear:(SNPageViewItem *)disappearItem
{
    if (appearItem.percent == 0) {
        
    }
    BOOL isToLeft = appearItem.direction == SNPageViewScrollDirectionLeft;
    [super setTipLineLocatitonFromIndex:disappearItem.index toIndex:appearItem.index percent:appearItem.percent direction:isToLeft];
}

- (void) sn_pageView:(SNPageView *)pageView itemDidAppear:(SNPageViewItem *)item
{
    SNPageBarItem *itemBar = (SNPageBarItem*)self.items[item.index];
    [itemBar selectedDid];
    
    [super selectItemWithIndex:item.index animated:YES force:NO];
    
    //    NSLog(@"itemDidAppear %@", item);
}

- (void) sn_pageView:(SNPageView *)pageView itemDidDisappear:(SNPageViewItem *)item
{
    SNPageBarItem *itemBar = (SNPageBarItem*)self.items[item.index];
    [itemBar unselectedDid];
    
    //    NSLog(@"itemDidDisappear %@", item);
}

@end
