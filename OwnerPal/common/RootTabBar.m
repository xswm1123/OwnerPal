//
//  RootTabBar.m
//  HeMicroMall
//
//  Created by NewDoone on 15/2/6.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import "RootTabBar.h"
#import "shareValue.h"
#import "UIImage+UIImageExtras.h"

@implementation RootTabBar


- (void)drawRect:(CGRect)rect {

    CGRect bounds=[self bounds];
    [[UIColor colorWithPatternImage:[UIImage imageNamed:@"colorCircle.png"]] set];
    UIRectFill (bounds);
//    UIImage* image=[UIImage imageNamed:@"tab_sbg.png"];
//    CGSize imagesize=CGSizeMake(180, 49.0);
//    self.selectionIndicatorImage=[image imageByScalingToSize:imagesize];
//    self.selectionIndicatorImage=[[UIImage imageNamed:@"tab_sbg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
//        self.selectionIndicatorImage=[UIImage imageNamed:@"tab_sbg.png"];
    self.tintColor=[UIColor whiteColor];
    
}

@end
