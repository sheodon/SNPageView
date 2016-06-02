//
//  SNPageView.m
//  weibang
//
//  Created by sheodon on 16/5/27.
//  Copyright © 2016年 weibang. All rights reserved.
//

#import "SNPageView.h"
#import "UIView+SNFrameTransform.h"

@interface SNPageViewItemEx : SNPageViewItem

@property (nonatomic, assign) BOOL  isSwaped;

@end

@implementation SNPageViewItemEx

@end

@interface SNPageView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableDictionary   *pageViews;
@property (nonatomic, strong) NSMutableSet          *unusedViews;

@property (nonatomic, assign) NSInteger     pageCount;
/// 上次滑动的点
@property (nonatomic, assign) CGPoint       lastPoit;

@property (nonatomic, assign) BOOL                      blockEvent;
@property (nonatomic, assign) BOOL                      blockHandleDidScroll;

@property (nonatomic, strong) SNPageViewItemEx *itemWillAppear;
@property (nonatomic, strong) SNPageViewItemEx *itemWillDisappear;

@property (nonatomic, assign) BOOL  loaded;

@end

@implementation SNPageView

- (id) init
{
    if (self = [super init]) {
        [self _initPageView];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _initPageView];
    }
    return self;
}

- (void) _initPageView
{
    self.pageViews = [NSMutableDictionary dictionary];
    self.unusedViews = [NSMutableSet set];
    
    _scrollView = [UIScrollView.alloc initWithFrame:self.bounds];
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _scrollView.frame = self.bounds;
    if (_scrollView.contentSize.height != frame.size.height) {
        _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, frame.size.height);
    }
}

- (void) setRepeatScroll:(BOOL)repeatScroll
{
    _repeatScroll = repeatScroll;
    if (_loaded) {
        [self reloadData];
    }
}

- (void) setCurrentIndex:(NSInteger)currentIndex
{
    if (_currentIndex == currentIndex) {
        return;
    }
    [self scrollToPageAtIndex:currentIndex animated:NO];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    if (_loaded == NO) {
        [self reloadData];
    }
}

- (void) scrollToPageAtIndex:(NSInteger)pageIndex animated:(BOOL)animated
{
    if (_loaded == NO) {
        [self reloadData];
    }
    
    if (self.repeatScroll) {
        if (pageIndex > _pageCount || pageIndex < 0) {
            return;
        }
    }
    else if (pageIndex > _pageCount - 1 || pageIndex < 0) {
        return;
    }
    
    if (pageIndex == _currentIndex) {
        return;
    }
    
    if (!self.repeatScroll && pageIndex >= _pageCount) {
        return;
    }
    
    [self visibleViewAtIndex:pageIndex-1];
    [self visibleViewAtIndex:pageIndex];
    [self visibleViewAtIndex:pageIndex+1];
    
    self.blockEvent = YES;
    CGPoint point = [self pointForIndex:[self positiveIndex:pageIndex]];
    [self.scrollView setContentOffset:point animated:animated];
    self.blockEvent = NO;
    
    pageIndex = [self validateOverIndex:pageIndex];
    
    NSInteger tempCurrIndex = _currentIndex;
    [self dispatchWillEventWithIndex:tempCurrIndex isAppear:NO];
    [self dispatchWillEventWithIndex:pageIndex isAppear:YES];
    _currentIndex = pageIndex;
    [self dispatchDidEventWithAppearIndex:pageIndex disappearIndex:tempCurrIndex];

    [self cleanupWillScrollStatus];
    self.blockEvent = YES;
}

- (CGPoint) pointForIndex:(NSInteger)pageIndex
{
    return CGPointMake(pageIndex * self.scrollView.sn_width, self.scrollView.contentOffset.y);
}

- (void) reloadData
{
    BOOL isBLoaded = _loaded;
    _loaded = YES;
    
    [_pageViews.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_pageViews removeAllObjects];
    
    if (_delegate && [_delegate respondsToSelector:@selector(sn_pageViewForPageNumbers:)]) {
        _pageCount = [_delegate sn_pageViewForPageNumbers:self];
    }
    
    CGFloat totalWidth = self.sn_width * _pageCount;
    if (self.repeatScroll) {
        self.scrollView.contentSize = CGSizeMake(totalWidth + self.sn_width * 2, self.sn_height);
    }
    else {
        self.scrollView.contentSize = CGSizeMake(totalWidth, self.sn_height);
    }
    
    [self makeViewVisibleAtIndex:_currentIndex];
    
    if (!isBLoaded) {
        [self dispatchWillEventWithIndex:_currentIndex isAppear:YES];
        [self dispatchDidEventWithIndex:_currentIndex isAppear:YES];
    }
    else {
        [self dispatchWillEventWithIndex:_currentIndex isAppear:NO];
        [self dispatchWillEventWithIndex:_currentIndex isAppear:YES];
        [self dispatchDidEventWithAppearIndex:_currentIndex disappearIndex:_currentIndex];
    }
}

