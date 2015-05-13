//
//  OrderDetailsTableViewCell.h
//  OwnerPal
//
//  Created by NewDoone on 15/4/16.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *markImv;
@property (weak, nonatomic) IBOutlet UILabel *orderCode;
@property (weak, nonatomic) IBOutlet UILabel *isSignIn;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet UILabel *fromTo;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdateTime;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (nonatomic,strong) NSString * isSender;
@end
