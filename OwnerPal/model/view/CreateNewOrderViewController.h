//
//  CreateNewOrderViewController.h
//  OwnerPal
//
//  Created by NewDoone on 15/4/14.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import "BaseViewController.h"

@interface CreateNewOrderViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *tf_numberOfGoods;
@property (weak, nonatomic) IBOutlet UITextField *tf_deliverCompany;
@property (weak, nonatomic) IBOutlet UILabel *receive_name;
@property (weak, nonatomic) IBOutlet UILabel *receive_phoneNum;
@property (weak, nonatomic) IBOutlet UILabel *receive_address;
@property (weak, nonatomic) IBOutlet UILabel *good_name;
@property (weak, nonatomic) IBOutlet UILabel *good_weight;
@property (weak, nonatomic) IBOutlet UILabel *good_Volume;
@property (weak, nonatomic) IBOutlet UILabel *good_summary;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end