- (UIView *)viewAtIndex:(NSInteger )index
{
    NSInteger viewIndex = [self validateOverIndex:index];
    if (viewIndex >= _pageCount) {
        return nil;
    }
    if (viewIndex < 0) {
        return nil;
    }
    
    NSString *key = [NSString stringWithFormat:@"%ld", (long)viewIndex];
    UIView *view = [_pageViews objectForKey:key];
    if (view != nil) {
        return view;
    }
    
    if ([_delegate respondsToSelector:@selector(sn_pageView:viewAtIndex:)]) {
        view = [_delegate sn_pageView:self viewAtIndex:viewIndex];
    }
    
    return view;
}

#pragma mark
- (void) cleanupWillScrollStatus
{
    self.lastPoit = _scrollView.contentOffset;
    self.blockEvent = NO;
    
    self.itemWillAppear = nil;
    self.itemWillDisappear = nil;
}

- (SNPageViewScrollDirection) isMoveToLeftWithPoint:(CGPoint)point
{
    BOOL isMoveToLeft = point.x > _lastPoit.x;
    
    _lastPoit = point;
    
    return isMoveToLeft ? SNPageViewScrollDirectionLeft : SNPageViewScrollDirectionRight;
}

- (NSInteger) validateOverIndex:(NSInteger)pageIndex
{
    if (self.repeatScroll) {
        if (pageIndex < 0) {
            return self.pageCount + pageIndex;
        }
        else if (pageIndex >= self.pageCount) {
            return pageIndex - self.pageCount;
        }
    }
    return pageIndex;
}

/// 正
- (NSInteger) positiveIndex:(NSInteger)pageIndex
{
    return _repeatScroll ? pageIndex + 1 : pageIndex;
}

/// 负
- (NSInteger) negativeIndex:(NSInteger)pageIndex
{
    return _repeatScroll ? pageIndex - 1 : pageIndex;
}

- (SNPageViewScrollDirection) directionByAppearIndex:(NSInteger)appearIndex disappearIndex:(NSInteger)disappearIndex
{
    SNPageViewScrollDirection direction;
    if (disappearIndex == 0 && appearIndex == _pageCount - 1) {
        direction = SNPageViewScrollDirectionRight;
    }
    else if (appearIndex == 0 && disappearIndex == _pageCount - 1) {
        direction = SNPageViewScrollDirectionLeft;
    }
    else if (disappearIndex > appearIndex) {
        direction = SNPageViewScrollDirectionLeft;
    }
    else {
        direction = SNPageViewScrollDirectionRight;
    }
    return direction;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self cleanupWillScrollStatus];
    
    self.itemWillAppear = [SNPageViewItemEx.alloc init];
    self.itemWillDisappear = [SNPageViewItemEx.alloc init];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageIndex = scrollView.contentOffset.x / self.scrollView.frame.size.width;
    
    _currentIndex = [self validateOverIndex:[self negativeIndex:pageIndex]];
    
    [self makeViewVisibleAtIndex:self.currentIndex];
    
    [self dispatchDidEvents];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.blockHandleDidScroll) {
        return;
    }
    SNPageViewScrollDirection direction = [self isMoveToLeftWithPoint:scrollView.contentOffset];
    
    float offset = scrollView.contentOffset.x / scrollView.frame.size.width;
    CGFloat percent = offset - floorf(offset);
   
    NSInteger appearIndex = (direction == SNPageViewScrollDirectionLeft) ? ceilf(offset) : floorf(offset);
    appearIndex = [self negativeIndex:appearIndex];
    NSInteger disppearIndex = appearIndex + ((direction == SNPageViewScrollDirectionLeft) ? - 1 : + 1);
    
    if (self.itemWillAppear.view == nil) {
        [self initDataAppear:appearIndex disappear:disppearIndex direction:direction];
    }
    
    if (direction == SNPageViewScrollDirectionLeft) {
        [self moveViewToLeftWithIndex:appearIndex];
    }
    else {
        [self moveViewToRightWithIndex:appearIndex];
    }
    
    if (self.itemWillAppear.direction != direction) {// swap item
        id temp = self.itemWillAppear;
        self.itemWillAppear = self.itemWillDisappear;
        self.itemWillDisappear = temp;
        self.itemWillAppear.isSwaped = YES;
        self.itemWillDisappear.isSwaped = YES;
    }
    
    [self initDataAppear:appearIndex disappear:disppearIndex direction:direction];
    
    [self dispatchWillEventsWithDirection:direction percent:percent];
}

