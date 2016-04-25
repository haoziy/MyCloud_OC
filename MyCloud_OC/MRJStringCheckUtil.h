//
//  MRJStringCheckUtil.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/25.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  字符校验
 */
@interface MRJStringCheckUtil : NSObject

/**
 *  校验大陆手机号是否是合法手机号
 *
 *  @param phoneNumber 手机号号码
 *
 *  @return 是否是合法手机号号码
 */
+(BOOL)checkPhoneNumber:(NSString *)phoneNumber;

/**
 *  校验邮箱是否是合法邮箱
 *
 *  @param email 邮箱地址
 *
 *  @return 是否合法
 */
+(BOOL)isValidateEmail:(NSString *)email;
@end
