//
//  HomeStringKeyContentValueManager.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/8.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "HomeStringKeyContentValueManager.h"
@implementation HomeStringKeyContentValueManager

NSString * const language_homeDeviceManagerTitle = @"设备管理";//设备管理标题
NSString * const language_homeDeviceManagerExitCurrentCloudTitle = @"退出";

NSString * const language_homeDeviceManagerConfigNetButtonName = @"配置网络";//配置网络按钮名
NSString * const language_homeDeviceManagerDelNetButtonName = @"删除网络";//删除网络按钮名
+(NSString*)languageValueForKey:(NSString *)key
{
    return [self homeLanguageValueForKey:key];
}
@end
