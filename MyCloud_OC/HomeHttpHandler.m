//
//  HomeHttpHandler.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/26.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "HomeHttpHandler.h"
#import "DeviceModel.h"
ApiNameMap api_home_get_device_list = @"myDeviceList.do";//获取设备列表

NSString* const key_offLineDeviceKey = @"offline";//离线设备key
NSString* const key_onLineDeviceKey = @"online";//在线线设备key

@implementation HomeHttpHandler

+(void)getDeviceListParams:(NSDictionary*)parm preExecute:(MRJPrepareExcute)preExecute success:(MRJSuccessBlock)succes failed:(MRJFailedBlock)failed;
{
    [self baseRequestAFNetWorkApi:api_home_get_device_list method:HttpRequestPost andHttpHeader:nil parameters:parm prepareExecute:^{
    } succeed:^(id obj) {
        id parseData;
        if (obj) {
            int status = [obj[@"status"] intValue];
            NSString *msg = obj[@"msg"];
            
            if (status == 0) {
                
                NSDictionary *result = obj[@"result"];
                NSArray *unonline = result[@"unonline"];
                NSArray *online = result[@"online"];
                
                NSMutableArray *unonlineArray = [NSMutableArray array];
                for (NSDictionary *dict in unonline) {
                    DeviceModel *model = [DeviceModel initWithDeviceId:dict[@"deviceId"] imei:dict[@"imei"] alias:dict[@"alias"] onLine:dict[@"online"] initBind:dict[@"initBind"] initNetwork:dict[@"initNetwork"] modeId:dict[@"modeId"]==nil?@"":dict[@"modeId"] modeName:dict[@"modename"]==nil?@"":dict[@"modename"]lens:@"" netName:@"" path:@"" shopId:dict[@"shopId"] shopName:dict[@"shopname"] wayId:dict[@"wayId"] wayName:dict[@"wayname"] height:@"" bindId:dict[@"bindId"] softVersion:nil imsi:dict[@"imsi"]==nil?@"":dict[@"imsi"] wifi:dict[@"wifi"]==nil?@"":dict[@"wifi"]];
                    model.softVersion = [((NSString*)dict[@"softVersion"]) stringByReplacingOccurrencesOfString:@"." withString:@""];
                    model.netType = dict[@"netType"];
                    [unonlineArray addObject:model];
                }
                
                NSMutableArray *onlineArray = [NSMutableArray array];
                for (NSDictionary *dict in online) {
                    DeviceModel *model = [DeviceModel initWithDeviceId:dict[@"deviceId"] imei:dict[@"imei"] alias:dict[@"alias"] onLine:dict[@"online"] initBind:dict[@"initBind"] initNetwork:dict[@"initNetwork"] modeId:dict[@"modeId"]==nil?@"":dict[@"modeId"] modeName:dict[@"modename"]==nil?@"":dict[@"modename"]lens:@"" netName:@"" path:@"" shopId:dict[@"shopId"] shopName:dict[@"shopname"] wayId:dict[@"wayId"] wayName:dict[@"wayname"] height:@"" bindId:dict[@"bindId"] softVersion:nil imsi:dict[@"imsi"]==nil?@"":dict[@"imsi"] wifi:dict[@"wifi"]==nil?@"":dict[@"wifi"]];
                    model.softVersion = [((NSString*)dict[@"softVersion"]) stringByReplacingOccurrencesOfString:@"." withString:@""];
                    model.netType = dict[@"nettype"];
                    [onlineArray addObject:model];
                }
                
                parseData = @{@"offline":unonlineArray,@"online":onlineArray};
            }else{
                parseData = msg;
            }
            succes(parseData);
        }
    } failed:^(id obj) {
        failed(obj);
    }];
}
@end
