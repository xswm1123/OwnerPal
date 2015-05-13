//
//  FieldDetailsInfoViewController.m
//  OwnerPal
//
//  Created by NewDoone on 15/4/20.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import "FieldDetailsInfoViewController.h"
#import "SelectPeopleListViewController.h"


@interface FieldDetailsInfoViewController ()<SelectedPeopleDelegate>

@end

@implementation FieldDetailsInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
-(void)initView{
    self.confirmBtn.layer.cornerRadius=5;
    self.tf_receiveName.text=self.commenBean.shxm;
    self.tf_phoneNumber.text=self.commenBean.shdh;
    self.tf_address.text=self.commenBean.shdz;
    self.tf_goodName.text=self.commenBean.hw;
    self.tf_summary.text=self.commenBean.summary;
    self.tf_goodVolum.text=self.commenBean.tj;
    self.tf_goodWeight.text=self.commenBean.zl;
}
- (IBAction)selectReceiverAction:(id)sender {
    [self performSegueWithIdentifier:@"selectPeople" sender:nil];
}

- (IBAction)confirmAction:(id)sender {
    OrderDetailsBean* bean=[[OrderDetailsBean alloc]init];
    bean.shxm=self.tf_receiveName.text;
    bean.shdh=self.tf_phoneNumber.text;
    bean.shdz=self.tf_address.text;
    bean.hw=self.tf_goodName.text;
    bean.zl=self.tf_goodWeight.text;
    bean.tj=self.tf_goodVolum.text;
    bean.summary=self.tf_summary.text;
    self.orderBean=bean;
//    if (self.tf_receiveName.text.length==0&&self.tf_phoneNumber.text.length==0&&self.tf_address.text.length==0&&self.tf_goodName.text.length==0&&self.tf_goodVolum.text.length==0&&self.tf_goodWeight.text.length==0&&self.tf_summary.text.length==0) {
//       
//    }else{
//        
//    }
    
    //save list
    NSFetchRequest* request=[[NSFetchRequest alloc]initWithEntityName:@"ReceiverInfo"];
    NSArray* infos=[ShareAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    for (ReceiverInfo* info in infos) {
        if ([info.name isEqualToString:self.tf_receiveName.text]) {
            [ShareAppDelegate.managedObjectContext deleteObject:info];
            [ShareAppDelegate saveContext];
        }
    }
    
    ReceiverInfo* receiver=[NSEntityDescription insertNewObjectForEntityForName:@"ReceiverInfo" inManagedObjectContext:ShareAppDelegate.managedObjectContext];
    receiver.name=self.tf_receiveName.text;
    receiver.phoneNumber=self.tf_phoneNumber.text;
    receiver.address=self.tf_address.text;
    if (!receiver.name.length==0&&receiver.phoneNumber.length==0&&receiver.address.length==0) {
         [ShareAppDelegate saveContext];
    }
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate getDetailsInfoOrderBean:self.orderBean];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"selectPeople"]) {
        SelectPeopleListViewController* vc=segue.destinationViewController;
        vc.delegate=self;
    }
}
#pragma SelectedPeopleDelegate
-(void)getSelectedPeople:(SelectedReceiverInfoBean *)peopleDic{
    self.tf_receiveName.text=peopleDic.name;
    self.tf_address.text=peopleDic.address;
    self.tf_phoneNumber.text=peopleDic.phoneNumber;
}
#pragma UITextField_Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    NSCharacterSet *cs;
    if(textField == self.tf_goodWeight)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            [MBProgressHUD showError:@"请输入数字!" toView:self.view.window];
            return NO;
        }
    }
    if(textField == self.tf_goodVolum)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            [MBProgressHUD showError:@"请输入数字!" toView:self.view.window];
            return NO;
        }
    }

    
    return YES;
}

@end
