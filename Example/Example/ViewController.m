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

@interface ViewController ()

@property (nonatomic, strong) SNPageBar *pageBar;


@end

@implementation ViewController

- (UIBarButtonItem*) repeatItem
{
    return [UIBarButtonItem.alloc initWithTitle:@"循环" style:UIBarButtonItemStylePlain target:self action:@selector(handleRepeat)];
}

- (UIBarButtonItem*) noRepeatItem
{
    return [UIBarButtonItem.alloc initWithTitle:@"不循环" style:UIBarButtonItemStylePlain target:self action:@selector(handleNoRepeat)];
}

- (void) handleRepeat
{
    self.pageBar.pageView.repeatScroll = YES;
    
    self.navigationItem.leftBarButtonItem = [self noRepeatItem];
}

- (void) handleNoRepeat
{
    self.pageBar.pageView.repeatScroll = NO;
    
    self.navigationItem.leftBarButtonItem = [self repeatItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor brownColor];
    self.navigationItem.leftBarButtonItem = [self repeatItem];
    self.navigationItem.title = @"PageView";
    
    CGFloat kTopSide = 60;
    
    CGFloat kPageBarHeight = 40;
    CGFloat kPageContentHeight = self.view.sn_height - kTopSide - kPageBarHeight;
    
    // 设置TabBar 高度
    self.pageBar = [SNPageBar.alloc initWithFrame:CGRectMake(0, kTopSide, self.view.sn_width, kPageBarHeight)];
    
    [self.view addSubview:self.pageBar];
    
    TestPageView_View1 *view1 = [TestPageView_View1.alloc initWithFrame:CGRectMake(0, 0, _pageBar.sn_width, kPageContentHeight)];
    
    SNPageBarItem *item1 = [self newPageItemWithContentView:view1 index:@"1"];
    item1.contentView.backgroundColor = [UIColor darkGrayColor];
    [_pageBar addItem:item1];
    
    TestPageView_View2 *view2 = [TestPageView_View2.alloc initWithFrame:CGRectMake(0, 0, _pageBar.sn_width, kPageContentHeight)];
    SNPageBarItem *item2 = [self newPageItemWithContentView:view2 index:@"2"];
    item2.contentView.backgroundColor = [UIColor redColor];
    [_pageBar addItem:item2];
    
    TestPageView_View3 *view3 = [TestPageView_View3.alloc initWithFrame:CGRectMake(0, 0, _pageBar.sn_width, kPageContentHeight)];
    SNPageBarItem *item3 = [self newPageItemWithContentView:view3 index:@"3"];
    item3.contentView.backgroundColor = [UIColor blueColor];
    [_pageBar addItem:item3];
    
    TestPageView_View4 *view4 = [TestPageView_View4.alloc initWithFrame:CGRectMake(0, 0, _pageBar.sn_width, kPageContentHeight)];
    SNPageBarItem *item4 = [self newPageItemWithContentView:view4 index:@"4"];
    item4.contentView.backgroundColor = [UIColor greenColor];
    [_pageBar addItem:item4];
    
    [_pageBar relayout];
}

- (SNPageBarItem*) newPageItemWithContentView:(SNPageBarContent*)contentView index:(NSString*)index
{
    SNPageBarItem *item = [SNPageBarItem.alloc initWithTitle:[NSString stringWithFormat:@"标题%@", index] Target:nil action:nil];
    item.contentView = contentView;
    UILabel *label = [UILabel.alloc initWithFrame:CGRectMake(0, 0, 100, 100)];
    label.text = [NSString stringWithFormat:@"页面%@", index];
    label.textAlignment = NSTextAlignmentCenter;
    label.sn_position_m_m = CGPointMake(contentView.sn_widthHalf, contentView.sn_heightHalf);
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
}

@end
