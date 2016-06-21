//
//  SNPageBarItem.h
//  SNPageView
//
//  Created by sheodon on 16/1/19.
//  Copyright © 2016年 sheodon. All rights reserved.
//

#import "SNTabBar.h"
#import "SNPageBarContent.h"

@interface SNPageBarItem : SNTabBarItem

@property (nonatomic, strong) SNPageBarContent   *contentView;

@end
