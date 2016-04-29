//
//  HomeResourceManager.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/8.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "HomeResourceManager.h"

NSString *const  deviceImageName = @"device_mrj";
NSString *const  paramArrow = @"arrow_left2";
NSString *const  backIconArrow = @"arrowleft";
NSString *const  selected = @"select";
NSString *const  unSelected = @"select_white";
@implementation HomeResourceManager
+(UIImage*)home_searchDeviceLogo;
{
    return [self imageForKey:deviceImageName];
}

+(UIImage*)home_deviceParamArrow;
{
    return [self imageForKey:paramArrow];
}
+(UIImage*)home_searchBackIcon;
{
    return [self imageForKey:backIconArrow];
}
+(UIImage*)home_configNetBackIcon;
{
    return [self home_searchBackIcon];
}
/**
 *  配置网选中按钮
 *
 *  @return
 */
+(UIImage*)home_configNetSelectedBtnImage;
{
    return [self imageForKey:selected];
}
/**
 *  配置网络未选中按钮image
 *
 *  @return
 */
+(UIImage*)home_configNetUnSelectedBtnImage;
{
    return [self imageForKey:unSelected];
}
@end
