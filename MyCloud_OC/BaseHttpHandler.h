//
//  BaseHttpHandler.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/6.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpHandlerApi.h"

@interface BaseHttpHandler : NSObject
//请求成功的block.使用带参的block传值
typedef void(^MRJSuccessBlock)(id obj);
//请求失败的block.使用带参的block传值
typedef void(^MRJFailedBlock)(id obj);

//请求开始前预处理Block
typedef void(^MRJPrepareExcute)(void);


typedef NS_ENUM(NSInteger, HttpRequestType) {
    HttpRequestGet = 0,
    HttpRequestPost = 1,
    HttpRequestDelete = 2,
    HttpRequestPut = 3,
};

extern NSString * const request_status_key;//http请求keystatus
extern NSString * const request_data_key;//http请求keydata
extern NSString * const request_progress_loading_message;//http请求loading提示语
extern NSString * const request_network_notwork_notice_message;//没有网络提示语
extern NSString * const request_operation_success_notice_message;//操作成功提示
extern NSString * const request_operation_failed_notice_message;//操作不成功提示
+(void)baseRequestAFNetWorkApi:(ApiNameMap)apiName method:(HttpRequestType)method andHttpHeader:(NSDictionary *)header parameters:(id)parameters prepareExecute:(MRJPrepareExcute)prepare succeed:(MRJSuccessBlock)succeed failed:(MRJFailedBlock)failed;


+(void)baseRequestAFNetWorkFullURL:(NSString*)fullURL method:(HttpRequestType)method andHttpHeader:(NSDictionary *)header parameters:(id)parameters prepareExecute:(MRJPrepareExcute)prepare succeed:(MRJSuccessBlock)succeed failed:(MRJFailedBlock)failed;
@end
