//
//  ShowCreateResultPageViewController.m
//  OwnerPal
//
//  Created by NewDoone on 15/4/29.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import "ShowCreateResultPageViewController.h"

@interface ShowCreateResultPageViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (nonatomic,strong) NSTimer * countDownTimer;
@property (nonatomic,assign) NSInteger count;
@end


@implementation ShowCreateResultPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.count=5;
    self.backBtn.titleLabel.text=[NSString stringWithFormat:@"返回(%lds)",(unsigned long)self.count];
    self.countDownTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeBtnTitle) userInfo:nil repeats:YES];
}

- (IBAction)backAction:(id)sender {
    [self.countDownTimer invalidate];
    self.countDownTimer=nil;
    self.backBtn.titleLabel.text=@"返回(5s)";
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)changeBtnTitle{
    self.backBtn.titleLabel.text=[NSString stringWithFormat:@"返回(%lds)",(unsigned long)self.count];
    self.count--;
    if (self.count==-1) {
        [self.countDownTimer invalidate];
        self.countDownTimer=nil;
        self.backBtn.titleLabel.text=[NSString stringWithFormat:@"返回"];
       [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated{

    [self.countDownTimer invalidate];
    self.countDownTimer=nil;
}
@end
