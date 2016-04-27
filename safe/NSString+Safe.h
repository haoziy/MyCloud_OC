//
//  NSString+Safe.h
//  JDBClient
//
//  Created by You Tu on 15/1/6.
//  Copyright (c) 2015年 JDB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Safe)

- (unichar)safeCharacterAtIndex:(NSUInteger)index;

- (NSString *)safeSubstringToIndex:(NSUInteger)index;

- (NSString *)safeSubstringFromIndex:(NSUInteger)index;
+(NSString *)countNumAndChangeformat:(NSString *)num;
+(NSString*)mrj_sigal_encode:(NSString*)originStr;
@end
