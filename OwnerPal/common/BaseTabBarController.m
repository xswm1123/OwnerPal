//
//  BaseTabBarController.m
//  OwnerPal
//
//  Created by NewDoone on 15/4/14.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import "BaseTabBarController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:backView atIndex:0];
//    [self.tabBar insertSubview:backView atIndex:1000000];
    self.tabBar.opaque = YES;
//   self.tabBar.backgroundColor=[UIColor colorWithRed:79/255.0 green:95/255.0 blue:112/255.0 alpha:1.0];
    self.tabBar.backgroundImage=[UIImage imageNamed:@"colorCircle.png"];
    self.tabBar.selectionIndicatorImage=[UIImage imageNamed:@"test.png"];
    
}

@end
