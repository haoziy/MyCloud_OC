//
//  AppSinglon.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/6.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "AppSingleton.h"
#import "MRJStoreManager.h"

@interface AppSingleton()
{
    NSString *privateLastLoginAccount;
    NSString *privateCurrentEnvironment;
    NSString *privateUserInputEnvironment;
}

@end

@implementation AppSingleton

NSString * const baseURL_normal_environment = @"http://app.meirenji.cn/app";
NSString * const baseURL_inner_environment = @"http://192.168.0.21:8082/app";
NSString * const baseURL_develop_environment  = @"http://192.168.0.23:8082/app";
NSString * const baseFormURL_normal_environment  = @"http://member.meirenji.cn/loginReportForm";



+(instancetype)shareInstace
{
    static AppSingleton *varInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        varInstance = [[self alloc]init];
    });
    return varInstance;
}
-(void)setLastLoginMobileOrEmail:(NSString *)value
{
    
    if (value.length>0) {
        privateLastLoginAccount = value;
        [MRJStoreManager saveValue:value forKey:store_last_login_account_key];
    }
}
-(NSString*)lastLoginMobileOrEmail
{
    if (privateLastLoginAccount==nil) {
        return [MRJStoreManager valueWithKey:store_last_login_account_key];
    }else
    {
        return privateLastLoginAccount;
    }
}
-(void)setEnvironmentUrl:(NSString *)environmentUrl
{
    if (environmentUrl.length>0) {
        privateCurrentEnvironment = environmentUrl;
        [MRJStoreManager saveValue:environmentUrl forKey:store_current_enviornment_key];
    }
}
-(NSString*)environmentUrl
{
    if(privateCurrentEnvironment)
    {
        return privateCurrentEnvironment;
    }else
    {
        return [MRJStoreManager valueWithKey:store_current_enviornment_key];
    }
}
-(void)setInputEnvironmentURL:(NSString *)inputEnvironmentURL
{
    if (inputEnvironmentURL.length>0) {
        privateUserInputEnvironment = inputEnvironmentURL;
        [MRJStoreManager saveValue:inputEnvironmentURL forKey:store_last_user_input_key];
    }
}
-(NSString*)inputEnvironmentURL
{
    if (privateUserInputEnvironment) {
        return privateUserInputEnvironment;
    }else
    {
        return [MRJStoreManager valueWithKey:store_last_user_input_key];
    }
}
+(NSString*)currentEnvironmentBaseURL;
{
    return [AppSingleton shareInstace].environmentUrl;
}
@end
