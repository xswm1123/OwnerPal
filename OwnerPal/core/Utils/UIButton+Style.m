//
//  UIButton+Style.m
//  xsgj
//
//  Created by mac on 14-7-17.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "UIButton+Style.h"

@implementation UIButton(Style)

-(void)configBlueStyle:(NSInteger)type
{
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    if (type == 1)
    {
        [self setBackgroundImage:[UIImage imageNamed:@"CommonBtn_nor"] forState:UIControlStateNormal];
    }
    else
    {
//        [self setBackgroundImage:IMG_BTN_BLUE forState:UIControlStateNormal];
//        [self setBackgroundImage:IMG_BTN_BLUE_S forState:UIControlStateHighlighted];
    }
}

-(void)configOrgleStyle:(NSInteger)type
{
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    if (type == 1)
    {
        [self setBackgroundImage:[UIImage imageNamed:@"bg_BtnLogin_nor"] forState:UIControlStateNormal];
    }
    else
    {
//        [self setBackgroundImage:IMG_BTN_ORGLE forState:UIControlStateNormal];
//        [self setBackgroundImage:IMG_BTN_ORGLE_S forState:UIControlStateHighlighted];
    }
}
@end
