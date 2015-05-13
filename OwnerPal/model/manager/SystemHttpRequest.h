//
//  SystemHttpRequest.h
//  HeMicroMall
//
//  Created by NewDoone on 15/2/4.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LK_HttpRequest.h"
//短信验证
@interface GetCheckMessageRequest : LK_HttpBaseRequest
@property(nonatomic,strong) NSString* type;
@property(nonatomic,strong) NSString*  employeeTel;
@end
//重置短信验证
@interface ReGetCheckMessageRequest : LK_HttpBaseRequest
@property(nonatomic,strong) NSString* type;
@property(nonatomic,strong) NSString*  employeeTel;
@end
//登陆
@interface LoginRequest : LK_HttpBaseRequest
@property(nonatomic,strong) NSString* type;
@property(nonatomic,strong) NSString*  employeeTel;
@property(nonatomic,strong) NSString* authCode;
@end
//通过手机号分页查询运单
@interface QueryDeliveryCodeRequest : LK_HttpBaseRequest
@property(nonatomic,strong) NSString* type;
@property(nonatomic,strong) NSString*  employeeTel;
@property(nonatomic,strong) NSString* billId;
@end
//通过统一单号查询配送明细
@interface QueryDeliveryDetailsRequest : LK_HttpBaseRequest
@property(nonatomic,strong) NSString* type;
@property(nonatomic,strong) NSString*  uniqueCode;
@end
//获取版本号
@interface GetVersionIDRequest : LK_HttpBaseRequest
@property(nonatomic,strong) NSString* type;
@end

/*
 //订单保存
 参数：type=7,
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
@interface SaveDeliveryRequest : LK_HttpBaseRequest
@property(nonatomic,strong) NSString* type;
//@property(nonatomic,strong) NSString* wlgs;
//@property(nonatomic,strong) NSString* fhdw;
//@property(nonatomic,strong) NSString* fhxm;
//@property(nonatomic,strong) NSString* fhdh;
//@property(nonatomic,strong) NSString* fhdz;
//@property(nonatomic,strong) NSString* shxm;
//@property(nonatomic,strong) NSString* shdh;
//@property(nonatomic,strong) NSString* shdz;
//@property(nonatomic,strong) NSString* hw;
//@property(nonatomic,strong) NSString* js;
//@property(nonatomic,strong) NSString* zl;
//@property(nonatomic,strong) NSString* tj;
//@property(nonatomic,strong) NSString* qyid;
@property(nonatomic,strong) NSString* para;
@end
//获取物流公司
@interface GetDeliveryCompanyRequest : LK_HttpBaseRequest
@property(nonatomic,strong) NSString* type;
@property(nonatomic,strong) NSString* mark;
@end

/*
 //保存个人信息
 参数：type=9,
 para{
 “employeeCompany”:”单位”,
 “employeeName”:”姓名”,
 “employeeTel”:”电话”,
 “employeeAddress”:”地址”
 }
 */
@interface SavePersonInfosRequest : LK_HttpBaseRequest
@property(nonatomic,strong) NSString* type;
//@property(nonatomic,strong) NSString* employeeCompany;
//@property(nonatomic,strong) NSString* employeeName;
//@property(nonatomic,strong) NSString* employeeTel;
//@property(nonatomic,strong) NSString* employeeAddress;
@property(nonatomic,strong) NSString * para;
@end
