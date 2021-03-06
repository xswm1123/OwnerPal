//
//  LK_API.m
//  ffcsdemo
//
//  Created by hesh on 13-9-12.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import "LK_API.h"
#import "LK_NSDictionary2Object.h"
#import "ServerConfig.h"
#import "NSString+URL.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import <CommonCrypto/CommonDigest.h>

#define TIMEOUT_DEFAULT 30

@interface LK_APIUtil (p)
+(AFHTTPRequestOperationManager *)manager;
@end

@implementation LK_APIUtil(p)

+(AFHTTPRequestOperationManager *)manager{
    static dispatch_once_t onceToken;
    static AFHTTPRequestOperationManager *_manager;
    dispatch_once(&onceToken, ^
    {
        _manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:BASE_SERVERLURL]];
    });
    return _manager;
}

@end

@implementation LK_APIUtil

+(NSString*)stringCreateJsonWithObject:(id)obj
{
    return [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
}

+(void)postHttpRequest:(LK_HttpBaseRequest *)request apiPath:(NSString *)path Success:(void (^)(LK_HttpBaseResponse *))sucess fail:(void (^)(BOOL NotReachable,NSString *descript))fail class:(Class)responseClass
{
    if (!responseClass)
    {
        responseClass = [LK_HttpBaseResponse class];
    }
    NSDictionary *tdict = request.lkDictionary;
//     NSString *paramString = [LK_APIUtil stringCreateJsonWithObject:tdict ];
//    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[tdict JSONString],@"data", nil];
    NSLog(@"类型:%@", @"POST");
    NSLog(@"路径:%@", path);
    NSLog(@"参数:%@", tdict);
    AFHTTPRequestOperationManager *manager = LK_APIUtil.manager;
//    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation* op=
    [manager POST:path parameters:tdict success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if(responseObject){
                        NSData *responseData = (NSData *)responseObject;
                        NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
                        NSLog(@"responseString：%@",responseString);
                        NSDictionary *dict = [responseString objectFromJSONString];
            if (dict) {
                NSObject *object = [dict objectByClass:responseClass];
                LK_HttpBaseResponse * response = (LK_HttpBaseResponse *) object;
                if ([DEFINE_SUCCESSCODE isEqualToString:response.code]||[DEFINE_DESCRIPTION isEqualToString:response.code]) {
                    sucess((LK_HttpBaseResponse*)object);
                }else{
                    fail(NO,response.msg);
                }
            }else{
                fail(NO,@"网络不给力");
            }
        } else {
            fail(NO,@"服务器返回数据为空");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        fail(YES,@"网络不给力");
        NSLog(@"%@", [error description]);
    }];
    [op start];
}

+(void)getHttpRequest:(LK_HttpBaseRequest *)request apiPath:(NSString *)path Success:(void (^)(LK_HttpBaseResponse *))sucess fail:(void (^)(BOOL NotReachable,NSString *descript))fail class:(Class)responseClass{
    if (!responseClass) {
        responseClass = [LK_HttpBaseResponse class];
    }
    NSDictionary *tdict = request.lkDictionary;
    NSString *paramString = [LK_APIUtil stringCreateJsonWithObject:tdict ];
    NSLog(@"类型:%@", @"GET");
    NSLog(@"路径:%@", path);
    NSLog(@"参数:%@", paramString);
    path = [NSString stringWithFormat:@"%@?",path];
    request.requestPath = path;
    AFHTTPRequestOperationManager *manager = LK_APIUtil.manager;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation* op=
    [manager GET:path parameters:tdict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject){
            NSData *responseData = (NSData *)responseObject;
            NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"responseString：%@",responseString);
            NSDictionary *dict = [responseString objectFromJSONString];
            if (dict) {
                NSObject *object = [dict objectByClass:responseClass];
                LK_HttpBaseResponse * response = (LK_HttpBaseResponse *) object;
                if ([DEFINE_SUCCESSCODE isEqualToString:response.code]||[DEFINE_DESCRIPTION isEqualToString:response.code]) {
                    sucess((LK_HttpBaseResponse*)object);
                }else{
                    fail(NO,response.msg);
                }
            }else{
                fail(NO,@"网络不给力");
            }
        } else {
            fail(NO,@"服务器返回数据为空");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         fail(YES,@"网络不给力");
        NSLog(@"%@", [error description]);
    }];
    [op start];
}

