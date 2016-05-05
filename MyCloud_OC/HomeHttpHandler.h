//
//  HomeHttpHandler.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/26.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "BaseHttpHandler.h"

extern ApiNameMap api_home_get_device_list;//获取设备列表
extern ApiNameMap api_home_get_device_detail;//设备详情;
extern ApiNameMap api_home_save_device_params;//保存设备参数
extern ApiNameMap api_home_delete_device_net_cmd;//删除网络配置命令
extern ApiNameMap api_home_reboot_device_cmd;//重启设备命令
extern ApiNameMap api_home_catch_current_image_cmd;//实时抓图命令
extern ApiNameMap api_home_get_current_image_url;//获取图像的url;
extern ApiNameMap api_home_check_device_online_status;//检查设备在线状态
extern ApiNameMap api_home_upload_config_log;//上传网络配置日志
extern ApiNameMap api_home_device_auth;//设备授权

extern NSString* const key_offLineDeviceKey;//离线设备key
extern NSString* const key_onLineDeviceKey;//在线线设备key


@interface HomeHttpHandler : BaseHttpHandler

/**
 *  获取设备列表
 *
 *  @param parm       参数列表
 *  @param preExecute response回来之前执行的操作
 *  @param succes     成功block
 *  @param failed     失败block
 */
+(void)getDeviceListParams:(NSDictionary*)parm preExecute:(MRJPrepareExcute)preExecute success:(MRJSuccessBlock)succes failed:(MRJFailedBlock)failed;
/**
 *  获取设备详情
 *
 *  @param param      参数列表
 *  @param preExecute <#preExecute description#>
 *  @param success    <#success description#>
 *  @param failed     <#failed description#>
 */
+(void)getDeviceDetail:(NSDictionary*)param preExecute:(MRJPrepareExcute)preExecute success:(MRJSuccessBlock)success failed:(MRJFailedBlock)failed;

/**
 *  保存设备参数
 *
 *  @param param      参数列表
 *  @param preExecute <#preExecute description#>
 *  @param succes     <#succes description#>
 *  @param failed     <#failed description#>
 */
+(void)home_saveDeviceParams:(NSDictionary*)param preExecute:(MRJPrepareExcute)preExecute success:(MRJSuccessBlock)succes failed:(MRJFailedBlock)failed;
/**
 *  删除网络配置命令
 *
 *  @param param      <#param description#>
 *  @param preExecute <#preExecute description#>
 *  @param succes     <#succes description#>
 *  @param failed     <#failed description#>
 */
+(void)home_deleteNetWorkCMD:(NSDictionary*)param preExecute:(MRJPrepareExcute)preExecute success:(MRJSuccessBlock)succes failed:(MRJFailedBlock)failed;


/**
 *  重启设备命令
 *
 *  @param param      <#param description#>
 *  @param preExecute <#preExecute description#>
 *  @param succes     <#succes description#>
 *  @param failed     <#failed description#>
 */
+(void)home_rebootDeviceCMD:(NSDictionary*)param preExecute:(MRJPrepareExcute)preExecute success:(MRJSuccessBlock)succes failed:(MRJFailedBlock)failed;

/**
 *  抓图命令
 *
 *  @param param      <#param description#>
 *  @param preExecute <#preExecute description#>
 *  @param succes     <#succes description#>
 *  @param failed     <#failed description#>
 */
+(void)home_captureImageCMD:(NSDictionary*)param preExecute:(MRJPrepareExcute)preExecute success:(MRJSuccessBlock)succes failed:(MRJFailedBlock)failed;

/**
 *  获取实时图像的URL
 *
 *  @param param      <#param description#>
 *  @param preExecute <#preExecute description#>
 *  @param succes     <#succes description#>
 *  @param failed     <#failed description#>
 */
+(void)home_catchImageURL:(NSDictionary*)param preExecute:(MRJPrepareExcute)preExecute success:(MRJSuccessBlock)succes failed:(MRJFailedBlock)failed;
/**
 *  检查设备在线状态
 *
 *  @param param      <#param description#>
 *  @param preExecute <#preExecute description#>
 *  @param succes     <#succes description#>
 *  @param failed     <#failed description#>
 */
+(void)home_checkDeviceOnlineStatus:(NSDictionary*)param preExecute:(MRJPrepareExcute)preExecute success:(MRJSuccessBlock)succes failed:(MRJFailedBlock)failed;

/**
 *  上传配置日志
 *
 *  @param param      <#param description#>
 *  @param preExecute <#preExecute description#>
 *  @param succes     <#succes description#>
 *  @param failed     <#failed description#>
 */
+(void)home_uploadConfigLog:(NSDictionary*)param preExecute:(MRJPrepareExcute)preExecute success:(MRJSuccessBlock)succes failed:(MRJFailedBlock)failed;

/**
 *  获取授权地址
 *
 *  @param param      <#param description#>
 *  @param preExecute <#preExecute description#>
 *  @param succes     <#succes description#>
 *  @param failed     <#failed description#>
 */
+(void)home_deviceAuth:(NSDictionary*)param preExecute:(MRJPrepareExcute)preExecute success:(MRJSuccessBlock)succes failed:(MRJFailedBlock)failed;

@end