- (void) dispatchDidEvents
{
    if (self.blockEvent) {
        return;
    }
    
    if (self.itemWillAppear == nil || self.itemWillAppear.view == nil) {
        return;
    }
    
    self.itemWillAppear.percent = 1.f;
    self.itemWillDisappear.percent = 1.f;
    
    if ([_delegate respondsToSelector:@selector(sn_pageView:itemDidAppear:)]) {
        [_delegate sn_pageView:self itemDidAppear:self.itemWillAppear];
    }
    
    if ([_delegate respondsToSelector:@selector(sn_pageView:itemDidDisappear:)]) {
        [_delegate sn_pageView:self itemDidDisappear:self.itemWillDisappear];
    }
    
    self.itemWillAppear = nil;
    self.itemWillDisappear = nil;
}

- (void) dispatchDidEventWithAppearIndex:(NSInteger)appearIndex disappearIndex:(NSInteger)disappearIndex
{
    if (self.blockEvent) {
        return;
    }
    
    SNPageViewScrollDirection direction = [self directionByAppearIndex:appearIndex disappearIndex:disappearIndex];
    
    SNPageViewItemEx *disappearItem = [SNPageViewItemEx.alloc init];
    disappearItem.direction = direction;
    disappearItem.index = [self validateOverIndex:disappearIndex];
    disappearItem.view = [self viewAtIndex:disappearIndex];
    disappearItem.percent = 1.f;
    if (disappearItem.index >= 0 && disappearItem.index < _pageCount ) {
        if ([_delegate respondsToSelector:@selector(sn_pageView:itemDidDisappear:)]) {
            [_delegate sn_pageView:self itemDidDisappear:disappearItem];
        }
    }
    
    // appear
    SNPageViewItemEx *appearItem = [SNPageViewItemEx.alloc init];
    
    appearItem.direction = direction;
    appearItem.index = [self validateOverIndex:appearIndex];
    appearItem.view = [self viewAtIndex:appearIndex];
    appearItem.percent = 1.f;
    
    if (appearItem.index >= 0 && appearItem.index < _pageCount ) {
        if ([_delegate respondsToSelector:@selector(sn_pageView:itemDidAppear:)]) {
            [_delegate sn_pageView:self itemDidAppear:appearItem];
        }
    }
}

- (void) dispatchDidEventWithIndex:(NSInteger)index isAppear:(BOOL)isAppear
{
    if (self.blockEvent) {
        return;
    }
    
    SNPageViewItemEx *item = [SNPageViewItemEx.alloc init];
    item.direction = SNPageViewScrollDirectionNone;
    item.index = [self validateOverIndex:index];
    item.view = [self viewAtIndex:index];
    
    if (item.index < 0 && item.index >= _pageCount ) {
        return;
    }
    if (isAppear) {
        if ([_delegate respondsToSelector:@selector(sn_pageView:itemDidAppear:)]) {
            [_delegate sn_pageView:self itemDidAppear:item];
        }
    }
    else {
        if ([_delegate respondsToSelector:@selector(sn_pageView:itemDidDisappear:)]) {
            [_delegate sn_pageView:self itemDidDisappear:item];
        }
    }
}

- (void) dispatchWillEventsWithDirection:(SNPageViewScrollDirection)direction percent:(CGFloat)percent
{
    if (self.blockEvent) {
        return;
    }
    
    if (self.itemWillAppear == nil) {
        return;
    }
    if (direction == SNPageViewScrollDirectionRight) {
        percent = 1 - percent;
    }
   
    [self setItem:self.itemWillAppear direction:direction percent:percent];
    [self setItem:self.itemWillDisappear direction:direction percent:percent];
    
    if ([_delegate respondsToSelector:@selector(sn_pageView:itemWillAppear:)]) {
        [_delegate sn_pageView:self itemWillAppear:self.itemWillAppear];
    }
    
    if ([_delegate respondsToSelector:@selector(sn_pageView:itemWillDisappear:)]) {
        [_delegate sn_pageView:self itemWillDisappear:self.itemWillDisappear];
    }
    
    if ([_delegate respondsToSelector:@selector(sn_pageView:itemWillAppear:itemWillDisappear:)]) {
        [_delegate sn_pageView:self itemWillAppear:self.itemWillAppear itemWillDisappear:self.itemWillDisappear];
    }
}

