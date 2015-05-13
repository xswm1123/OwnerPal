//
//  OrderDetailsBean.h
//  OwnerPal
//
//  Created by NewDoone on 15/4/21.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
para:{
    “wlgs”:“物流公司”，
    “fhdw”:”发货单位”，
    “fhxm”:”发货人姓名”，
    “fhdh”:”发货人电话”，
    “fhdz”:”发货地址”,
    “shxm”:”收货姓名”,
    “shdh”:”收货电话”,
    “shdz”:”收货地址”,
    “hw”:”货物名称”,
    “js”：件数，
    “zl”：重量，
    “tj”：体积，
    “qyid”：区域ID（暂时固定为“1”）
}
*/
@interface OrderDetailsBean : NSObject
@property (nonatomic,strong) NSString*wlgs;
@property (nonatomic,strong) NSString*fhdw;
@property (nonatomic,strong) NSString*fhxm;
@property (nonatomic,strong) NSString*fhdh;
@property (nonatomic,strong) NSString*fhdz;
@property (nonatomic,strong) NSString*shxm;
@property (nonatomic,strong) NSString*shdh;
@property (nonatomic,strong) NSString*shdz;
@property (nonatomic,strong) NSString*hw;
@property (nonatomic,strong) NSString*js;
@property (nonatomic,strong) NSString*zl;
@property (nonatomic,strong) NSString*tj;
@property (nonatomic,strong) NSString*qyid;
@property (nonatomic,strong) NSString* summary;
@end
