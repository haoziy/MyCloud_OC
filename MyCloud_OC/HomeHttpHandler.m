//
//  HomeHttpHandler.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/26.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "HomeHttpHandler.h"
#import "DeviceModel.h"
ApiNameMap api_home_get_device_list = @"device/list";//获取设备列表
ApiNameMap api_home_get_device_detail = @"device/info";//设备详情;
ApiNameMap api_home_save_device_params = @"device/base";//保存设备参数
ApiNameMap api_home_delete_device_net_cmd = @"device/delnet";//删除网络配置命令
ApiNameMap api_home_reboot_device_cmd = @"device/reboot";//重启设备命令
ApiNameMap api_home_catch_current_image_cmd = @"device/grap";//实时抓图命令
ApiNameMap api_home_get_current_image_url = @"device/img";//获取图像的url;
ApiNameMap api_home_check_device_online_status = @"device/state";//查询在线状态
ApiNameMap api_home_upload_config_log = @"device/log";//上传网络配置日志
ApiNameMap api_home_device_auth = @"device/auth";//获取授权地址
NSString* const key_offLineDeviceKey = @"offline";//离线设备key
NSString* const key_onLineDeviceKey = @"online";//在线线设备key

@implementation HomeHttpHandler
+(void)home_checkDeviceOnlineStatus:(NSDictionary*)param preExecute:(MRJPrepareExcute)preExecute success:(MRJSuccessBlock)succes failed:(MRJFailedBlock)failed;
{
    [self baseRequestAFNetWorkApi:api_home_check_device_online_status method:HttpRequestPost andHttpHeader:nil parameters:param prepareExecute:^{
    
    } succeed:^(id obj) {
        succes(obj);
    } failed:^(id obj) {
        failed(obj);
    }];
}
+(void)getDeviceListParams:(NSDictionary*)parm preExecute:(MRJPrepareExcute)preExecute success:(MRJSuccessBlock)succes failed:(MRJFailedBlock)failed;
{
    [self baseRequestAFNetWorkApi:api_home_get_device_list method:HttpRequestPost andHttpHeader:nil parameters:parm prepareExecute:^{
        [MRJAppUtils showProgressMessage:[StringKeyContentValueManager commonLanguageValueForKey:request_progress_loading_message]];
    } succeed:^(id obj) {
        NSMutableArray *onlineArr = [[NSMutableArray alloc]init];
        NSMutableArray *offlineArr = [[NSMutableArray alloc]init];
        if ([obj[request_status_key] integerValue]==0) {
            for (id item  in obj[request_data_key]) {
                DeviceModel *model = [DeviceModel modelWithJSON:item];
                if (model.onLine==YES) {
                    [onlineArr addObject:model];
                }else
                {
                    [offlineArr addObject:model];
                }
            }
        }
        NSArray* parseData = @[onlineArr,offlineArr];
        if(onlineArr.count==0&&offlineArr.count==0)
        {
            succes(nil);
        }else
        {
            succes(parseData);
        }
        
        [MRJAppUtils dismissHUD];
    } failed:^(id obj) {
        if (failed) {
            failed(obj);
        }
         [MRJAppUtils showErrorMessage:request_network_notwork_notice_message];
    }];
}
+(void)getDeviceDetail:(NSDictionary*)param preExecute:(MRJPrepareExcute)preExecute success:(MRJSuccessBlock)success failed:(MRJFailedBlock)failed;
{
    [self baseRequestAFNetWorkApi:api_home_get_device_detail method:HttpRequestPost andHttpHeader:nil parameters:param prepareExecute:^{
        [MRJAppUtils showProgressMessage:[StringKeyContentValueManager commonLanguageValueForKey:request_progress_loading_message]];
    } succeed:^(id obj) {
        if ([obj[request_status_key] integerValue]==0) {
            DeviceModel *model = [DeviceModel modelWithJSON:obj[request_data_key]];
            success(model);
        }else
        {
            
        }
        [MRJAppUtils dismissHUD];
    } failed:^(id obj) {
        if (failed) {
            failed(obj);
        }
    }];
}
+(void)home_saveDeviceParams:(NSDictionary*)param preExecute:(MRJPrepareExcute)preExecute success:(MRJSuccessBlock)succes failed:(MRJFailedBlock)failed;
{
    [self baseRequestAFNetWorkApi:api_home_save_device_params method:HttpRequestPost andHttpHeader:nil parameters:param prepareExecute:^{
        [MRJAppUtils showProgressMessage:[StringKeyContentValueManager commonLanguageValueForKey:request_progress_loading_message]];
    }  succeed:^(id obj) {
        if ([obj[request_status_key] integerValue]==0)
        {
            if (succes) {
                succes(obj);
            }
            [MRJAppUtils showSuccessMessage:request_operation_success_notice_message];
        }else
        {
            [MRJAppUtils showErrorMessage:request_operation_failed_notice_message];
        }
    } failed:^(id obj) {
        if (failed) {
            failed(obj);
        }
        [MRJAppUtils showErrorMessage:request_operation_failed_notice_message];
    }];
}
+(void)home_deleteNetWorkCMD:(NSDictionary*)param preExecute:(MRJPrepareExcute)preExecute success:(MRJSuccessBlock)succes failed:(MRJFailedBlock)failed;
{
    [self baseRequestAFNetWorkApi:api_home_delete_device_net_cmd method:HttpRequestPost andHttpHeader:nil parameters:param prepareExecute:^{
        [MRJAppUtils showProgressMessage:[StringKeyContentValueManager commonLanguageValueForKey:request_progress_loading_message]];
    }  succeed:^(id obj) {
        if ([obj[request_status_key] integerValue]==0)
        {
            if (succes) {
                succes(obj);
            }
            [MRJAppUtils showSuccessMessage:request_operation_success_notice_message];
        }else
        {
            [MRJAppUtils showErrorMessage:request_operation_failed_notice_message];
        }
    } failed:^(id obj) {
        if (failed) {
            failed(obj);
        }
        [MRJAppUtils showErrorMessage:request_network_notwork_notice_message];
    }];
}
+(void)home_catchImageURL:(NSDictionary *)param preExecute:(MRJPrepareExcute)preExecute success:(MRJSuccessBlock)succes failed:(MRJFailedBlock)failed
{
    [self baseRequestAFNetWorkApi:api_home_get_current_image_url method:HttpRequestPost andHttpHeader:nil parameters:param prepareExecute:^{
        [MRJAppUtils showProgressMessage:[StringKeyContentValueManager commonLanguageValueForKey:request_progress_loading_message]];
    }  succeed:^(id obj) {
        if (succes) {
            succes(obj);
        }
    } failed:^(id obj) {
        
        if (failed) {
            failed(obj);
        }
        [MRJAppUtils showErrorMessage:request_network_notwork_notice_message];
    }];
}
+(void)home_rebootDeviceCMD:(NSDictionary *)param preExecute:(MRJPrepareExcute)preExecute success:(MRJSuccessBlock)succes failed:(MRJFailedBlock)failed
{
    [self baseRequestAFNetWorkApi:api_home_reboot_device_cmd method:HttpRequestPost andHttpHeader:nil parameters:param prepareExecute:^{
        [MRJAppUtils showProgressMessage:[StringKeyContentValueManager commonLanguageValueForKey:request_progress_loading_message]];
    }  succeed:^(id obj) {
        if ([obj[request_status_key] integerValue]==0)
        {
            if (succes) {
                succes(obj);
            }
            [MRJAppUtils showSuccessMessage:request_operation_success_notice_message];
        }else
        {
            [MRJAppUtils showErrorMessage:request_operation_failed_notice_message];
        }
    } failed:^(id obj) {
        if (failed) {
            failed(obj);
        }
        [MRJAppUtils showErrorMessage:request_network_notwork_notice_message];
    }];
}
+(void)home_captureImageCMD:(NSDictionary *)param preExecute:(MRJPrepareExcute)preExecute success:(MRJSuccessBlock)succes failed:(MRJFailedBlock)failed
{
    [self baseRequestAFNetWorkApi:api_home_catch_current_image_cmd method:HttpRequestPost andHttpHeader:nil parameters:param prepareExecute:^{
        [MRJAppUtils showProgressMessage:[StringKeyContentValueManager commonLanguageValueForKey:request_progress_loading_message]];
    }  succeed:^(id obj) {
        if ([obj[request_status_key] integerValue]==0)
        {
            if (succes) {
                succes(obj);
            }
        }else
        {
            [MRJAppUtils showErrorMessage:request_operation_failed_notice_message];
        }
    } failed:^(id obj) {
        if (failed) {
            failed(obj);
        }
    }];
}
+(void)home_uploadConfigLog:(NSDictionary*)param preExecute:(MRJPrepareExcute)preExecute success:(MRJSuccessBlock)succes failed:(MRJFailedBlock)failed;
{
    [self baseRequestAFNetWorkApi:api_home_upload_config_log method:HttpRequestPost andHttpHeader:nil parameters:param prepareExecute:^{
        
    } succeed:^(id obj) {
        if(succes)
        {
            succes(obj);
        }
    } failed:^(id obj) {
        if (failed) {
           failed(obj); 
        }
        
    }];
}
+(void)home_deviceAuth:(NSDictionary*)param preExecute:(MRJPrepareExcute)preExecute success:(MRJSuccessBlock)succes failed:(MRJFailedBlock)failed;
{
    [self baseRequestAFNetWorkApi:api_home_device_auth method:HttpRequestPost andHttpHeader:nil parameters:param prepareExecute:^{
        [MRJAppUtils showProgressMessage:[StringKeyContentValueManager commonLanguageValueForKey:request_progress_loading_message]];
    }  succeed:^(id obj) {
        if (succes) {
            succes(obj);
        }
        [MRJAppUtils dismissHUD];
    } failed:^(id obj) {
        if (failed) {
            failed(obj);
        }
    }];
}
@end
