//
//  NSString+global.h
//  EachPlan
//
//  Created by ZEROLEE on 16/3/25.
//  Copyright © 2016年 XiaoZhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (global)

/**
 *  国际化
 *
 *  @param key   key
 *  @param table 表名字,localString文件名
 *
 *  @return 国际化后的字符串
 */
+(NSString*)global_globalString:(NSString*)key tableName:(NSString*)table;
/**
 *  多个词连接的国际化
 *
 *  @param table 表名字
 *  @param keys  keys
 *
 *  @return 国际化后拼接的字符串
 */
+(NSString*)global_tableName:(NSString*)table globalStrings:(NSString *)keys, ...;

/**
 *  默认文件名形式的国际化
 *
 *  @param key key
 *
 *  @return 国际化后的字符串
 */
+(NSString*)global_defaultGlobalString:(NSString *)key;

/**
 *  多个词拼接的国际化
 *
 *  @param keys keys
 *
 *  @return 国际化后的字符串
 */
+(NSString*)global_defaultMutableGlobalStrings:(NSString*)keys,...;
@end
