//
//  MRJStoreManager.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/7.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const store_current_enviornment_key;//当前环境key

extern NSString *const store_last_user_input_key;//用户输入环境key
extern NSString *const store_last_login_account_key;//上次登录账号key




@interface MRJStoreManager : NSObject

+(void)saveCustomerObject:(id)obj forKey:(NSString *)key;

+(id)customerObjectWithKey:(NSString *)key;

+(void)saveValue:(id) value forKey:(NSString *)key;

+(id)valueWithKey:(NSString *)key;

+(BOOL)boolValueWithKey:(NSString *)key;

+(void)saveBoolValue:(BOOL)value withKey:(NSString *)key;

+(void)print;

+(void)deleteValueWithKey:(NSString *)key;
@end
