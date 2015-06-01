//
//  BaseTabBarController.m
//  OwnerPal
//
//  Created by NewDoone on 15/4/14.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import "BaseTabBarController.h"
#import "UIImage+UIImageExtras.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage* image=[UIImage imageNamed:@"tab_sbg.png"];
    CGSize imagesize=CGSizeMake(120, 49.0);
    self.tabBar.selectionIndicatorImage=[image imageByScalingToSize:imagesize];
    /**
     *  rebuild the tabbar frame
     */
    CGRect frame = self.tabBar.frame;
    frame.origin.x = -6;
    frame.size.width = frame.size.width+12;
    self.tabBar.frame = frame;
    
}

@end
