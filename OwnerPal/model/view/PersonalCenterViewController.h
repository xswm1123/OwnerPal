//
//  PersonalCenterViewController.h
//  OwnerPal
//
//  Created by NewDoone on 15/4/14.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import "BaseViewController.h"

@interface PersonalCenterViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *tf_name;
@property (weak, nonatomic) IBOutlet UITextField *tf_company;
@property (weak, nonatomic) IBOutlet UITextField *tf_address;
@property (weak, nonatomic) IBOutlet UILabel *lb_phoneNumber;

@end
