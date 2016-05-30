//
//  SNPageBarContent.h
//  weibang
//
//  Created by sheodon on 16/1/19.
//  Copyright © 2016年 weibang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SNPageBarItem;
@interface SNPageBarContent : UIView

@property (nonatomic, getter=isViewLoaded) BOOL     viewLoaded;
@property (nonatomic, getter=isViewVisible) BOOL    viewVisible;
@property (nonatomic, weak) SNPageBarItem           *barItem;

- (void) viewLoaded;

- (void) viewWillDisappear;
- (void) viewDidDisappear;

- (void) viewWillAppear;
- (void) viewDidAppear;

@end

