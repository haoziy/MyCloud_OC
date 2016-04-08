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
@implementation LoginRegistStringValueContentManager

+(NSString*)languageValueForKey:(NSString *)key
{
    return [self loginRegistLanguageValueForKey:key];
}
@end
