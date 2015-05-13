//
//  BaseViewController.m
//  HeMicroMall
//
//  Created by NewDoone on 15/2/16.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
//    UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyBoard)];
//    [self.view addGestureRecognizer:tap];
//    UIControl* con=(UIControl*)self.view;
//    [con addTarget:self action:@selector(resignKeyBoard) forControlEvents:UIControlEventEditingDidEndOnExit];
}
//-(void)resignKeyBoard{
//    [self.view resignFirstResponder];
//}
#pragma UITextField_Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}
@end
