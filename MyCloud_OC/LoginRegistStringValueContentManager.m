//
//  LoginRegistStringValueContentManager.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/8.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "LoginRegistStringValueContentManager.h"
NSString * const language_login_title = @"每人计";
NSString * const language_login_accountPlacement = @"请输入邮箱/手机号";//登录账号占位字符串

NSString * const language_login_ipAddressPlacement = @"请输入IP地址";//登录界面IP地址输入占位符
NSString * const language_login_portPlacement = @"请输入端口号";//登录界面端口输入占位符
NSString * const language_login_passwordPlacement = @"请输入密码";//登录界面密码占位符
NSString * const language_login_domainPlacement = @"请输入域名";//登录界面域名占位符
@implementation LoginRegistStringValueContentManager

+(NSString*)languageValueForKey:(NSString *)key
{
    return [self loginRegistLanguageValueForKey:key];
}
@end