- (void) dispatchWillEventWithIndex:(NSInteger)index isAppear:(BOOL)isAppear
{
    if (self.blockEvent) {
        return;
    }
    
    SNPageViewItemEx *item = [SNPageViewItemEx.alloc init];
    item.direction = SNPageViewScrollDirectionNone;
    item.index = [self validateOverIndex:index];
    item.view = [self viewAtIndex:index];
    
    if (item.index < 0 && item.index >= _pageCount ) {
        return;
    }
    if (isAppear) {
        if ([_delegate respondsToSelector:@selector(sn_pageView:itemWillAppear:)]) {
            [_delegate sn_pageView:self itemWillAppear:item];
        }
    }
    else {
        if ([_delegate respondsToSelector:@selector(sn_pageView:itemWillDisappear:)]) {
            [_delegate sn_pageView:self itemWillDisappear:item];
        }
    }
}

- (void) setItem:(SNPageViewItemEx*)item direction:(SNPageViewScrollDirection)direction percent:(CGFloat)percent
{
    percent = (item.direction != direction) ? 1 - percent : percent;
    if (percent == 0 && (item.percent > 0.5 || !item.isSwaped)) { // 对临界值处理
        percent = 1.f;
    }
    item.percent = percent;
    item.direction = direction;
}

// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self makeViewVisibleAtIndex:self.currentIndex];
    [self cleanupWillScrollStatus];
}

#pragma mark
- (void) initDataAppear:(NSInteger)appearIndex disappear:(NSInteger)disappearIndex direction:(SNPageViewScrollDirection)direction
{
    if (self.itemWillAppear == nil) {
        return;
    }
    
    self.itemWillAppear.index = [self validateOverIndex:appearIndex];
    self.itemWillAppear.view = [self viewAtIndex:self.itemWillAppear.index];
    self.itemWillAppear.direction = direction;
    
    self.itemWillDisappear.index = [self validateOverIndex:disappearIndex];
    self.itemWillDisappear.view = [self viewAtIndex:self.itemWillDisappear.index];
    self.itemWillDisappear.direction = direction;
}

- (void) moveViewToLeftWithIndex:(NSInteger)pageIndex
{
    // 显示 pageIndex
    [self visibleViewAtIndex:pageIndex];
    
    // 隐藏 pageIdex - 2
    [self hiddenViewAtIndex:pageIndex - 3];
}

- (void) moveViewToRightWithIndex:(NSInteger)pageIndex
{
    // 显示 pageIndex
    [self visibleViewAtIndex:pageIndex];
    
    // 隐藏 pageIdex - 2
    [self hiddenViewAtIndex:pageIndex + 3];
}

- (void) makeViewVisibleAtIndex:(NSInteger)pageIndex
{
    self.blockHandleDidScroll = YES;
    
    [self visibleViewAtIndex:pageIndex];
    
    CGRect rect = CGRectMake([self positiveIndex:pageIndex] * self.sn_width, 0, self.sn_width, self.sn_height);
    
    [self.scrollView scrollRectToVisible:rect animated:NO];
    self.blockHandleDidScroll = NO;
}

- (UIView*) visibleViewAtIndex:(NSInteger)pageIndex
{
    NSInteger viewIndex = [self validateOverIndex:pageIndex];
    if (viewIndex >= _pageCount) {
        return nil;
    }
    if (viewIndex < 0) {
        return nil;
    }
   
    if (ABS(_scrollView.contentOffset.y) > 0.00001) {
        _scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x, 0);
    }
    
    NSString *key = [NSString stringWithFormat:@"%ld", (long)viewIndex];
    UIView *view = [_pageViews objectForKey:key];
    if (view != nil) {
        view.frame = CGRectMake([self positiveIndex:pageIndex] * self.sn_width, 0, view.sn_width, view.sn_height);
        return view;
    }
    
    if ([_delegate respondsToSelector:@selector(sn_pageView:viewAtIndex:)]) {
        view = [_delegate sn_pageView:self viewAtIndex:viewIndex];
    }
    if (view) {
        [_pageViews setObject:view forKey:key];
        
        view.frame = CGRectMake([self positiveIndex:pageIndex] * self.sn_width, 0, view.sn_width, view.sn_height);
        [_scrollView addSubview:view];
    }
    
    return view;
}

- (void) hiddenViewAtIndex:(NSInteger)pageIndex
{
    if (_pageViews.count <= 3) {
        return;
    }
    
    pageIndex = [self validateOverIndex:pageIndex];
    if (pageIndex < 0)  {
        return;
    }
    
    NSString *key = [NSString stringWithFormat:@"%ld", (long)pageIndex];
    UIView *view = [_pageViews objectForKey:key];
    if (view) {
        [_pageViews removeObjectForKey:key];
        [view removeFromSuperview];
        view = nil;
    }
}

@end
