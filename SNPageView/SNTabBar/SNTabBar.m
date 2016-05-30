//
//  SNTabBar.m
//  Help_Help
//
//  Created by admin on 14/12/15.
//  Copyright (c) 2014年 TangYanQiong. All rights reserved.
//

#import "SNTabBar.h"
#import "NSString+SNColor.h"
#import "UIView+SNFrameTransform.h"

#define kTabViewTag 2020
#define kTabLabelTag 2000
#define kTipImageViewTag 2010
#define kTabViewLineTag 2030

static NSString *const kSNCommonClr = @"45c01a";
static NSString *const kSNBlackClr = @"404040";


#pragma mark SNTabBar interface
@interface SNTabBar ()

@property (nonatomic, assign) BOOL  layouted;

@end

#pragma mark SNTabBarItem interface
@interface SNTabBarItem ()

@end

#pragma mark SNTabBar implementation
@implementation SNTabBar
{
    UIView  *_itemLineView;
    
    NSMutableArray *_buttons;
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
    _buttons = [NSMutableArray array];
    
    CGSize size = self.frame.size;
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.tabLineWidth = 0.5;
    self.tipLineWidth = 4.0;
    
    // 标签底线
    _itemLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, _tabBarHeight-_tipLineWidth, 0.0f, _tipLineWidth)];
    _itemLineView.backgroundColor = kSNCommonClr.color;
    _itemLineView.layer.zPosition = MAXFLOAT;
    [self addSubview:_itemLineView];
    
    // tab底线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, _tabBarHeight-_tabLineWidth, size.width, _tabLineWidth)];
    lineView.backgroundColor = kSNCommonClr.color;
    lineView.layer.zPosition = MAXFLOAT;
    [self addSubview:lineView];
}

- (void) addItem:(SNTabBarItem *)item
{
    [self addSubview:item];
    [_items addObject:item];
    item.tabBar = self;
    
    UIButton *button = [self _buildItemButton];
    
    [self addSubview:button];
    [_buttons addObject:button];
    
    if (_layouted) {
        [self relayout];
    }
}

/// 插入 item
- (void) addItem:(SNTabBarItem*)item atIndex:(NSUInteger)index;
{
    // 安全处理
    index = MIN(index, _items.count);
    
    [self addSubview:item];
    [_items insertObject:item atIndex:index];
    item.tabBar = self;
    
    UIButton *button = [self _buildItemButton];
    
    [self addSubview:button];
    [_buttons insertObject:button atIndex:index];
    
    if (index <= _selectedIndex) {
        _selectedIndex += 1;
    }
    
    if (_layouted) {
        [self relayout];
    }
}

- (UIButton*)_buildItemButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(_onItemTouchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(_onItemDragInside:) forControlEvents:UIControlEventTouchDragInside];
    [button addTarget:self action:@selector(_onItemDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
    [button addTarget:self action:@selector(_onItemTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(_onItemTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    return button;
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
    
    UIButton *button = _buttons[index];
    [button removeFromSuperview];
    
    [_items removeObjectAtIndex:index];
    [_buttons removeObjectAtIndex:index];
    
    _selectedIndex = MIN(_selectedIndex, _buttons.count - 1);
    
    if (_layouted) {
        [self relayout];
    }
}

- (void) _onItemTouchUpInside:(UIButton*)sender
{
    SNTabBarItem *item = _items[sender.tag];
    if (item.isAllowSelected) {
        [self selectItemWithIndex:sender.tag animated:YES force:NO];
    }
    else{
        [item clicked];
        if (_delegate && [_delegate respondsToSelector:@selector(SNTabBar:didClickItem:)]) {
            [_delegate SNTabBar:self didClickItem:item];
        }
        if (item.titleLabel) {
            item.titleLabel.highlighted = NO;
        }
    }
}

- (void) _onItemTouchUpOutside:(UIButton*)sender
{
    SNTabBarItem *item = _items[sender.tag];
    if (!item.isAllowSelected && item.titleLabel) {
        item.titleLabel.highlighted = NO;
    }
}

- (void) _onItemDragInside:(UIButton*)sender
{
    SNTabBarItem *item = _items[sender.tag];
    if (!item.isAllowSelected && item.titleLabel) {
        item.titleLabel.highlighted = YES;
    }
}

- (void) _onItemDragOutside:(UIButton*)sender
{
    SNTabBarItem *item = _items[sender.tag];
    if (!item.isAllowSelected && item.titleLabel) {
        item.titleLabel.highlighted = NO;
    }
}

- (void) _onItemTouchDown:(UIButton*)sender
{
    SNTabBarItem *item = _items[sender.tag];
    if (!item.isAllowSelected && item.titleLabel) {
        item.titleLabel.highlighted = YES;
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
            
            _itemLineView.sn_left = fromItem.sn_left + distance;
        }
    }
    else
    {
        if (from > toIndex) {
            CGFloat distance = toItem.sn_width * percent;
            
            _itemLineView.sn_left = fromItem.sn_left - distance;
        }
    }
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
    
    CGRect lineFrame = _itemLineView.frame;
    CGRect itemFrame = toItem.frame;
    CGRect toFrame = CGRectMake(itemFrame.origin.x, lineFrame.origin.y, itemFrame.size.width, lineFrame.size.height);
    if (animated) {
        [UIView animateWithDuration:0.3f animations:^{
            _itemLineView.frame = toFrame;
        } completion:^(BOOL finished) {
            if (fromItem != toItem) {
                [self unselectedDid:fromItem];
            }
            [self selectedDid:toItem];
        }];
    }
    else{
        _itemLineView.frame = toFrame;
        if (fromItem != toItem) {
            [self unselectedDid:fromItem];
        }
        [self selectedDid:toItem];
    }
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
        itemWidth = (_items.count - fixedCount) > 0 ? (self.frame.size.width - fixedWidth) / (_items.count - fixedCount) : 0;
    }
    else{
        itemWidth = self.frame.size.width / _items.count;
    }
    
    float posx = 0;
    for (int index = 0; index < _items.count; ++index) {
        SNTabBarItem *item = _items[index];
        UIButton *button = _buttons[index];
        if (item.fixedWidth > 0) {
            item.frame = CGRectMake(posx, 0, item.fixedWidth, _tabBarHeight);
            posx += item.fixedWidth;
        }
        else{
            item.frame = CGRectMake(posx, 0, itemWidth, _tabBarHeight);
            posx += itemWidth;
        }
        button.frame = item.frame;
        
        button.tag = index;
        item.tag = index;
    }
    
    [self selectItemWithIndex:_selectedIndex animated:NO force:YES];
    
    // item line
    _itemLineView.hidden = (allowSelectedCount <= 1);
    
    _layouted = YES;
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
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = title;
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = kSNBlackClr.color;
        _titleLabel.highlightedTextColor = kSNCommonClr.color;
        [self addSubview:_titleLabel];
        
        [self _initWithTarget:target acion:action];
    }
    
    return self;
}

- (id) initWithImage:(UIImage *)image Target:(id)target action:(SEL)action
{
    if (self = [super init]) {
        _imageView = [[UIImageView alloc] initWithImage:image];
        
        [self addSubview:_imageView];
        
        [self _initWithTarget:target acion:action];
    }
    
    return self;
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

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_titleLabel) {
        _titleLabel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    if (_imageView) {
        _imageView.center = CGPointMake(frame.size.width*0.5, frame.size.height*0.5);
    }
}

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
    if (_titleLabel) {
        _titleLabel.highlighted = YES;
    }
    
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
    if (_titleLabel) {
        _titleLabel.highlighted = NO;
    }
    
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

