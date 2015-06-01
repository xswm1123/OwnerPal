//
//  BaseViewController.h
//  HeMicroMall
//
//  Created by NewDoone on 15/2/16.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shareValue.h"
#import "ServerConfig.h"
#import <WebKit/WebKit.h>
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"
#import "SystemAPI.h"
#import "SystemHttpRequest.h"
#import "SystemHttpResponse.h"
#import "UtilTool.h"
#import "LK_NSDictionary2Object.h"
#import "DeliveryCompanyInfo.h"
#import "ReceiverInfo.h"
#import "DeliveryCompanyAllInfo.h"

#define NUMBERS @"0123456789.\n"
#define DEVICE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define DEVICE_HEIGHT ( [UIScreen mainScreen].bounds.size.height)

@interface BaseViewController : UIViewController<UITextFieldDelegate>
@end
