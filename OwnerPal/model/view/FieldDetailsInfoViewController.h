//
//  FieldDetailsInfoViewController.h
//  OwnerPal
//
//  Created by NewDoone on 15/4/20.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderDetailsBean.h"
#import "ChooseCompanyBean.h"
@class FieldDetailsInfoViewController;
@protocol DetailsInfoDelegate <NSObject>

-(void)getDetailsInfoOrderBean:(OrderDetailsBean*) orderBean;

@end

@interface FieldDetailsInfoViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *tf_receiveName;
@property (weak, nonatomic) IBOutlet UITextField *tf_phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *tf_address;
@property (weak, nonatomic) IBOutlet UITextField *tf_goodName;
@property (weak, nonatomic) IBOutlet UITextField *tf_goodWeight;
@property (weak, nonatomic) IBOutlet UITextField *tf_goodVolum;
@property (weak, nonatomic) IBOutlet UITextField *tf_summary;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property(nonatomic,weak) id<DetailsInfoDelegate>delegate;
@property (nonatomic,strong) OrderDetailsBean* orderBean;
@property (nonatomic,strong) OrderDetailsBean* commenBean;
@end
