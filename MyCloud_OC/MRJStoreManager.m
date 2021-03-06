//
//  MRJStoreManager.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/7.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "MRJStoreManager.h"

NSString *const store_current_enviornment_key = @"store_current_enviornment_key";//当前环境key
NSString *const store_last_user_input_key = @"store_last_user_input_key";//用户输入环境key
NSString *const store_last_login_account_key = @"store_last_login_account_key";//上次登录账号key
NSString *const store_user_account_id_key = @"store_user_account_id_key";//accountId可以
NSString *const store_user_entity_key = @"store_user_entity_key";//userEntity

@implementation MRJStoreManager

+(void)saveCustomerObject:(id)obj forKey:(NSString *)key
{

    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    if (data) {
        [userDefaults setObject:data forKey:key];
        [userDefaults synchronize];
    }
    
    
}

+(id)customerObjectWithKey:(NSString *)key
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSData * data = [userDefaults objectForKey:key];
    if(data)
    {
        id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return obj;
    }
    else
    {
        return nil;
    }
    return nil;
}

+(void)saveValue:(id) value forKey:(NSString *)key{
    NSAssert(key!=nil, @"key值不能为空");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([value isKindOfClass:[NSString class]]) {
        [userDefaults setObject:value forKey:key];
    }else
    {
        NSData *data = [NSKeyedArchiver  archivedDataWithRootObject:value];
        [userDefaults setObject:data forKey:key];
        [userDefaults synchronize];
    }
}

+(id)valueWithKey:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([[userDefaults objectForKey:key]isKindOfClass:[NSData class]]) {
        NSData *data = [userDefaults objectForKey:key];
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }else
    {
        return [userDefaults objectForKey:key];
    }
}


+(BOOL)boolValueWithKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:key];
}

+(void)saveBoolValue:(BOOL)value withKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:key];
    [userDefaults synchronize];
}
+(void)saveUserEntity:(id)entity forkey:(NSString*)key;
{
    NSAssert(key!=nil, @"key值不能为空");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver  archivedDataWithRootObject:entity];
    [userDefaults setObject:data forKey:key];
    [userDefaults synchronize];
}
+(void)print{
    //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
}

+(void)deleteValueWithKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:key];
    [userDefaults synchronize];
}
@end
