//
//  TestLoopPageView.m
//  Example
//
//  Created by sheodon on 16/5/31.
//  Copyright © 2016年 sheodon. All rights reserved.
//

#import "TestLoopPageView.h"
#import "UIView+SNFrameTransform.h"

@interface TestLoopPageView ()<SNPageViewDelegate>

@property (nonatomic, strong) NSMutableArray        *tableItems;

@property (nonatomic, strong) UIPageControl         *pageControl;

@property (nonatomic, strong) NSTimer   *timer;

@end

@implementation TestLoopPageView

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _initTestLoopPageView];
    }
    
    return self;
}

- (void) _initTestLoopPageView
{
    self.backgroundColor = [UIColor lightGrayColor];
    self.tableItems = [NSMutableArray array];
    
    self.delegate = self;
    self.repeatScroll = YES;
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.sn_height - 20, self.sn_width, 20)];
    self.pageControl.numberOfPages = [self sn_pageViewForPageNumbers:self];
    self.pageControl.userInteractionEnabled = NO;
    [self addSubview:self.pageControl];
    
    self.pageControl.sn_size = [self.pageControl sizeForNumberOfPages:[self sn_pageViewForPageNumbers:self]];
    self.pageControl.sn_position_1_m = CGPointMake(self.sn_width - 20, self.sn_height - 16);

    [self buildTablItems];
}

- (void) buildTablItems
{
    [self.tableItems addObject:@"1"];
    [self.tableItems addObject:@"2"];
    [self.tableItems addObject:@"3"];
    [self.tableItems addObject:@"4"];
    [self.tableItems addObject:@"5"];
    [self.tableItems addObject:@"6"];
    [self reloadData];
}

- (void) _beginTimer
{
    if (_timer && [_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
    
    if (self.currentIndex == ([self sn_pageViewForPageNumbers:self] - 1)) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(_timerExecuteNext) userInfo:nil repeats:NO];
    }
    else {
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(_timerExecuteNext) userInfo:nil repeats:NO];
    }
}

- (void) _timerExecuteNext
{
    [self scrollToPageAtIndex:self.currentIndex + 1 animated:YES];
    
    [self _beginTimer];
}

- (void) resumeLoopScroll
{
    [self _beginTimer];
}

- (void) suspendLoopScroll
{
    if (_timer && [_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark SNPageViewDelegate
- (NSInteger) sn_pageViewForPageNumbers:(SNPageView *)pageView
{
    NSInteger numbers = self.tableItems.count + 1;
    if (self.pageControl.numberOfPages != numbers) {
        self.pageControl.numberOfPages = numbers;
        
        self.pageControl.sn_size = [self.pageControl sizeForNumberOfPages:[self sn_pageViewForPageNumbers:self]];
        self.pageControl.sn_position_1_m = CGPointMake(self.sn_width - 20, self.sn_height - 16);
    }
    return numbers;
}

- (UIView*) sn_pageView:(SNPageView *)pageView viewAtIndex:(NSInteger)index
{
    UIView *view = [UIView.alloc initWithFrame:pageView.bounds];
    
    UILabel *lbl = [UILabel.alloc initWithFrame:CGRectMake(0, 0, view.sn_width, view.sn_height)];
    lbl.text = [NSString stringWithFormat:@"page view : %ld", (long)index];
    lbl.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lbl];
    
    return view;
}

- (void) sn_pageView:(SNPageView *)pageView itemDidAppear:(SNPageViewItem *)item
{
    [self _beginTimer];
    
    self.pageControl.currentPage = item.index;
}

@end
