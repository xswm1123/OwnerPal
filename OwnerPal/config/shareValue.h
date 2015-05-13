//
//  shareValue.h
//  HeMicroMall
//
//  Created by NewDoone on 15/2/4.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
/**
 *  输入类文本标题的颜色设置
 */
#define COLOR_INPUT_TITLE       HEX_RGB(0x939a9d)
#define FONT_SIZE_INPUT_TITLE   15.f
#define COLOR_INPUT_CONTENT     HEX_RGB(0x000000)
#define FONT_SIZE_INPUT_CONTENT 13.f
#define COLOR_DETAIL_CONTENT    HEX_RGB(0x5C6871)
#define FONT_SIZE_DETAIL_CONTENT 15.f


@interface shareValue : NSObject
+(shareValue *)shareInstance;
@property(nonatomic,assign) CLLocationCoordinate2D currentLocation;//当前经纬度
@property(nonatomic,strong) NSString *employeeAddress;//发货地址
@property  (nonatomic,strong) NSString * employeeCompany;//物流公司
@property (nonatomic,strong) NSString * employeeName; //姓名
@property (nonatomic,strong) NSString  * employeeTel;//电话
@property (nonatomic,strong) NSString * mark;//物流公司标识
@end
