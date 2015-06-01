//
//  ServerConfig.h
//  ffcsdemo
//
//  Created by hesh on 13-9-12.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

#ifndef ownerPal_H
#define DEFINE_SUCCESSCODE @"000011"
#define DEFINE_DESCRIPTION @"000051"
// 根路径
//测试环境
//地址1 www.tangusoft.com/t5
#define BASE_SERVERLURL @"http://www.tangusoft.com/"
//地址2
//#define BASE_SERVERLURL @"http://112.124.46.15/"
//地址3 http://121.40.174.204/t5
//#define BASE_SERVERLURL @"http://121.40.174.204/"


//// 图片上传路径
#define UPLOAD_PIC_URL @""



#define URL_UPDATING_APP @"itms-services://?action=download-manifest&url=https://bee.doone.com.cn/client/hphwd.plist"


//common Path
#define URL_COMMEN_PATH @"t5/mobileApp"
// gmm


#define IOS8_OR_LATER ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
#define IOS7_OR_LATER ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS6_OR_LATER ( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )

#define ShareAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#endif
