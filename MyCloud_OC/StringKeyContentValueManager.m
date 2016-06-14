//
//  LanguageManager.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/6.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "StringKeyContentValueManager.h"
#import "NSString+global.h"

@implementation StringKeyContentValueManager

NSString *const global_loginMudels_fileName = @"LoginRegistLanguage";//登录模块的国际化文件名
NSString *const global_homeMudels_fileName = @"HomeLanguage";//首页模块的国际化文件名
NSString *const global_discoveryMudels_fileName = @"DiscoverLanguage";//发现模块的国际化文件名
NSString *const global_aboutMudels_fileName = @"AboutMeLanguage";//关于模块的国际化文件名
NSString *const global_formsMudels_fileName = @"FormsLanguage";//报表模块的国际化文件名
NSString *const global_commonLanguage_fileName = @"commonLanguage";//共同部分国际化文件名
//通用的等待网络请求提示
NSString * const language_commen_waitProgressNotice = @"正在加载......";//等待网络请求提示语

NSString * const language_commen_cancelBtnName = @"取消";//通用取消按钮名
NSString * const language_commen_confirmBtnName = @"确定";//通用确定按钮名
NSString * const language_commen_nextBtnName = @"下一步";//下一步按钮名
NSString * const language_commen_noticeStrig = @"提示";//提示

+(NSString*)languageValueForKey:(NSString*)key;
{
    NSAssert(key.length!=0, @"键值不存在");
    return key;
}
+(NSString*)languageValueIntable:(NSString*) tableName key:(NSString *)key;
{
    NSAssert(key.length!=0, @"键值不合法");
    NSAssert(tableName.length!=0, @"国际化表名字不合法");
    return [NSString global_globalString:key tableName:tableName];
}

+(NSString*)loginRegistLanguageValueForKey:(NSString*)key;
{
    return [self languageValueIntable:global_loginMudels_fileName key:key];
}
+(NSString*)homeLanguageValueForKey:(NSString*)key;
{
    return [self languageValueIntable:global_homeMudels_fileName key:key];
}
+(NSString*)discoveryLanguageValueForKey:(NSString*)key;
{
    return [self languageValueIntable:global_discoveryMudels_fileName key:key];
}
+(NSString*)formsLanguageValueForKey:(NSString*)key;
{
    return [self languageValueIntable:global_formsMudels_fileName key:key];
}
+(NSString*)aboutLanguageValueForKey:(NSString*)key;
{
    return [self languageValueIntable:global_aboutMudels_fileName key:key];
}
+(NSString*)commonLanguageValueForKey:(NSString*)key;
{
    return [self languageValueIntable:global_commonLanguage_fileName key:key];
}
@end
