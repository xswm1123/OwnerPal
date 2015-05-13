//
//  SystemHttpResponse.h
//  HeMicroMall
//
//  Created by NewDoone on 15/2/4.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LK_HttpResponse.h"

@interface GetCheckMessageResponse :LK_HttpBaseResponse

@end
@interface ReGetCheckMessageResponse :LK_HttpBaseResponse

@end
@interface LoginResponse :LK_HttpBaseResponse
//@property(nonatomic,strong) NSString * employeeAddress;
//@property(nonatomic,strong) NSString * employeeCompany;
//@property(nonatomic,strong) NSString * employeeName;
//@property(nonatomic,strong) NSString * employeeTel;
//@property(nonatomic,strong) NSArray* list;
@end
@interface QueryDeliveryCodeResponse :LK_HttpBaseResponse

@end
@interface QueryDeliveryDetailsResponse :LK_HttpBaseResponse

@end
@interface GetVersionIDResponse :LK_HttpBaseResponse

@end
@interface SaveDeliveryResponse :LK_HttpBaseResponse

@end
@interface GetDeliveryCompanyResponse :LK_HttpBaseResponse

@end
@interface SavePersonInfosResponse :LK_HttpBaseResponse

@end

