//
//  CreateNewOrderViewController.m
//  OwnerPal
//
//  Created by NewDoone on 15/4/14.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import "CreateNewOrderViewController.h"
#import "FieldDetailsInfoViewController.h"
#import "ChooseDeliverCompanyViewController.h"
#import "SelectPeopleListViewController.h"
#import "ChooseCompanyBean.h"
#import "BNOrderDetails.h"

@interface CreateNewOrderViewController ()<DetailsInfoDelegate,DeliverCompanyDelegate>
@property (weak, nonatomic) IBOutlet UIView *detailsView;

@end

@implementation CreateNewOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}
-(void)initView{
    self.confirmBtn.layer.cornerRadius=5;
    self.detailsView.hidden=YES;
}
-(BOOL)isValiData{
    if (self.tf_numberOfGoods.text.length==0) {
        [MBProgressHUD showError:@"请输入货物件数!" toView:self.view.window];
        return NO;
    }
    return YES;
}
- (IBAction)chooseDeliverCompany:(id)sender {
    [self performSegueWithIdentifier:@"chooseDeliverCompany" sender:nil];
    self.tabBarController.tabBar.hidden=YES;
}
- (IBAction)showDetailInfos:(id)sender {
    
    [self performSegueWithIdentifier:@"fieldDetails" sender:nil];
    
    self.tabBarController.tabBar.hidden=YES;
}
- (IBAction)confirmOrderAction:(id)sender {
//     [self performSegueWithIdentifier:@"showresult" sender:nil];
    
    if ([self isValiData]) {
        [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        BNOrderDetails* bean=[[BNOrderDetails alloc]init];
        bean.js=self.tf_numberOfGoods.text;
        bean.wlgs=self.tf_deliverCompany.text;
        bean.shxm=self.receive_name.text;
        bean.shdh=self.receive_phoneNum.text;
        bean.shdz=self.receive_address.text;
        bean.hw=self.good_name.text;
        bean.zl=self.good_weight.text;
        bean.tj=self.good_Volume.text;
        bean.fhdh=[shareValue shareInstance].employeeTel;
        bean.fhxm=[shareValue shareInstance].employeeName;
        bean.fhdz=[shareValue shareInstance].employeeAddress;
        bean.fhdw=[shareValue shareInstance].employeeCompany;
        bean.qyid=@"1";
        SaveDeliveryRequest* request=[[SaveDeliveryRequest alloc]init];
        NSDictionary* dic=bean.lkDictionary;
        request.para=[dic JSONString];
        [SystemAPI SaveDeliveryRequest:request success:^(SaveDeliveryResponse *response) {
            [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
            [MBProgressHUD showSuccess:response.msg toView:self.view.window];
            [self performSegueWithIdentifier:@"showresult" sender:nil];
             self.tabBarController.tabBar.hidden=YES;
            [self saveDeliveryCompanyInfo];
            [self emptyAllTheField];
          
        } fail:^(BOOL notReachable, NSString *desciption) {
            [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
            [MBProgressHUD showError:desciption toView:self.view.window];
        }];
    }
}
-(void)saveDeliveryCompanyInfo{
    if (self.tf_deliverCompany.text.length>0) {
        
   
        //save list
        NSFetchRequest* request=[[NSFetchRequest alloc]initWithEntityName:@"DeliveryCompanyInfo"];
        NSArray* infos=[ShareAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
        for (DeliveryCompanyInfo* info in infos) {
            if ([info.name isEqualToString:self.tf_deliverCompany.text]) {
                [ShareAppDelegate.managedObjectContext deleteObject:info];
                [ShareAppDelegate saveContext];
            }
        }
        DeliveryCompanyInfo* receiver=[NSEntityDescription insertNewObjectForEntityForName:@"DeliveryCompanyInfo" inManagedObjectContext:ShareAppDelegate.managedObjectContext];
        receiver.name=self.tf_deliverCompany.text;
        receiver.phoneNumber=@"";
        
        [ShareAppDelegate saveContext];
     }

}
-(void)emptyAllTheField{
    self.tf_deliverCompany.text=@"";
    self.tf_numberOfGoods.text=@"";
    self.receive_address.text=@"";
    self.receive_name.text=@"";
    self.receive_phoneNum.text=@"";
    self.good_name.text=@"";
    self.good_summary.text=@"";
    self.good_Volume.text=@"";
    self.good_weight.text=@"";
     self.detailsView.hidden=YES;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"fieldDetails"]) {
        FieldDetailsInfoViewController* vc=segue.destinationViewController;
        vc.delegate=self;
        OrderDetailsBean* bean=[[OrderDetailsBean alloc]init];
        bean.shxm=self.receive_name.text;
        bean.shdh=self.receive_phoneNum.text;
        bean.shdz=self.receive_address.text;
        bean.hw=self.good_name.text;
        bean.summary= self.good_summary.text;
        bean.tj=self.good_Volume.text;
        bean.zl=self.good_weight.text;
        vc.commenBean=bean;
    }
    if ([segue.identifier isEqualToString:@"chooseDeliverCompany"]) {
        ChooseDeliverCompanyViewController* vc=segue.destinationViewController;
        vc.delegate=self;
    }
    
}
#pragma DetailsInfoDelegate
-(void)getDetailsInfoOrderBean:(OrderDetailsBean *)orderBean{
    NSLog(@"getDetailsInfoOrderBean");
    self.receive_name.text=orderBean.shxm;
    self.receive_phoneNum.text=orderBean.shdh;
    self.receive_address.text=orderBean.shdz;
    self.good_name.text=orderBean.hw;
    self.good_summary.text=orderBean.summary;
    self.good_Volume.text=orderBean.tj;
    self.good_weight.text=orderBean.zl;
    self.detailsView.hidden=NO;
}
#pragma DeliverCompanyDelegate
-(void)getDeliverCompany:(ChooseCompanyBean *)companyDic{
    self.tf_deliverCompany.text=companyDic.name;
    if (self.tf_deliverCompany.text.length>0) {
        //save list
        NSFetchRequest* request=[[NSFetchRequest alloc]initWithEntityName:@"DeliveryCompanyInfo"];
        NSArray* infos=[ShareAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
        for (DeliveryCompanyInfo* info in infos) {
            if ([info.name isEqualToString:companyDic.name]) {
                [ShareAppDelegate.managedObjectContext deleteObject:info];
                [ShareAppDelegate saveContext];
            }
        }
        DeliveryCompanyInfo* receiver=[NSEntityDescription insertNewObjectForEntityForName:@"DeliveryCompanyInfo" inManagedObjectContext:ShareAppDelegate.managedObjectContext];
        receiver.name=companyDic.name;
        receiver.phoneNumber=companyDic.phoneNumber;

        [ShareAppDelegate saveContext];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=NO;
}
#pragma UITextField_Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    NSCharacterSet *cs;
    if(textField == self.tf_numberOfGoods)
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
