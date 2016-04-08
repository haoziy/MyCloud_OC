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
+(void)baseRequestAFNetWorkApi:(ApiNameMap)apiName method:(HttpRequestType)method andHttpHeader:(NSDictionary *)header parameters:(id)parameters prepareExecute:(MRJPrepareExcute)prepare succeed:(MRJSuccessBlock)succeed failed:(MRJFailedBlock)failed;


@end
