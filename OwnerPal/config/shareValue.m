//
//  shareValue.m
//  HeMicroMall
//
//  Created by NewDoone on 15/2/4.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import "shareValue.h"
#define SET_EMPLOYEEADDRESS @"SET_EMPLOYEEADDRESS"
#define SET_EMPLOYEECOMPANY @"SET_EMPLOYEECOMPANY"
#define SET_EMPLOYEENAME @"SET_EMPLOYEENAME"
#define SET_EMPLOYEETEL @"SET_EMPLOYEETEL"
#define SET_MARK @"SET_MARK"
#define SET_ISNEEDTOUPDATECOMS @"SET_ISNEEDTOUPDATECOMS"


static shareValue *_shareValue;

@implementation shareValue
+(shareValue *)shareInstance;{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareValue = [[shareValue alloc]init];
    });
    return _shareValue;
}
-(void)setEmployeeAddress:(NSString *)employeeAddress{
    if (!employeeAddress) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_EMPLOYEEADDRESS];
    }else{
         [[NSUserDefaults standardUserDefaults]setObject:employeeAddress forKey:SET_EMPLOYEEADDRESS];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}
-(NSString *)employeeAddress{
    return [[NSUserDefaults standardUserDefaults]stringForKey:SET_EMPLOYEEADDRESS];
}
-(void)setEmployeeCompany:(NSString *)employeeCompany{
    if (!employeeCompany) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_EMPLOYEECOMPANY];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:employeeCompany forKey:SET_EMPLOYEECOMPANY];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}
-(NSString *)employeeCompany{
     return [[NSUserDefaults standardUserDefaults]stringForKey:SET_EMPLOYEECOMPANY];
}
-(void)setEmployeeName:(NSString *)employeeName{
    if (!employeeName) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_EMPLOYEENAME];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:employeeName forKey:SET_EMPLOYEENAME];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}
-(NSString *)employeeName{
    return [[NSUserDefaults standardUserDefaults]stringForKey:SET_EMPLOYEENAME];
}
-(void)setEmployeeTel:(NSString *)employeeTel{
    if (!employeeTel) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_EMPLOYEETEL];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:employeeTel forKey:SET_EMPLOYEETEL];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}
-(NSString *)employeeTel{
     return [[NSUserDefaults standardUserDefaults]stringForKey:SET_EMPLOYEETEL];
}
-(void)setMark:(NSString *)mark{
    if (!mark) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SET_MARK];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:mark forKey:SET_MARK];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}
-(NSString *)mark{
    return [[NSUserDefaults standardUserDefaults]stringForKey:SET_MARK];
}
-(void)setIsNeedToUpdateComs:(NSString*)isNeedToUpdateComs{
    if (!isNeedToUpdateComs) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:SET_ISNEEDTOUPDATECOMS];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:isNeedToUpdateComs forKey:SET_ISNEEDTOUPDATECOMS];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)isNeedToUpdateComs{
    return [[NSUserDefaults standardUserDefaults]stringForKey:SET_ISNEEDTOUPDATECOMS];
}
@end
