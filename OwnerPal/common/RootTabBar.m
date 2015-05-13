//
//  RootTabBar.m
//  HeMicroMall
//
//  Created by NewDoone on 15/2/6.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import "RootTabBar.h"
#import "shareValue.h"

@implementation RootTabBar


- (void)drawRect:(CGRect)rect {

    CGRect bounds=[self bounds];
    [[UIColor colorWithPatternImage:[UIImage imageNamed:@"colorCircle.png"]] set];
    UIRectFill (bounds);
//    self.backgroundImage=[[UIImage imageNamed:@"colorCircle.png"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    self.selectionIndicatorImage=[[UIImage imageNamed:@"tab_sbg.png"] resizableImageWithCapInsets:UIEdgeInsetsZero];
//    [self setTintColor:[UIColor colorWithRed:98/255.0 green:181/255.0 blue:205/255.0 alpha:1.0]];
    self.tintColor=[UIColor whiteColor];
}

@end
