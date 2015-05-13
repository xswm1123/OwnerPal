//
//  ChooseDeliverCompanyViewController.h
//  OwnerPal
//
//  Created by NewDoone on 15/4/20.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import "BaseViewController.h"
#import "ChooseCompanyBean.h"
#import "OAChineseToPinyin.h"
@class ChooseDeliverCompanyViewController;
@protocol DeliverCompanyDelegate <NSObject>

-(void)getDeliverCompany:(ChooseCompanyBean*) companyDic;

@end
@interface ChooseDeliverCompanyViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *mostChoosed;
@property (weak, nonatomic) IBOutlet UIButton *allCompanys;
@property (weak, nonatomic) IBOutlet UITextField *tf_serach;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,weak) id<DeliverCompanyDelegate> delegate;

@end
