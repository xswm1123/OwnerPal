//
//  UIImage+Ext.h
//  flowerong
//
//  Created by mac on 14-6-9.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (UIImageExt)

-(UIImage*)imageByScaleForSize:(CGSize)size;

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset;

- (UIImage *)fixOrientation;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
