//
//  LanguageManager.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/6.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const language_login_title;

/**
 *  各个模块国际化的文件名,此目的是为了把各个模块UI展示层面之间的耦合度降低,以后维护的时候只在单一模块里操作,避免每次修改都牵扯到整个app,
 此外,为了不让逻辑代码里出现硬字符,还应该配合对应模块StringKeyContentValueManager文件获取对应的国际化字符再通过该字符映射国际化字符
 字符字面key____字符字面量映射____->字符key字面量内容____国际化映射表______>最终UI展示字符
 @ 例如:
 key:language_login_title(多语言_模块名_标题) 对应的 contentValue 是 每人计
 每人计在登录模块对应的国际化strings文件中映射了三个值 英文版:EveryCount 简体:每人计 繁体:每人計,在不同的语言环境下各自展示,
 */
extern NSString *const global_loginMudels_fileName;//登录模块的国际化文件名
extern NSString *const global_homeMudels_fileName;//首页模块的国际化文件名
extern NSString *const global_discoveryMudels_fileName;//发现模块的国际化文件名
extern NSString *const global_aboutMudels_fileName;//关于模块的国际化文件名
extern NSString *const global_formsMudels_fileName;//报表模块的国际化文件名

@interface StringKeyContentValueManager : NSObject

+(NSString*)languageValueForKey:(NSString*)key;//

+(NSString*)loginRegistLanguageValueForKey:(NSString*)key;
+(NSString*)homeLanguageValueForKey:(NSString*)key;
+(NSString*)discoveryLanguageValueForKey:(NSString*)key;
+(NSString*)formsLanguageValueForKey:(NSString*)key;
+(NSString*)aboutLanguageValueForKey:(NSString*)key;
@end
