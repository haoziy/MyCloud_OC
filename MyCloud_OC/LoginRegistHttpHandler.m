//
//  LoginRegistHttpHandler.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/26.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "LoginRegistHttpHandler.h"

NSString * const api_loginRegist_heart_beat = @"connect";
NSString * const api_loginRegist_login = @"login";//登录接口,需要的参数细节可以暴露
NSString * const request_loginRegist_login_noticeMessage = @"用户名或者密码错误";//


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
        [MRJAppUtils showProgressMessage:request_progress_loading_message];
    } succeed:^(id obj) {
        if ([obj[request_status_key] integerValue]==0) {
            if (success) {
                success(obj);
            }
            [MRJAppUtils dismissHUD];
        }else
        {
            [MRJAppUtils showErrorMessage:request_loginRegist_login_noticeMessage];
        }
        
        
    } failed:^(id obj) {
        [MRJAppUtils showErrorMessage:request_network_notwork_notice_message];
        if (failed) {
            failed(obj);
        }
    }];
}
@end
