//
//  SystemHttpRequest.m
//  HeMicroMall
//
//  Created by NewDoone on 15/2/4.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import "SystemHttpRequest.h"
#import "shareValue.h"

@implementation GetCheckMessageRequest
-(id)init{
    if (self=[super init]) {
        _type=@"1";
    }
    return self;
}

@end
@implementation ReGetCheckMessageRequest
-(id)init{
    if (self=[super init]) {
        _type=@"2";
    }
    return self;
}

@end
@implementation LoginRequest
-(id)init{
    if (self=[super init]) {
        _type=@"5";
    }
    return self;
}

@end
@implementation QueryDeliveryCodeRequest
-(id)init{
    if (self=[super init]) {
        _type=@"3";
        _employeeTel=[shareValue shareInstance].employeeTel;
    }
    return self;
}

@end
@implementation QueryDeliveryDetailsRequest
-(id)init{
    if (self=[super init]) {
        _type=@"4";
    }
    return self;
}

@end
@implementation GetVersionIDRequest
-(id)init{
    if (self=[super init]) {
        _type=@"6";
    }
    return self;
}

@end
@implementation SaveDeliveryRequest
-(id)init{
    if (self=[super init]) {
        _type=@"7";
        
    }
    return self;
}

@end
@implementation GetDeliveryCompanyRequest
-(id)init{
    if (self=[super init]) {
        _type=@"8";
        if ([shareValue shareInstance].mark.length>0) {
            _mark=[shareValue shareInstance].mark;
        }else{
            _mark=@"0";
        }
        
    }
    return self;
}

@end
@implementation SavePersonInfosRequest
-(id)init{
    if (self=[super init]) {
        _type=@"9";
    }
    return self;
}

@end

