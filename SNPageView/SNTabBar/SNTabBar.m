//
//  SNTabBar.m
//  SNPageView
//
//  Created by sheodon on 14/12/15.
//  Copyright (c) 2016年 sheodon. All rights reserved.
//

#import "SNTabBar.h"
#import "NSString+SNColor.h"
#import "UIView+SNFrameTransform.h"

#define kTabViewTag 2020
#define kTabLabelTag 2000
#define kTipImageViewTag 2010
#define kTabViewLineTag 2030

static NSString * SNTabBarSelectedClr = @"45c01a";
static NSString * SNTabBarNormalClr = @"404040";
static NSString * SNTabBarBgClr = @"ffffff";


#pragma mark SNTabBar interface
@interface SNTabBar ()

@property (nonatomic, assign) BOOL  layouted;

@end

#pragma mark SNTabBarItem interface
@interface SNTabBarItem ()

@end

#pragma mark SNTabBar implementation

@interface SNTabBar ()

@property (nonatomic, strong) UIView         *itemLineView;

@property (nonatomic, strong) UIScrollView   *scrollView;

@end

@implementation SNTabBar

+ (void) setSelectedClr:(NSString*)clr
{
    if (clr.length > 0) {
        SNTabBarSelectedClr = clr;
    }
}

+ (void) setNormalClr:(NSString*)clr
{
    if (clr.length > 0) {
        SNTabBarNormalClr = clr;
    }
}

+ (void) setBackgroudColor:(NSString*)clr
{
    if (clr.length > 0) {
        SNTabBarBgClr = clr;
    }
}

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _layouted = NO;
        _tabBarHeight = frame.size.height;
        [self _initView];
    }
    return self;
}

- (void) _initView
{
    _items = [NSMutableArray array];
    
    _scrollView = [UIScrollView.alloc initWithFrame:CGRectMake(0, 0, self.sn_width, self.sn_height)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator   = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.scrollsToTop = NO;
    [self addSubview:_scrollView];
    
    CGSize size = self.frame.size;
    
    self.backgroundColor = SNTabBarBgClr.sn_color;
    
    self.tabLineWidth = 0.5;
    self.tipLineWidth = 4.0;
    self.minItemWidth = 74.f;
    
    // 标签底线
    _itemLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, _tabBarHeight-_tipLineWidth, 0.0f, _tipLineWidth)];
    _itemLineView.backgroundColor = SNTabBarSelectedClr.sn_color;
    _itemLineView.layer.zPosition = MAXFLOAT;
    [self.scrollView addSubview:_itemLineView];
    
    // tab底线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, _tabBarHeight-_tabLineWidth, size.width, _tabLineWidth)];
    lineView.backgroundColor = SNTabBarSelectedClr.sn_color;
    lineView.layer.zPosition = MAXFLOAT;
    [self addSubview:lineView];
}

- (void) setFrame:(CGRect)frame
{
    BOOL isChanged = CGSizeEqualToSize(self.sn_size, frame.size);
    [super setFrame:frame];
    self.scrollView.sn_size = frame.size;
    if (_layouted && !isChanged) {
        [self relayout];
    }
}

- (NSUInteger) indexOfItem:(SNTabBarItem*)item
{
    return [self.items indexOfObject:item];
}

- (void) addItem:(SNTabBarItem *)item
{
    [self addItem:item atIndex:_items.count];
}

