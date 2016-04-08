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
@end
