//
//  QueryOrderDetailsViewController.h
//  OwnerPal
//
//  Created by NewDoone on 15/4/15.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderTrackDetilsTableViewCell.h"


@interface QueryOrderDetailsViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *orderCode;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSDictionary* baseInfo;

@end
