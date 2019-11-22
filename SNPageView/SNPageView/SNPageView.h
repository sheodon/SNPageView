//
//  SNPageView.h
//  SNPageView
//
//  Created by sheodon on 16/5/27.
//  Copyright © 2016年 sheodon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNPageViewItem.h"

@class SNPageView;
@protocol SNPageViewDelegate <NSObject>

@required
/// return page numbers
- (NSInteger) sn_pageViewForPageNumbers:(SNPageView *)pageView;
/// return UIView at index;
- (UIView*) sn_pageView:(SNPageView *)pageView viewAtIndex:(NSInteger)index;

@optional
/// called just one time
- (void) sn_pageView:(SNPageView *)pageView itemDidAppear:(SNPageViewItem *)item;
/// called just one time
- (void) sn_pageView:(SNPageView *)pageView itemDidDisappear:(SNPageViewItem *)item;
/// called many times
- (void) sn_pageView:(SNPageView *)pageView itemWillAppear:(SNPageViewItem *)item;
/// called many times
- (void) sn_pageView:(SNPageView *)pageView itemWillDisappear:(SNPageViewItem *)item;
/// called many times
- (void) sn_pageView:(SNPageView *)pageView itemWillAppear:(SNPageViewItem *)appearItem itemWillDisappear:(SNPageViewItem *)disappearItem;

@end

#pragma mark  SNPageView
@interface SNPageView : UIView

@property (nonatomic, readonly) BOOL          loaded;
/// 是否循环滚动(default:NO)
@property (nonatomic, assign)   BOOL          repeatScroll;
/// 当前页数 (default:0）
@property (nonatomic, assign)   NSInteger     currentIndex;
/// 屏蔽分发事件（default:0）
@property (nonatomic, assign)   BOOL          blockDispatchEvent;

///
@property (nonatomic, assign)   BOOL          preloadNext;

@property (nonatomic, readonly) UIScrollView  *scrollView;

@property (nonatomic, weak) id<SNPageViewDelegate> delegate;
/// 从当前位置滚动到指定的位置
- (void) scrollToPageAtIndex:(NSInteger)index animated:(BOOL)animated;
/// 重新加载
- (void) reloadData;
/// 返回指定索引的 view
- (UIView *)viewAtIndex:(NSInteger )index;

@end
