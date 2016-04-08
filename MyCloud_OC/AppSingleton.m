//
//  AppSinglon.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/6.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "AppSingleton.h"
#import "MRJStoreManager.h"

@implementation AppSingleton

NSString * const baseURL_normal_environment = @"http://app1.meirenji.cn/app";
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

-(NSString*)environmentUrl
{
    if ([MRJStoreManager valueWithKey:store_current_enviornment_key]) {
        return [MRJStoreManager valueWithKey:store_current_enviornment_key];
    }else{
        return baseURL_normal_environment;
    }
}
+(NSString*)currentEnvironmentBaseURL;
{
    return [AppSingleton shareInstace].environmentUrl;
}
@end
