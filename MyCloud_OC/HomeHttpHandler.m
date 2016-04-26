//
//  HomeHttpHandler.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/26.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "HomeHttpHandler.h"
ApiNameMap api_home_get_device_list = @"devicelist";//获取设备列表

@implementation HomeHttpHandler

+(void)getDeviceListParams:(NSDictionary*)parm preExecute:(MRJPrepareExcute)preExecute success:(MRJSuccessBlock)succes failed:(MRJFailedBlock)failed;
{
    [self baseRequestAFNetWorkApi:api_home_get_device_list method:HttpRequestPost andHttpHeader:nil parameters:parm prepareExecute:^{
        
    } succeed:^(id obj) {
        succes(obj);
    } failed:^(id obj) {
        failed(obj);
    }];
}
@end
