//
//  MRJStoreManager.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/7.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "MRJStoreManager.h"

NSString *const store_current_enviornment_key = @"store_current_enviornment_key";//当前环境key

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
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    if ([value isKindOfClass:[UserEntity class]]) {
//        NSData *data = [NSKeyedArchiver  archivedDataWithRootObject:value];
//        [userDefaults setObject:data forKey:key];
//        [userDefaults synchronize];
//    }else
//    {
//        [userDefaults setObject:value forKey:key];
//    }
    
    
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
