//
//  SNTabBar.h
//  Help_Help
//
//  Created by admin on 14/12/15.
//  Copyright (c) 2014年 TangYanQiong. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    SNTabBarItemStatusNormal,
    SNTabBarItemStatusSelected,
    SNTabBarItemStatusClicked,
}SNTabBarItemStatus;

@class SNTabBar;
@class SNTabBarItem;

@protocol SNTabBarDelegate <NSObject>

@optional
/// called when a new item is selected by the user
- (void)SNTabBar:(SNTabBar *)tabBar didSelectItem:(SNTabBarItem *)item;

- (void)SNTabBar:(SNTabBar *)tabBar didDeselectItem:(SNTabBarItem *)item;

- (void)SNTabBar:(SNTabBar *)tabBar didClickItem:(SNTabBarItem*)item;

@end


@interface SNTabBar : UIView

@property (nonatomic, readonly) NSMutableArray<SNTabBarItem*>  *items;
/// tabbar 的高度
@property (nonatomic, assign) CGFloat tabBarHeight;
/// 默认2.0
@property (nonatomic, assign) CGFloat tabLineWidth;
/// 默认3.0f
@property (nonatomic, assign) CGFloat tipLineWidth;
/// 当前选中的item
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, weak) id<SNTabBarDelegate> delegate;

/// 添加 item
- (void) addItem:(SNTabBarItem*)item;
/// 插入 item
- (void) addItem:(SNTabBarItem*)item atIndex:(NSUInteger)index;

/// 移除 item
- (void) removeItem:(SNTabBarItem*)item;
/// 移除 item
- (void) removeItemAtIndex:(NSUInteger)index;

/// 重新布局
- (void) relayout;

- (void) selectItemWithIndex:(NSInteger)index animated:(BOOL)animated force:(BOOL)force;

- (void) setTipLineLocatitonFromIndex:(NSInteger)from toIndex:(NSInteger)toIndex percent:(CGFloat)percent direction:(BOOL)isToLeft;

@end


#pragma mark ---------------------------------------------
#pragma mark SNTabBarItem
#pragma mark ---------------------------------------------
@interface SNTabBarItem : UIView

- (id) initWithTitle:(NSString*)title Target:(id)target action:(SEL)action;
- (id) initWithImage:(UIImage*)image Target:(id)target action:(SEL)action;

@property (nonatomic, readonly) UILabel     *titleLabel;
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, assign)   CGFloat     fixedWidth; // 固定宽度
// 是否允许被选中，默认为YES（当为NO时被点击后触发clicked事件）
@property (nonatomic, assign)   BOOL        isAllowSelected;

@property (nonatomic, assign)   SNTabBar    *tabBar;

@property (nonatomic, assign)   id          target;
@property (nonatomic, assign)   SEL         action;
@property (nonatomic, assign)   SNTabBarItemStatus status;

- (void) clicked;

- (void) selectedWill;
- (void) selectedDid;

- (void) unselectedWill;
- (void) unselectedDid;


@end