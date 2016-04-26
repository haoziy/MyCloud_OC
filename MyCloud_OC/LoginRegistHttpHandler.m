//
//  LoginRegistHttpHandler.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/26.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "LoginRegistHttpHandler.h"

NSString * const api_loginRegist_heart_beat = @"heart.do";
NSString * const api_loginRegist_login = @"login.do";//登录接口,需要的参数细节可以暴露

@implementation LoginRegistHttpHandler

+(void)login_checkHeartBeatFullURL:(NSString*)fullURL preExecute:(MRJPrepareExcute) preExecute successBlock:(MRJSuccessBlock) success failedBlock:(MRJFailedBlock)failed;
{
    [self baseRequestAFNetWorkFullURL:fullURL method:HttpRequestPost andHttpHeader:nil parameters:nil prepareExecute:^{
    } succeed:^(id obj) {
        success(obj);
    } failed:^(id obj) {
        failed(obj);
    }];
}

+(void)login_loginWithParams:(NSDictionary*)param preExecute:(MRJPrepareExcute) preExecute successBlock:(MRJSuccessBlock) success failedBlock:(MRJFailedBlock)failed;
{
    [self baseRequestAFNetWorkApi:api_loginRegist_login method:HttpRequestPost andHttpHeader:nil parameters:param prepareExecute:^{
    } succeed:^(id obj) {
        success(obj);
    } failed:^(id obj) {
        failed(obj);
    }];
}
@end
