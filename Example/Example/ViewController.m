//
//  ViewController.m
//  SNPageView
//
//  Created by sheodon on 16/5/30.
//  Copyright © 2016年 sheodon. All rights reserved.
//

#import "ViewController.h"
#import "SNPageBar.h"
#import "UIView+SNFrameTransform.h"
#import "TestPageView_View1.h"
#import "TestPageView_View2.h"
#import "TestPageView_View3.h"
#import "TestPageView_View4.h"
#import "TestLoopPageView.h"

#define kPageBarHeight 40

@interface ViewController ()

@property (nonatomic, strong) TestLoopPageView *loopView;

@property (nonatomic, strong) SNPageBar *pageBar;


@end

@implementation ViewController

#pragma mark 循环Tab
- (UIBarButtonItem*) repeatTabItem
{
    return [UIBarButtonItem.alloc initWithTitle:@"循环Tab" style:UIBarButtonItemStylePlain target:self action:@selector(handleRepeatTab)];
}

- (UIBarButtonItem*) noRepeatTabItem
{
    return [UIBarButtonItem.alloc initWithTitle:@"不循环Tab" style:UIBarButtonItemStylePlain target:self action:@selector(handleNoRepeatTab)];
}

- (void) handleRepeatTab
{
    self.pageBar.pageView.repeatScroll = YES;
    
    self.navigationItem.rightBarButtonItem = [self noRepeatTabItem];
}

- (void) handleNoRepeatTab
{
    self.pageBar.pageView.repeatScroll = NO;
    
    self.navigationItem.rightBarButtonItem = [self repeatTabItem];
}

#pragma mark loop page
- (UIBarButtonItem*) repeatLoopPage
{
    return [UIBarButtonItem.alloc initWithTitle:@"autoLoopPage" style:UIBarButtonItemStylePlain target:self action:@selector(handleLoopPage)];
}

- (UIBarButtonItem*) noRepeatLoopPage
{
    return [UIBarButtonItem.alloc initWithTitle:@"noAutoLoopPage" style:UIBarButtonItemStylePlain target:self action:@selector(handleNoLoopPage)];
}
- (void) handleLoopPage
{
    [self.loopView resumeLoopScroll];
    
    self.navigationItem.leftBarButtonItem = [self noRepeatLoopPage];
}

- (void) handleNoLoopPage
{
    [self.loopView suspendLoopScroll];
    
    self.navigationItem.leftBarButtonItem = [self repeatLoopPage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor brownColor];
    self.navigationItem.rightBarButtonItem = [self repeatTabItem];
    self.navigationItem.leftBarButtonItem = [self noRepeatLoopPage];
    self.navigationItem.title = @"PageView";
    
    self.view.autoresizesSubviews = YES;
    [self buildLoopPageView];
    
    [self buildPageViewBar];
}

- (void) buildLoopPageView
{
    self.loopView = [TestLoopPageView.alloc initWithFrame:CGRectMake(0, 60, self.view.sn_width, 100)];
    self.loopView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.loopView];
}

#pragma mark Tab PageView
- (void) buildPageViewBar
{
    CGFloat kTopSide = self.loopView.sn_bottom + 20;
    
    CGFloat kPageContentHeight = self.view.sn_height - kTopSide - kPageBarHeight;
    
    // 设置TabBar 高度
    self.pageBar = [SNPageBar.alloc initWithFrame:CGRectMake(0, kTopSide, self.view.sn_width, kPageBarHeight)];
    self.pageBar.minItemWidth = 90;
    self.pageBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.pageBar];
    
    CGRect contentFrame = CGRectMake(0, 0, _pageBar.sn_width, kPageContentHeight);
    
    TestPageView_View1 *view1 = [TestPageView_View1.alloc initWithFrame:contentFrame];
    
    SNPageBarItem *item1 = [self newPageItemWithContentView:view1 index:@"1"];
    item1.contentView.backgroundColor = [UIColor darkGrayColor];
    [_pageBar addItem:item1];
    
    TestPageView_View2 *view2 = [TestPageView_View2.alloc initWithFrame:contentFrame];
    SNPageBarItem *item2 = [self newPageItemWithContentView:view2 index:@"2"];
    item2.contentView.backgroundColor = [UIColor redColor];
    [_pageBar addItem:item2];
    
    TestPageView_View3 *view3 = [TestPageView_View3.alloc initWithFrame:contentFrame];
    SNPageBarItem *item3 = [self newPageItemWithContentView:view3 index:@"3"];
    item3.isAllowSelected = NO;
    item3.contentView.backgroundColor = [UIColor blueColor];
    [_pageBar addItem:item3];
    
    TestPageView_View4 *view4 = [TestPageView_View4.alloc initWithFrame:contentFrame];
    SNPageBarItem *item4 = [self newPageItemWithContentView:view4 index:@"4"];
    item4.contentView.backgroundColor = [UIColor greenColor];
    [_pageBar addItem:item4];
    
    TestPageView_View4 *view5 = [TestPageView_View4.alloc initWithFrame:contentFrame];
    SNPageBarItem *item5 = [self newPageItemWithContentView:view5 index:@"5"];
    item5.contentView.backgroundColor = [UIColor greenColor];
    [_pageBar addItem:item5];
    
    TestPageView_View4 *view6 = [TestPageView_View4.alloc initWithFrame:contentFrame];
    SNPageBarItem *item6 = [self newPageItemWithContentView:view6 index:@"6"];
    item6.contentView.backgroundColor = [UIColor greenColor];
    [_pageBar addItem:item6];
    
    [_pageBar relayout];
}

- (void) viewWillLayoutSubviews
{
    CGFloat kTopSide = self.loopView.sn_bottom + 20;
    CGFloat contentHeight = self.view.sn_height - kTopSide - kPageBarHeight;
    if (_pageBar) {
        for (SNPageBarItem *item in _pageBar.items) {
            item.contentView.sn_size = CGSizeMake(self.pageBar.sn_width, contentHeight);
        }
    }
}

- (SNPageBarItem*) newPageItemWithContentView:(SNPageBarContent*)contentView index:(NSString*)index
{
    SNPageBarItem *item = [SNPageBarItem.alloc initWithTitle:[NSString stringWithFormat:@"标题%@", index] Target:nil action:nil];
    item.contentView = contentView;
    UILabel *label = [UILabel.alloc initWithFrame:CGRectMake(0, 0, 100, 100)];
    label.text = [NSString stringWithFormat:@"页面%@", index];
    label.textAlignment = NSTextAlignmentCenter;
    label.sn_position_m_m = CGPointMake(contentView.sn_widthHalf, contentView.sn_heightHalf);
    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    [contentView addSubview:label];
    return item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.loopView resumeLoopScroll];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.loopView suspendLoopScroll];
}

@end
