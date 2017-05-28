//
//  SNTabBar.h
//  SNPageView
//
//  Created by sheodon on 16/5/27.
//  Copyright (c) 2016年 sheodon. All rights reserved.
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

+ (void) setSelectedClr:(NSString*)clr;
+ (void) setNormalClr:(NSString*)clr;
+ (void) setBackgroudColor:(NSString*)clr;

@property (nonatomic, readonly) NSMutableArray<SNTabBarItem*>  *items;
/// tabbar 的高度
@property (nonatomic, assign) CGFloat tabBarHeight;
/// default:0.5
@property (nonatomic, assign) CGFloat tabLineWidth;
/// default:4.0
@property (nonatomic, assign) CGFloat tipLineWidth;
/// 当前选中的item
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, weak) id<SNTabBarDelegate> delegate;

/// 最小Item的宽度，当平均宽度小余minItemWidth时采用minItemWidth；default:74
@property (nonatomic, assign) CGFloat   minItemWidth;

///
- (NSUInteger) indexOfItem:(SNTabBarItem*)item;

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
@interface SNTabBarItem : UIButton

- (id) initWithTitle:(NSString*)title Target:(id)target action:(SEL)action;
- (id) initWithImage:(UIImage*)image Target:(id)target action:(SEL)action;

@property (nonatomic, assign)   CGFloat     fixedWidth; // 固定宽度
// 是否允许被选中，默认为YES（当为NO时被点击后触发clicked事件）
@property (nonatomic, assign)   BOOL        isAllowSelected;

@property (nonatomic, weak)   SNTabBar    *tabBar;

@property (nonatomic, weak)   id          target;
@property (nonatomic, assign) SEL         action;
@property (nonatomic, assign) SNTabBarItemStatus status;

- (void) clicked;

- (void) selectedWill;
- (void) selectedDid;

- (void) unselectedWill;
- (void) unselectedDid;


@end
