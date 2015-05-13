//
//  PersonalCenterViewController.m
//  OwnerPal
//
//  Created by NewDoone on 15/4/14.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import "PersonalCenterViewController.h"

@interface PersonalCenterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.saveBtn.layer.cornerRadius=8;
    self.lb_phoneNumber.text=[shareValue shareInstance].employeeTel;
    self.tf_company.text=[shareValue shareInstance].employeeCompany;
    self.tf_name.text=[shareValue shareInstance].employeeName;
    self.tf_address.text=[shareValue shareInstance].employeeAddress;
    // Do any additional setup after loading the view.
}
#pragma UITextField_Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}
- (IBAction)saveAction:(id)sender {
    
    if ([self isValiData]) {
        self.saveBtn.enabled=NO;
        [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        SavePersonInfosRequest* reqeust=[[SavePersonInfosRequest alloc]init];
        NSMutableDictionary* para=[NSMutableDictionary dictionary];
//        [self.tf_name.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [para setObject:self.tf_address.text forKey:@"employeeAddress"];
         [para setObject:self.tf_company.text  forKey:@"employeeCompany"];
         [para setObject: self.tf_name.text forKey:@"employeeName"];
         [para setObject:[shareValue shareInstance].employeeTel forKey:@"employeeTel"];
        NSError* error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:para options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        reqeust.para=[para JSONString];
        reqeust.para=jsonString;
        [SystemAPI SavePersonInfosRequest:reqeust uccess:^(SavePersonInfosResponse *response) {
            self.saveBtn.enabled=YES;
            [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
            [MBProgressHUD showSuccess:response.msg toView:self.view.window];
        } fail:^(BOOL notReachable, NSString *desciption) {
            self.saveBtn.enabled=YES;
             [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
            [MBProgressHUD showError:desciption toView:self.view.window];
           
        }];
    }
}
-(BOOL)isValiData{
    if (self.tf_name.text.length==0) {
        [MBProgressHUD showError:@"请输入姓名!" toView:self.view.window];
        return NO;
    }
    if (self.tf_company.text.length==0) {
        [MBProgressHUD showError:@"请输入物流公司!" toView:self.view.window];
        return NO;
    }
    if (self.tf_address.text.length==0) {
        [MBProgressHUD showError:@"请输入地址!" toView:self.view.window];
        return NO;
    }
    return YES;
}
@end
