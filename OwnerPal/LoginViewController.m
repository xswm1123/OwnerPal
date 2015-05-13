//
//  LoginViewController.m
//  OwnerPal
//
//  Created by NewDoone on 15/4/13.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *checkView;
@property (weak, nonatomic) IBOutlet UITextField *tf_phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *tf_checkNumber;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property(nonatomic,strong) NSTimer * timer;

@end
static NSUInteger count=60;
@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
-(void)initView{
    self.checkView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.0];
    self.checkBtn.titleLabel.text=@"短信验证";
    [self.checkBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
//    self.tf_checkNumber.delegate=self;
//    self.tf_phoneNumber.delegate=self;
    self.checkBtn.layer.cornerRadius=3;
    self.loginBtn.layer.cornerRadius=3;
    self.tf_checkNumber.layer.borderColor=[UIColor whiteColor].CGColor;
    self.tf_checkNumber.layer.borderWidth=1.5;
    self.tf_checkNumber.backgroundColor=[UIColor whiteColor];
}
- (IBAction)dismissKeyBoard:(id)sender {
    [self.tf_checkNumber resignFirstResponder];
    [self.tf_phoneNumber resignFirstResponder];
    NSLog(@"dismissKeyBoard");
}
#pragma UITextField_Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    if (textField.text.length>=6&&textField==self.tf_checkNumber) {
        return NO;
    }
    
    return YES;
}
-(BOOL)isRightNumber{
    BOOL isRight = false;
    if (self.tf_phoneNumber.text.length==0) {
        [MBProgressHUD showError:@"手机号码不能为空!" toView:self.view.window];
        isRight=NO;
    }else{
        if (self.tf_phoneNumber.text.length==11) {
            isRight=YES;
        }else{
            [MBProgressHUD showError:@"请输入正确的手机号码!" toView:self.view.window];
            isRight=NO;
        }
    }
    return isRight;
}
-(BOOL)isRightCheckNumberAndPhoneNumber{
    BOOL isRight = true;
    if (self.tf_phoneNumber.text.length==0) {
        [MBProgressHUD showError:@"手机号码不能为空!" toView:self.view.window];
        return NO;
    }
    
        if (self.tf_phoneNumber.text.length!=11) {
            [MBProgressHUD showError:@"请输入正确的手机号码!" toView:self.view.window];
            return NO;
        }
    

    if (self.tf_checkNumber.text.length==0) {
        [MBProgressHUD showError:@"验证码不能为空!" toView:self.view.window];
        return NO;
    }
    
    return isRight;
}
- (IBAction)loginAction:(id)sender {
//  [self showMainPage];
//     [shareValue shareInstance].employeeTel=@"18780052973";
    if ([self isRightCheckNumberAndPhoneNumber]) {
        LoginRequest* request=[[LoginRequest alloc]init];
        request.employeeTel=self.tf_phoneNumber.text;
        request.authCode=self.tf_checkNumber.text;
        [SystemAPI loginRequest:request success:^(LoginResponse * response) {
            NSMutableDictionary* dic=response.body;
            [shareValue shareInstance].employeeAddress=[dic objectForKey:@"employeeAddress"];
            [shareValue shareInstance].employeeCompany=[dic objectForKey:@"employeeCompany"];
            [shareValue shareInstance].employeeName=[dic objectForKey:@"employeeName"];
            [shareValue shareInstance].employeeTel=[dic objectForKey:@"employeeTel"];
            [self showMainPage];
        } fail:^(BOOL NotReachable, NSString * desciption) {
            NSLog(@"desciption:%@",desciption);
            [MBProgressHUD showError:desciption toView:self.view.window];
        }];
    }
    
}
-(void)showMainPage{
    UIStoryboard* storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* vc=[storyBoard instantiateViewControllerWithIdentifier:@"main"];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}
- (IBAction)getCheckMessage:(id)sender {
    count=60;
    
    BOOL isRight=[self isRightNumber];
//    BOOL isRight=YES;
    
    if (isRight) {
        self.checkBtn.enabled=NO;
        GetCheckMessageRequest* request=[[GetCheckMessageRequest alloc]init];
        request.employeeTel= self.tf_phoneNumber.text;
        [SystemAPI getCheckMessageRequest:request success:^(GetCheckMessageResponse *response) {
            NSLog(@"请求成功!!!");
            
            [MBProgressHUD showSuccess:@"验证码发送成功" toView:self.view.window];
            self.checkBtn.enabled=NO;
            self.checkBtn.titleLabel.text=[NSString stringWithFormat:@"获取中(%ld)",(unsigned long)count];
            
            self.timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTitle) userInfo:nil repeats:YES];
            
        } fail:^(BOOL notReachable, NSString *desciption) {
            NSLog(@"error=====%@",desciption);
            [MBProgressHUD showError:desciption toView:self.view.window];
            [self.timer invalidate];
            self.checkBtn.enabled=YES;
            self.checkBtn.titleLabel.font=[UIFont systemFontOfSize:12.0];
            self.checkBtn.titleLabel.text=@"短信验证";
            NSLog(@"请求失败!!!");
        }];
        
    }

    
}
-(void)changeTitle{
    self.checkBtn.titleLabel.text=[NSString stringWithFormat:@"获取中(%ld)",(unsigned long)count];
    count--;
    if (count==0) {
        [self.timer invalidate];
        self.checkBtn.enabled=YES;
        self.checkBtn.titleLabel.font=[UIFont systemFontOfSize:12.0];
        self.checkBtn.titleLabel.text=@"短信验证";
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [self.timer invalidate];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDisappear:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardAppear:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect frame;
    CGFloat distance;
    CGFloat yLocation=0;
    if (keyboardFrame.origin.y<self.checkView.frame.origin.y+self.checkView.frame.size.height) {
        distance=self.checkView.frame.origin.y+self.checkView.frame.size.height-keyboardFrame.origin.y;
        yLocation=self.view.frame.origin.y-distance;
    }
    frame=CGRectMake(0, yLocation, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    UIViewAnimationOptions options = [userInfo[UIKeyboardAnimationCurveUserInfoKey]unsignedIntegerValue];
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.view.frame=frame;
    } completion:^(BOOL bl){
    }];
}
- (void)keyboardDisappear:(NSNotification *)notification
{
    CGRect frame = self.view.frame;
    frame.origin.y = self.view.bounds.size.height - frame.size.height - self.bottomLayoutGuide.length;
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    UIViewAnimationOptions options = [userInfo[UIKeyboardAnimationCurveUserInfoKey]unsignedIntegerValue];
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.view.frame = frame;
    } completion:nil];
}


@end
