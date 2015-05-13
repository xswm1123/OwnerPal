//
//  DeliveryCompanyInfo.h
//  OwnerPal
//
//  Created by NewDoone on 15/4/23.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DeliveryCompanyInfo : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phoneNumber;
@end
