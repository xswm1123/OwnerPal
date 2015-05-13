//
//  OrderDetailsTableViewCell.m
//  OwnerPal
//
//  Created by NewDoone on 15/4/16.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import "OrderDetailsTableViewCell.h"

@implementation OrderDetailsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setIsSender:(NSString *)isSender{
    _isSender=isSender;
    if ([isSender isEqualToString:@"1"]) {
        self.markImv.image=[UIImage imageNamed:@"image_orderMark.png"];
    }else{
        self.markImv.image=[UIImage imageNamed:@"receive.png"];
    }
}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"touchesBegan");
//}
@end
