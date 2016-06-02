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
/// return page numbers
- (NSInteger) sn_pageViewForPageNumbers:(SNPageView *)pageView;
///
- (UIView*) sn_pageView:(SNPageView *)pageView viewAtIndex:(NSInteger)index;

- (void) sn_pageView:(SNPageView *)pageView itemDidAppear:(SNPageViewItem *)item;
- (void) sn_pageView:(SNPageView *)pageView itemDidDisappear:(SNPageViewItem *)item;

- (void) sn_pageView:(SNPageView *)pageView itemWillAppear:(SNPageViewItem *)item;
- (void) sn_pageView:(SNPageView *)pageView itemWillDisappear:(SNPageViewItem *)item;
///
- (void) sn_pageView:(SNPageView *)pageView itemWillAppear:(SNPageViewItem *)appearItem itemWillDisappear:(SNPageViewItem *)disappearItem;

@end

#pragma mark  SNPageView
@interface SNPageView : UIView
/// 是否循环滚动(默认为 NO)
@property (nonatomic, assign)   BOOL          repeatScroll;
/// 当前页数（默认为0）
@property (nonatomic, assign)   NSInteger     currentIndex;

@property (nonatomic, readonly) UIScrollView  *scrollView;

@property (nonatomic, weak) id<SNPageViewDelegate> delegate;
/// 从当前位置滚动到指定的位置
- (void) scrollToPageAtIndex:(NSInteger)index animated:(BOOL)animated;
/// 重新加载
- (void) reloadData;
/// 返回指定索引的 view
- (UIView *)viewAtIndex:(NSInteger )index;

@end
