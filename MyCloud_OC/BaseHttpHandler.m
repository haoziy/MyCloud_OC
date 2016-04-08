//
//  BaseHttpHandler.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/6.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "BaseHttpHandler.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "DeBugLog.h"
#import "AppSingleton.h"
@implementation BaseHttpHandler

+(NSString*)urlForApiName:(NSString*)apiName
{
    NSAssert(apiName != nil, @"apiName 名字不能为空");
    return [NSString stringWithFormat:@"%@/%@",[AppSingleton currentEnvironmentBaseURL],apiName];
}

+(void)baseRequestAFNetWorkApi:(ApiNameMap)apiName method:(HttpRequestType)method andHttpHeader:(NSDictionary *)header parameters:(id)parameters prepareExecute:(MRJPrepareExcute)prepare succeed:(MRJSuccessBlock)succeed failed:(MRJFailedBlock)failed;
{
    NSString *url = [self urlForApiName:apiName];
    AFHTTPSessionManager  * manager = [AFHTTPSessionManager manager];
    //请求参数为json数据
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //返回的数据格式为json 数据
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    switch (method) {
        case HttpRequestGet:
        {
            [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@",responseObject);
                succeed(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failed(error);
                 [DeBugLog debugLog:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] line:__LINE__ otherInfo:@"apiName:%@\n%@",url,error.localizedDescription];
            }];
        }
            break;
        case HttpRequestPost:
        {
            [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                succeed(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [DeBugLog debugLog:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] line:__LINE__ otherInfo:@"apiName:%@\n%@",url,error.localizedDescription];
                failed(error);
                
            }];
        }
            break;
        default:
            break;
    }
    
}
@end
