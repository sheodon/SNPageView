//
//  SNPageView.h
//  weibang
//
//  Created by sheodon on 16/5/27.
//  Copyright © 2016年 weibang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNPageViewItem.h"

@class SNPageView;
@protocol SNPageViewDelegate <NSObject>

@optional
- (NSInteger) sn_pageViewForPageNumbers:(SNPageView *)pageView;

- (UIView*) sn_pageView:(SNPageView *)pageView viewAtIndex:(NSInteger)index;

- (void) sn_pageView:(SNPageView *)pageView itemDidAppear:(SNPageViewItem *)item;
- (void) sn_pageView:(SNPageView *)pageView itemDidDisappear:(SNPageViewItem *)item;

- (void) sn_pageView:(SNPageView *)pageView itemWillAppear:(SNPageViewItem *)item;
- (void) sn_pageView:(SNPageView *)pageView itemWillDisappear:(SNPageViewItem *)item;

- (void) sn_pageView:(SNPageView *)pageView itemWillAppear:(SNPageViewItem *)appearItem itemWillDisappear:(SNPageViewItem *)disappearItem;

@end

#pragma mark  SNPageView
@interface SNPageView : UIView

@property (nonatomic, assign)   BOOL          repeatScroll;

@property (nonatomic, assign)   NSInteger     currentIndex;

@property (nonatomic, readonly) UIScrollView  *scrollView;

@property (nonatomic, weak) id<SNPageViewDelegate> delegate;

- (void) scrollToPageAtIndex:(NSInteger)index animated:(BOOL)animated;

- (void) reloadData;

- (UIView *)viewAtIndex:(NSInteger )index;

@end
