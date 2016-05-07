//
//  LoginRegistHttpHandler.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/26.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "BaseHttpHandler.h"
/**
 *  @param nil
 *  @discription 切换云时候的心跳接口;
 *
 */
extern ApiNameMap api_loginRegist_heart_beat;//切换云心跳测试接口

extern NSString * const request_loginRegist_login_noticeMessage;//提示语
/**
 *  登录接口
 */
extern NSString * const api_loginRegist_login;//登录接口
@interface LoginRegistHttpHandler : BaseHttpHandler

/**
 *  测试心跳,
 *
 *  @param apiName apiName
 *  @param success 成功block
 *  @param failed  失败block
 */
+(void)login_checkHeartBeatFullURL:(NSString*)fullURL preExecute:(MRJPrepareExcute) preExecute successBlock:(MRJSuccessBlock) success failedBlock:(MRJFailedBlock)failed;


+(void)login_loginWithParams:(NSDictionary*)param preExecute:(MRJPrepareExcute) preExecute successBlock:(MRJSuccessBlock) success failedBlock:(MRJFailedBlock)failed;
@end
