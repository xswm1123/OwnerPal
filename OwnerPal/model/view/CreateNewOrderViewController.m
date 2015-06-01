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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtns;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (nonatomic,strong) UIButton* temoBtn;
@property (nonatomic,strong) ChooseCompanyBean* ComBean;

@end

@implementation CreateNewOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}
-(void)initView{
    self.confirmBtns.layer.cornerRadius=5;
    self.confirmBtns.hidden=YES;
    self.detailsView.hidden=YES;
    /**
     *  create tempBtn
     */
    self.temoBtn=[[UIButton alloc]init];
//    self.temoBtn.titleLabel.text=@"确认下单";
    self.temoBtn.backgroundColor=[UIColor colorWithRed:251.0/255 green:167.0/255 blue:56.0/255 alpha:1.0];
    self.temoBtn.layer.cornerRadius=5.0;
    [self.temoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.temoBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [self.temoBtn setTitle:@"确认下单" forState:UIControlStateNormal];
    [self.temoBtn addTarget:self action:@selector(confirmOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView insertSubview:self.temoBtn aboveSubview:self.detailsView];
}
-(BOOL)isValiData{
    NSString* numStr=self.tf_numberOfGoods.text;
    NSString* numStrValue=[NSString stringWithFormat:@"%ld",(long)[self.tf_numberOfGoods.text integerValue]];
    if (numStr.length==0||[numStrValue isEqualToString:@"0"]) {
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
    
    if ([self isValiData]) {
        [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        BNOrderDetails* bean=[[BNOrderDetails alloc]init];
        bean.js=self.tf_numberOfGoods.text;
        bean.wlgs=self.tf_deliverCompany.text;
        bean.shxm=self.receive_name.text;
        bean.shdh=self.receive_phoneNum.text;
        bean.shdz=self.receive_address.text;
        bean.hw=self.good_name.text;
        bean.zl=self.tf_goodWeight.text;
        bean.tj=self.tf_goodVolum.text;
        bean.shbj=self.receiverCode.text;
        bean.ddn=self.arrivedPoint.text;
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
/**
 *  保存到本地常用承运单位表
 */
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
        receiver.phoneNumber=self.ComBean.phoneNumber;
        receiver.key=self.ComBean.key;
        receiver.address=self.ComBean.address;
        [ShareAppDelegate saveContext];
     }

}
/**
 *  清空当前所有信息
 */
-(void)emptyAllTheField{
    self.tf_deliverCompany.text=@"";
    self.tf_numberOfGoods.text=@"";
    self.receive_address.text=@"";
    self.receive_name.text=@"";
    self.receive_phoneNum.text=@"";
    self.good_name.text=@"";
    self.good_summary.text=@"";
    self.tf_goodWeight.text=@"";
    self.tf_goodVolum.text=@"";
    self.arrivedPoint.text=@"";
    self.receiverCode.text=@"";
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
        bean.tj=self.tf_goodVolum.text;
        bean.zl=self.tf_goodWeight.text;
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
    self.detailsView.hidden=NO;
}
#pragma DeliverCompanyDelegate
-(void)getDeliverCompany:(ChooseCompanyBean *)companyDic{
    self.tf_deliverCompany.text=companyDic.name;
    self.ComBean=companyDic;
//    if (self.tf_deliverCompany.text.length>0) {
//        //save list
//        NSFetchRequest* request=[[NSFetchRequest alloc]initWithEntityName:@"DeliveryCompanyInfo"];
//        NSArray* infos=[ShareAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
//        for (DeliveryCompanyInfo* info in infos) {
//            if ([info.name isEqualToString:companyDic.name]) {
//                [ShareAppDelegate.managedObjectContext deleteObject:info];
//                [ShareAppDelegate saveContext];
//            }
//        }
//        DeliveryCompanyInfo* receiver=[NSEntityDescription insertNewObjectForEntityForName:@"DeliveryCompanyInfo" inManagedObjectContext:ShareAppDelegate.managedObjectContext];
//        receiver.name=companyDic.name;
//        receiver.phoneNumber=companyDic.phoneNumber;
//        receiver.key=companyDic.key;
//        receiver.address=companyDic.address;
//        [ShareAppDelegate saveContext];
//    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.detailsView.isHidden) {
        NSLog(@"hidden");
        CGPoint center;
        center.x=self.view.center.x;
        center.y=self.detailBtn.frame.origin.y+self.detailBtn.frame.size.height+self.confirmBtns.frame.size.height/2+10;
//        self.confirmBtns.center=center;
//        self.confirmBtns.translatesAutoresizingMaskIntoConstraints=NO;
//        self.detailBtn.translatesAutoresizingMaskIntoConstraints=NO;
//        NSLayoutConstraint* constraint=[NSLayoutConstraint constraintWithItem:self.detailBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.confirmBtns attribute:NSLayoutAttributeTop multiplier:1.0 constant:-10];
//        [self.view addConstraint:constraint];
        self.temoBtn.frame=CGRectMake(center.x-90, center.y-20, 180, 40);
        
    }else{
        NSLog(@"show");
        CGPoint center;
        center.x=self.view.center.x;
        center.y=self.detailsView.frame.origin.y+self.detailsView.frame.size.height+self.confirmBtns.frame.size.height/2+10;
//        self.confirmBtns.center=center;
//        NSLayoutConstraint* constraint=[NSLayoutConstraint constraintWithItem:self.confirmBtns attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.detailsView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10];
//        [self.view addConstraint:constraint];
//         NSLog(@"btnCenter:x====%f",center.x);
//        NSLog(@"btnCenter:y====%f",center.y);
        self.temoBtn.frame=CGRectMake(center.x-90, center.y-20, 180, 40);
    }
    
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
