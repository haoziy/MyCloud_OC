//
//  MRJResourceManager.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/8.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "MRJResourceManager.h"

@implementation MRJResourceManager
+(UIImage*)imageForKey:(NSString*)key;
{
    NSAssert(key.length!=0, @"图片名不合法");
    UIImage *img = [UIImage imageNamed:key];
    NSAssert(img!=nil, @"图片名为%@的图片不存在",key);
    return img;
}
//根据颜色得到图片
+(UIImage *)buttonImageFromColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //    UIGraphicsPushContext(context);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
