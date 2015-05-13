//
//  SystemAPI.m
//  HeMicroMall
//
//  Created by NewDoone on 15/2/4.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import "SystemAPI.h"
#import "LK_API.h"
#import "ServerConfig.h"

@implementation SystemAPI
/*
 获取验证码
 */
+(void)getCheckMessageRequest:(GetCheckMessageRequest *)request success:(void (^)(GetCheckMessageResponse *))success fail:(void (^)(BOOL, NSString *))fail{
    [LK_APIUtil postHttpRequest:request apiPath:URL_COMMEN_PATH Success:^(LK_HttpBaseResponse *response) {
        success((GetCheckMessageResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetCheckMessageResponse class]];
}
/*
 登陆
 */
+(void)loginRequest:(LoginRequest*) request success:(void (^)(LoginResponse *))success fail:(void (^)(BOOL, NSString *))fail{
    [LK_APIUtil postHttpRequest:request apiPath:URL_COMMEN_PATH Success:^(LK_HttpBaseResponse * response) {
        success((LoginResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[LoginResponse class]];
    
}

/*
 重置验证码
 */
+(void)reGetCheckMessageRequest:(ReGetCheckMessageRequest *)request success:(void(^)( ReGetCheckMessageResponse*response))success fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil postHttpRequest:request apiPath:URL_COMMEN_PATH Success:^(LK_HttpBaseResponse * response) {
         success((ReGetCheckMessageResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[ReGetCheckMessageResponse class]];
}
/*
 获取版本号
 */
+(void)GetVersionIDRequest:(GetVersionIDRequest*) request success:(void(^)( GetVersionIDResponse *response))success  fail:(void(^)(BOOL notReachable,NSString *desciption))fail{
    [LK_APIUtil postHttpRequest:request apiPath:URL_COMMEN_PATH Success:^(LK_HttpBaseResponse * response) {
        success((GetVersionIDResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetVersionIDResponse class]];
}
/*
 通过手机号分页查询运单
 */
+(void)QueryDeliveryCodeRequest:(QueryDeliveryCodeRequest*) request success:(void (^)(QueryDeliveryCodeResponse * response))success fail:(void (^)(BOOL notReachable, NSString * desciption))fail{
    [LK_APIUtil postHttpRequest:request apiPath:URL_COMMEN_PATH Success:^(LK_HttpBaseResponse * response) {
        success((QueryDeliveryCodeResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[QueryDeliveryCodeResponse class]];
}
/*
 通过统一单号查询配送明细
 */
+(void)QueryDeliveryDetailsRequest:(QueryDeliveryDetailsRequest*) request success:(void (^)(QueryDeliveryDetailsResponse * response))success fail:(void (^)(BOOL notReachable, NSString * desciption))fail{
    [LK_APIUtil postHttpRequest:request apiPath:URL_COMMEN_PATH Success:^(LK_HttpBaseResponse * response) {
        success((QueryDeliveryDetailsResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[QueryDeliveryDetailsResponse class]];
}
/*
 订单保存
 */
+(void)SaveDeliveryRequest:(SaveDeliveryRequest*) request success:(void (^)(SaveDeliveryResponse * response))success fail:(void (^)(BOOL notReachable, NSString * desciption))fail{
    [LK_APIUtil postHttpRequest:request apiPath:URL_COMMEN_PATH Success:^(LK_HttpBaseResponse * response) {
        success((SaveDeliveryResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[SaveDeliveryResponse class]];
}
/*
 获取物流公司
 */
+(void)GetDeliveryCompanyRequest:(GetDeliveryCompanyRequest*) request success:(void (^)(GetDeliveryCompanyResponse * response))success fail:(void (^)(BOOL notReachable, NSString * desciption))fail{
    [LK_APIUtil postHttpRequest:request apiPath:URL_COMMEN_PATH Success:^(LK_HttpBaseResponse * response) {
        success((GetDeliveryCompanyResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[GetDeliveryCompanyResponse class]];
}
/*
 保存个人信息
 */
+(void)SavePersonInfosRequest:(SavePersonInfosRequest*) request uccess:(void (^)(SavePersonInfosResponse * response))success fail:(void (^)(BOOL notReachable, NSString * desciption))fail{
    [LK_APIUtil postHttpRequest:request apiPath:URL_COMMEN_PATH Success:^(LK_HttpBaseResponse * response) {
        success((SavePersonInfosResponse *)response);
    } fail:^(BOOL NotReachable, NSString *desciption) {
        fail(NotReachable,desciption);
    } class:[SavePersonInfosResponse class]];
}
@end
