//
//  NSString+global.m
//  EachPlan
//
//  Created by ZEROLEE on 16/3/25.
//  Copyright © 2016年 XiaoZhou. All rights reserved.
//

#import "NSString+global.h"

@implementation NSString (global)

+(NSString*)global_globalString:(NSString*)key tableName:(NSString*)table;
{
    NSString *str = NSLocalizedStringFromTable(key, table, nil);
    NSAssert(str.length!=0, @"未找到对应国际化名称");
    return str;
    
}

+(NSString*)global_tableName:(NSString*)table globalStrings:(NSString *)keys, ...
{
    return nil;
}

+(NSString*)global_defaultGlobalString:(NSString *)key;
{
    
    NSString *str =  NSLocalizedString(key, nil);
    NSAssert(str.length!=0, @"未找到对应国际化名称");
    return str;
}
+(NSString*)global_defaultMutableGlobalStrings:(NSString*)keys,...;
{
    return nil;
}
@end
