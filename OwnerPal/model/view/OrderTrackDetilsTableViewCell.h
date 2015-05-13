//
//  OrderTrackDetilsTableViewCell.h
//  OwnerPal
//
//  Created by NewDoone on 15/4/16.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTrackDetilsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *trackAddress;
@property (weak, nonatomic) IBOutlet UIImageView *stationLine;

@end
