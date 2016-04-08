//
//  DeBugLog.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/6.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeBugLog : NSObject
/**
 *  debug日志信息
 *
 *  @param fileName 文件名
 *  @param line     行数
 *  @param others        其他信息
 */
+(void)debugLog:(NSString*)fileName line:(NSInteger)line otherInfo:(NSString*)others,...;

@end
