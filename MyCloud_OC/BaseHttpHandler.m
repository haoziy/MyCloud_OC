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
NSString * const request_status_key = @"status";//http请求keystatus
NSString * const request_data_key = @"data";//http 请求数据字段
@implementation BaseHttpHandler

+ (NSString *)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state =  @"2G";
                    break;
                case 2:
                    state =  @"3G";
                    break;
                case 3:
                    state =   @"4G";
                    break;
                case 5:
                {
                    state =  @"wifi";
                    break;
                default:
                    break;
                }
            }
        }
        //根据状态选择
       
    }
    return state;
}

+(NSString*)urlForApiName:(NSString*)apiName
{
    NSAssert(apiName != nil, @"apiName 名字不能为空");
    return [NSString stringWithFormat:@"%@%@",[AppSingleton currentEnvironmentBaseURL],apiName];
}
+(NSDictionary*)attchBaseParams:(NSDictionary*)params
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    for (NSString *key in [params allKeys]) {
        [dict setObject:params[key] forKey:key];
    }
    
    [dict setObject:[UIDevice currentDevice].machineModelName forKey:@"models"];
    [dict setObject:@"IOS" forKey:@"OS"];
    [dict setObject:[NSTimeZone systemTimeZone].name forKey:@"timezone"];
    NSLocale *currentLocale = [NSLocale currentLocale];
    [dict setObject:currentLocale.localeIdentifier forKey:@"language"];
    [dict setObject:[self getNetWorkStates] forKey:@"network"];

    [dict setObject:[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"]  forKey:@"version"];
    return dict;
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
            NSMutableURLRequest *req = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
            [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [req setHTTPMethod:@"POST"];
            NSDictionary *realPara = [self attchBaseParams:(NSDictionary*)parameters];
            [req setValue:[NSString mrj_sigal_encodeWithData:realPara] forHTTPHeaderField:@"signal"];
            [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:realPara options:NSJSONWritingPrettyPrinted error:nil]];
        
            
           
            
            [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                
                if (!error) {
                    if ([NSJSONSerialization isValidJSONObject:responseObject]) {
                        succeed(responseObject);
                    }else
                    {
                        id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
                        succeed(result);
                    }
                    
                } else {
                    [DeBugLog debugLog:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] line:__LINE__ otherInfo:@"apiName:%@\n%@",url,error.localizedDescription];
                    failed(error);
                }
            }] resume];
        }
            break;
        default:
            break;
    }
}
+(void)baseRequestAFNetWorkFullURL:(NSString*)fullURL method:(HttpRequestType)method andHttpHeader:(NSDictionary *)header parameters:(id)parameters prepareExecute:(MRJPrepareExcute)prepare succeed:(MRJSuccessBlock)succeed failed:(MRJFailedBlock)failed;
{
    NSString *url = fullURL;
    
    AFHTTPSessionManager  * manager = [AFHTTPSessionManager manager];
    //请求参数为json数据
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //返回的数据格式为json 数据
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
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
            NSMutableURLRequest *req = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:fullURL]];
            [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            
            [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                
                if (!error) {
                    id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
                    succeed(result);
                } else {
                    [DeBugLog debugLog:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] line:__LINE__ otherInfo:@"apiName:%@\n%@",url,error.localizedDescription];
                    failed(error);
                }
            }] resume];
        }
            break;
        default:
            break;
    }
    

}
@end