/// 插入 item
- (void) addItem:(SNTabBarItem*)item atIndex:(NSUInteger)index;
{
    // 安全处理
    index = MIN(index, _items.count);
    
    if (index <= _selectedIndex && self.items.count > 0) {
        _selectedIndex += 1;
    }
    
    item.tabBar = self;
    
    [self.items insertObject:item atIndex:index];
    [self.scrollView addSubview:item];
    
    [item addTarget:self action:@selector(_onItemTouchDown:) forControlEvents:UIControlEventTouchDown];
    [item addTarget:self action:@selector(_onItemDragInside:) forControlEvents:UIControlEventTouchDragInside];
    [item addTarget:self action:@selector(_onItemDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
    [item addTarget:self action:@selector(_onItemTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [item addTarget:self action:@selector(_onItemTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    
    if (_layouted) {
        [self relayout];
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    if (_layouted == NO) {
        [self relayout];
    }
}

// 移除 item
- (void) removeItem:(SNTabBarItem*)item
{
    NSUInteger index = [_items indexOfObject:item];
    [self removeItemAtIndex:index];
}

/// 移除 item
- (void) removeItemAtIndex:(NSUInteger)index;
{
    if (index >= _items.count) {
        return;
    }
    
    SNTabBarItem *item = _items[index];
    [item removeFromSuperview];
    
    [_items removeObjectAtIndex:index];
    
    if (index < _selectedIndex) {
        _selectedIndex -= 1;
    }
    _selectedIndex = fminf(_selectedIndex, _items.count - 1);
    if (_selectedIndex < 0) {
        _selectedIndex = 0;
    }
    if (_layouted) {
        [self relayout];
    }
}

#pragma mark
- (void) _onItemTouchUpInside:(SNTabBarItem*)item
{
    if (item.isAllowSelected) {
        [self selectItemWithIndex:[self indexOfItem:item] animated:YES force:NO];
    }
    else{
        [item clicked];
        if (_delegate && [_delegate respondsToSelector:@selector(SNTabBar:didClickItem:)]) {
            [_delegate SNTabBar:self didClickItem:item];
        }
        item.highlighted = NO;
    }
}

- (void) _onItemTouchUpOutside:(SNTabBarItem*)item
{
    if (!item.isAllowSelected) {
        item.highlighted = NO;
    }
}

- (void) _onItemDragInside:(SNTabBarItem*)item
{
    if (!item.isAllowSelected) {
        item.highlighted = YES;
    }
}

- (void) _onItemDragOutside:(SNTabBarItem*)item
{
    if (!item.isAllowSelected) {
        item.highlighted = NO;
    }
}

- (void) _onItemTouchDown:(SNTabBarItem*)item
{
    if (!item.isAllowSelected) {
        item.highlighted = YES;
    }
}

- (void) setTipLineLocatitonFromIndex:(NSInteger)from toIndex:(NSInteger)toIndex percent:(CGFloat)percent direction:(BOOL)isToLeft
{
    SNTabBarItem *fromItem = _items[from];
    SNTabBarItem *toItem = _items[toIndex];
    if (isToLeft)
    {
        if (from < toIndex) {
            CGFloat distance = toItem.sn_width * percent;
            
            self.itemLineView.sn_left = fromItem.sn_left + distance;
            [self xxxxWithDirection:isToLeft center:_itemLineView.center.x];
        }
    }
    else
    {
        if (from > toIndex) {
            CGFloat distance = toItem.sn_width * percent;
            
            self.itemLineView.sn_left = fromItem.sn_left - distance;
            [self xxxxWithDirection:isToLeft center:_itemLineView.center.x];
        }
    }
}

- (void) xxxxWithDirection:(BOOL)isToLeft center:(CGFloat)center
{
    CGFloat offsetX = center - self.scrollView.sn_widthHalf;
    
    if (isToLeft) {
        if (offsetX - self.scrollView.contentOffset.x > 50) {
            CGFloat maxOffset = self.scrollView.contentSize.width - self.scrollView.sn_width;
            CGFloat offsetX = MIN(maxOffset, self.scrollView.contentOffset.x + 50);
            [UIView animateWithDuration:0.5 animations:^{
                self.scrollView.contentOffset = CGPointMake(offsetX, 0);
            }];
        }
    }
    else {
        if (offsetX - self.scrollView.contentOffset.x < -50) {
            CGFloat offsetX = MAX(self.scrollView.contentOffset.x - 50, 0);
            [UIView animateWithDuration:0.5 animations:^{
                self.scrollView.contentOffset = CGPointMake(offsetX, 0);
            }];
        }
    }
}

- (void) setScrollViewContentPointWithCenter:(CGFloat)center animated:(BOOL)animated
{
    CGFloat offsetX = center - self.scrollView.sn_widthHalf;
    CGFloat targetX = 0;
    if (offsetX > 0) {
        CGFloat maxOffset = self.scrollView.contentSize.width - self.scrollView.sn_width;
        targetX = MIN(offsetX, maxOffset);
    }
    [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:animated];
}

- (void) selectItemWithIndex:(NSInteger)index animated:(BOOL)animated force:(BOOL)force;
{
    if (_selectedIndex == index && !force) {
        return;
    }
    
    SNTabBarItem *fromItem = _items[_selectedIndex];
    SNTabBarItem *toItem = _items[index];
    
    _selectedIndex = index;
    
    if (fromItem != toItem) {
        [self unselectedWill:fromItem];
    }
    [self selectedWill:toItem];
    
    void (^completion)(BOOL finished)  = ^(BOOL finished)
    {
        if (fromItem != toItem) {
            [self unselectedDid:fromItem];
        }
        [self selectedDid:toItem];
    };
    
    CGRect toFrame = CGRectMake(toItem.sn_left, _itemLineView.sn_top, toItem.sn_width, _itemLineView.sn_height);
    if (animated) {
        [UIView animateWithDuration:0.3f animations:^{
            _itemLineView.frame = toFrame;
        } completion:completion];
    }
    else{
        _itemLineView.frame = toFrame;
        completion(YES);
    }
    
    // set content offset
    [self setScrollViewContentPointWithCenter:toItem.center.x animated:animated];
}

- (void) unselectedWill:(SNTabBarItem*)item
{
    if (item != nil) {
        [item unselectedWill];
        if (_delegate && [_delegate respondsToSelector:@selector(SNTabBar:didDeselectItem:)]) {
            [_delegate SNTabBar:self didDeselectItem:item];
        }
    }
}

- (void) unselectedDid:(SNTabBarItem*)item
{
    if (item != nil) {
        [item unselectedDid];
    }
}

- (void) selectedWill:(SNTabBarItem*)item
{
    if (item != nil) {
        [item selectedWill];
        if (_delegate && [_delegate respondsToSelector:@selector(SNTabBar:didSelectItem:)]) {
            [_delegate SNTabBar:self didSelectItem:item];
        }
    }
}

- (void) selectedDid:(SNTabBarItem*)item
{
    if (item != nil) {
        [item selectedDid];
    }
}


- (void) setTabBarHeight:(CGFloat)tabBarHeight
{
    if (_tabBarHeight == tabBarHeight) {
        return;
    }
    _tabBarHeight = tabBarHeight;
    
    if (_layouted) {
        [self relayout];
    }
}

// 重新布局
- (void) relayout
{
    if (_items.count == 0) {
        return;
    }
    
    int     fixedCount = 0;
    float   fixedWidth = 0;
    
    int     allowSelectedCount = 0;
    
    for (SNTabBarItem *item in _items) {
        allowSelectedCount += item.isAllowSelected ? 1 : 0;
        if (item.fixedWidth > 0) {
            fixedWidth += item.fixedWidth;
            fixedCount += 1;
        }
    }
    
    float itemWidth = 0;
    if (fixedCount > 0) {
        itemWidth = (_items.count - fixedCount) > 0 ? (self. sn_width - fixedWidth) / (_items.count - fixedCount) : 0;
    }
    else{
        itemWidth = self.sn_width / _items.count;
    }
    if (itemWidth < self.minItemWidth) {
        itemWidth = self.minItemWidth;
    }
    
    SNTabBarItem *lastItem = nil;
    for (SNTabBarItem *item in _items) {
        if (item.fixedWidth > 0) {
            item.frame = CGRectMake(lastItem ? lastItem.sn_right : 0, 0, item.fixedWidth, _tabBarHeight);
        }
        else{
            item.frame = CGRectMake(lastItem ? lastItem.sn_right : 0, 0, itemWidth, _tabBarHeight);
        }
        lastItem = item;
    }
    self.scrollView.contentSize = CGSizeMake(lastItem.sn_right, self.scrollView.contentSize.height);
    [self selectItemWithIndex:_selectedIndex animated:NO force:YES];
    
    // item line
    _itemLineView.hidden = (allowSelectedCount <= 1);
    
    _layouted = YES;
}

- (void) dealloc {
    
}

@end

#pragma mark ---------------------------------------------
#pragma mark SNTabBarItem
#pragma mark ---------------------------------------------

@implementation SNTabBarItem
{
}

- (id) initWithTitle:(NSString *)title Target:(id)target action:(SEL)action
{
    if (self = [super init]) {
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:SNTabBarNormalClr.sn_color forState:UIControlStateNormal];
        [self setTitleColor:SNTabBarSelectedClr.sn_color forState:UIControlStateHighlighted];
        [self setTitleColor:SNTabBarSelectedClr.sn_color forState:UIControlStateSelected];
        
        [self _initWithTarget:target acion:action];
    }
    
    return self;
}

- (id) initWithImage:(UIImage *)image Target:(id)target action:(SEL)action
{
    if (self = [super init]) {
        [self setImage:image forState:UIControlStateNormal];
        
        [self _initWithTarget:target acion:action];
    }
    
    return self;
}

- (void) setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    [super setTitleColor:color forState:state];
}

- (void)_initWithTarget:(id)target acion:(SEL)action
{
    _target = target;
    _action = action;
    _isAllowSelected = YES;
    _status = SNTabBarItemStatusNormal;
    
    self.backgroundColor = [UIColor whiteColor];
}

#pragma mark -

- (void) clicked
{
    _status = SNTabBarItemStatusClicked;
    
    if (_target && _action) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_action withObject:self];
#pragma clang diagnostic pop
    }
}

- (void) selectedWill
{
    self.selected = YES;
    
    _status = SNTabBarItemStatusSelected;
    
    if (_target && _action) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_action withObject:self];
#pragma clang diagnostic pop
    }
}

- (void) selectedDid
{
    
}

- (void) unselectedWill
{
    self.selected = NO;
    
    _status = SNTabBarItemStatusNormal;
    
    if (_target && _action) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_action withObject:self];
#pragma clang diagnostic pop
    }
}
- (void) unselectedDid
{
    
}

@end

