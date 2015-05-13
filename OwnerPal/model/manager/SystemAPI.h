//
//  SystemAPI.h
//  HeMicroMall
//
//  Created by NewDoone on 15/2/4.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SystemHttpRequest.h"
#import "SystemHttpResponse.h"
@interface SystemAPI : NSObject
/*
 获取验证码
 */
+(void)getCheckMessageRequest:(GetCheckMessageRequest *)request success:(void(^)(GetCheckMessageResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
/*
 重置验证码
 */
+(void)reGetCheckMessageRequest:(ReGetCheckMessageRequest *)request success:(void(^)(ReGetCheckMessageResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
/*
 获取版本号
 */
+(void)GetVersionIDRequest:(GetVersionIDRequest*) request success:(void(^)(GetVersionIDResponse *response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail;
/*
 登陆
 */
+(void)loginRequest:(LoginRequest*) request success:(void (^)(LoginResponse * response))success fail:(void (^)(BOOL notReachable, NSString * desciption))fail;
/*
 通过手机号分页查询运单
 */
+(void)QueryDeliveryCodeRequest:(QueryDeliveryCodeRequest*) request success:(void (^)(QueryDeliveryCodeResponse * response))success fail:(void (^)(BOOL notReachable, NSString * desciption))fail;
/*
 通过统一单号查询配送明细
 */
+(void)QueryDeliveryDetailsRequest:(QueryDeliveryDetailsRequest*) request success:(void (^)(QueryDeliveryDetailsResponse * response))success fail:(void (^)(BOOL notReachable, NSString * desciption))fail;
/*
 订单保存
 */
+(void)SaveDeliveryRequest:(SaveDeliveryRequest*) request success:(void (^)(SaveDeliveryResponse * response))success fail:(void (^)(BOOL notReachable, NSString * desciption))fail;
/*
 获取物流公司
 */
+(void)GetDeliveryCompanyRequest:(GetDeliveryCompanyRequest*) request success:(void (^)(GetDeliveryCompanyResponse * response))success fail:(void (^)(BOOL notReachable, NSString * desciption))fail;
/*
 保存个人信息
 */
+(void)SavePersonInfosRequest:(SavePersonInfosRequest*) request uccess:(void (^)(SavePersonInfosResponse * response))success fail:(void (^)(BOOL notReachable, NSString * desciption))fail;

@end
