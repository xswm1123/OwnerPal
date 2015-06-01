//
//  DeliveryCompanyInfo.h
//  OwnerPal
//
//  Created by Anita Lee on 15/5/25.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DeliveryCompanyInfo : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * py;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * area;
@property (nonatomic, retain) NSString * manager;
@property (nonatomic, retain) NSString * mark;

@end