//// 加密接口
//+(void)getHttpRequest:(LK_HttpBaseRequest *)request
//              apiPath:(NSString *)path
//              encryptedKey:(NSString *)encryptedKey
//              Success:(void (^)(LK_HttpBaseResponse *))sucess fail:(void (^)(BOOL NotReachable,NSString *descript))fail class:(Class)responseClass{
//    if (!responseClass) {
//        responseClass = [LK_HttpBaseResponse class];
//    }
//    NSDictionary *tdict = request.lkDictionary;
//    NSMutableString *paramString = [[NSMutableString alloc]initWithString:[LK_APIUtil stringCreateJsonWithObject:tdict]];
//    NSString *dicString = [[NSMutableString alloc]initWithString:[LK_APIUtil stringCreateJsonWithObject:tdict]];
//    [paramString appendString:encryptedKey];
//    NSLog(@"类型:%@", @"GET");
//    NSLog(@"路径:%@", path);
//    NSLog(@"参数:%@", paramString);
//    NSLog(@"秘钥:%@", encryptedKey);
//    NSString *encryptedMSG = [[NSString alloc]init];
//    const char *str = [paramString UTF8String];
//    if (str == NULL)
//    {
//        str = "";
//    }
//    unsigned char r[CC_MD5_DIGEST_LENGTH];
//    CC_MD5(str, (CC_LONG)strlen(str), r);
//    encryptedMSG = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
//                    r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
//    NSLog(@"密文:%@",encryptedMSG);
//    path = [NSString stringWithFormat:@"%@?data=%@&encrypt=%@",path, [dicString URLEncodedString],encryptedMSG];
//    request.requestPath = path;
//    NSLog(@"转义后报文:%@",path);
//    AFHTTPClient *client = LK_APIUtil.client;
//    [client getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if(responseObject){
//            NSData *responseData = (NSData *)responseObject;
//            NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",responseString);
//            NSDictionary *dict = [responseString objectFromJSONString];
//            if (dict) {
//                NSObject *object = [dict objectByClass:responseClass];
//                LK_HttpBaseResponse * response = (LK_HttpBaseResponse *) object;
//                if ([DEFINE_SUCCESSCODE isEqualToString:response.retCode]) {
//                    sucess((LK_HttpBaseResponse*)object);
//                }else{
//                    fail(NO,response.retMsg);
//                }
//            }else{
//                fail(NO,@"网络不给力");
//            }
//        } else {
//            fail(NO,@"服务器返回数据为空");
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@", [error description]);
//        //        fail(client.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable,@"网络不给力");
//        fail(YES,@"网络不给力");
//    }];
//}
//
//+(void)getHttpRequest:(LK_HttpBaseRequest *)request basePath:(NSString *)basePath apiPath:(NSString *)path Success:(void (^)(LK_HttpBaseResponse *))sucess fail:(void (^)(BOOL NotReachable,NSString *descript))fail class:(Class)responseClass
//{
//    if (!responseClass) {
//        responseClass = [LK_HttpBaseResponse class];
//    }
//    NSDictionary *tdict = request.lkDictionary;
//    NSString *paramString = [LK_APIUtil stringCreateJsonWithObject:tdict ];
//    path = [NSString stringWithFormat:@"%@?data=%@",path,[paramString URLEncodedString]];
//    request.requestPath = path;
//    AFHTTPClient *client =  [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:basePath]];
//    [client getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if(responseObject){
//            NSData *responseData = (NSData *)responseObject;
//            NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",responseString);
//            NSDictionary *dict = [responseString objectFromJSONString];
//            if (dict) {
//                NSObject *object = [dict objectByClass:responseClass];
//                LK_HttpBaseResponse * response = (LK_HttpBaseResponse *) object;
//                if ([DEFINE_SUCCESSCODE isEqualToString:response.retCode]) {
//                    sucess((LK_HttpBaseResponse*)object);
//                }else{
//                    fail(NO,response.retMsg);
//                }
//            }else{
//                fail(NO,@"网络不给力");
//            }
//        } else {
//            fail(NO,@"服务器返回数据为空");
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        fail(client.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable,@"网络不给力");
//    }];
//}
//
//+(void)cancelAllHttpRequestByApiPath:(NSString *)path;{
//    [LK_APIUtil.client cancelAllHTTPOperationsWithMethod:@"POST" path:path];
//    [LK_APIUtil.client cancelAllHTTPOperationsWithMethod:@"GET" path:path];
//}
//
//
//+(void)uploadFile:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType ProgressBlock:(void(^)(NSInteger bytesWritten, long long totalBytesWritten))progressblock successBlock:(void(^)(NSString *filepath))success errorBlock:(void(^)(BOOL NotReachable))errorBlock;{
//    AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:UPLOAD_PIC_URL]];
//    NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"post" path:@"uploadPhoto.shtml" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
//    }];
//    request.timeoutInterval = 20;
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        progressblock(bytesWritten,totalBytesWritten);
//    }];
//    [operation start];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if(responseObject){
//            NSData *responseData = (NSData *)responseObject;
//            NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
//            success(responseString);
//        }else{
//           errorBlock(client.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        errorBlock(client.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable);
//    }];
//    
//}
//
//+(void)getHttpRequestVersion:(LK_HttpBaseRequest *)request apiPath:(NSString *)path Success:(void (^)(LK_HttpVersionResponse *))sucess fail:(void (^)(BOOL NotReachable,NSString *descript))fail class:(Class)responseClass{
//    if (!responseClass) {
//        responseClass = [LK_HttpBaseResponse class];
//    }
//    NSLog(@"类型:%@", @"GET");
//    NSLog(@"路径:%@", path);
//    request.requestPath = path;
//    AFHTTPClient *client = LK_APIUtil.client;
//    [client getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
//    {
//        if(responseObject)
//        {
//            NSData *responseData = (NSData *)responseObject;
//            NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",responseString);
//            NSDictionary *dict = [responseString objectFromJSONString];
//            if (dict)
//            {
//                NSObject *object = [dict objectByClass:responseClass];
//                LK_HttpVersionResponse * response = (LK_HttpVersionResponse *) object;
//                if ([DEFINE_SUCCESSCODE isEqualToString:response.retCode])
//                {
//                    sucess((LK_HttpVersionResponse*)object);
//                }else{
//                    fail(NO,response.retMsg);
//                }
//            }else{
//                fail(NO,@"网络不给力");
//            }
//        } else {
//            fail(NO,@"服务器返回数据为空");
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@", [error description]);
//        //        fail(client.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable,@"网络不给力");
//        fail(YES,@"网络不给力");
//    }];
//}
//
//+(void)getHttpRequestNoData:(LK_HttpBaseRequest *)request apiPath:(NSString *)path Success:(void (^)(LK_HttpBaseResponse *))sucess fail:(void (^)(BOOL NotReachable,NSString *descript))fail class:(Class)responseClass{
//    if (!responseClass)
//    {
//        responseClass = [LK_HttpBaseResponse class];
//    }
//    NSDictionary *tdict = request.lkDictionary;
//    NSString *paramString = [LK_APIUtil stringCreateJsonWithObject:tdict ];
//    NSLog(@"类型:%@", @"GET");
//    NSLog(@"路径:%@", path);
//    NSLog(@"参数:%@", paramString);
//    path = [NSString stringWithFormat:@"%@",path];
//    request.requestPath = path;
//    AFHTTPClient *client = LK_APIUtil.client;
//    
//    [client getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
//    {
//        if(responseObject){
//            NSData *responseData = (NSData *)responseObject;
//            NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",responseString);
//            NSDictionary *dict = [responseString objectFromJSONString];
//            if (dict)
//            {
//                NSObject *object = [dict objectByClass:responseClass];
//                LK_HttpBaseResponse * response = (LK_HttpBaseResponse *) object;
//                if ([DEFINE_SUCCESSCODE isEqualToString:response.retCode]) {
//                    sucess((LK_HttpBaseResponse*)object);
//                }else{
//                    fail(NO,response.retMsg);
//                }
//            }else{
//                fail(NO,@"网络不给力");
//            }
//        } else {
//            fail(NO,@"服务器返回数据为空");
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@", [error description]);
//        //        fail(client.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable,@"网络不给力");
//        fail(YES,@"网络不给力");
//    }];
//}
//
@end
