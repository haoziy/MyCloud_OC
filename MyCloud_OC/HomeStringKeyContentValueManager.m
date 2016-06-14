//
//  HomeStringKeyContentValueManager.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/8.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "HomeStringKeyContentValueManager.h"
@implementation HomeStringKeyContentValueManager
/**
 *  设备管理界面
 */
NSString * const language_homeDeviceManagerNoDeviceNotice = @"暂时没有设备";
NSString * const language_homeDeviceManagerDeviceOnlineStatusString = @"在线";//设备在线状态 在线
NSString * const language_homeDeviceManagerDeviceOfflineStatusString = @"离线";//设备离线状态 离线
NSString * const language_homeDeviceManagerDevicePerMeta = @"台";//设备单位 台
NSString * const language_homeDeviceManagerDeleNetNotice = @"确定删除设备的网络配置?";//删除网络提示
NSString * const language_homeDeviceManagerExitLoginNotice  = @"确定要退出吗?";//退出登录提示

NSString * const language_homeDeviceManagerTitle = @"设备列表";//设备管理标题
NSString * const language_homeDeviceManagerExitCurrentCloudTitle = @"退出";
NSString * const language_homeDeviceManagerConfigNetButtonName = @"配置网络";//配置网络按钮名
NSString * const language_homeDeviceManagerDelNetButtonName = @"删除网络";//删除网络按钮名
NSString * const language_homeDeviceManagerSearchDevicePlacement = @"按名称或序列号搜索设备";//搜索设备占位符
/**
 *  设备详情
 */
NSString * const language_homeDeviceManagerDeviceDetailTitle = @"设备详情";//设备详情标题
NSString * const language_homeDeviceManagerDeviceSnNumber = @"序列号";//设备序列号
NSString * const language_homeDeviceManagerDeviceAliaName = @"名称";//设备别名
NSString * const language_homeDeviceManagerDeviceWIFIMacAddress = @"无线MAC";//设备无线mac
NSString * const language_homeDeviceManagerDeviceLANMacAddress = @"有线MAC";//有线MAC
NSString * const language_homeDeviceManagerDeviceHardModel = @"型号";//设备型号
NSString * const language_homeDeviceManagerDeviceHardVersion = @"固件版本";//固件版本
NSString * const language_homeDeviceManagerDeviceOnlineStatus = @"在线状态";//在线状态
NSString * const language_homeDeviceManagerDeviceNetConfig = @"网络配置";//网络配置
NSString * const language_homeDeviceManagerDeviceShopName = @"所在店铺";//所在店铺
NSString * const language_homeDeviceManagerDeviceParam = @"设备参数";//设备参数
NSString * const language_homeDeviceManagerDeviceResetButtonName = @"重启设备";//重启设备按钮名
NSString * const language_homeDeviceManagerDeviceResetNotice = @"设备重启需要1-2分钟，确定重启设备?";//重启提示
NSString * const language_homeDeviceManagerDeviceDeleteButtonName = @"删除网络配置";//删除设备按钮名
/**
 *  设备参数界面
 */
NSString * const language_homeDeviceParamTitle = @"设备参数";//设备参数标题
NSString * const language_homeDeviceParamWidthNoticeText = @"水平移动左右两个游标,标识店门的左右边界.垂直移动横线,标识门的中心线位置";//设置摄像头宽度提示语
NSString * const language_homeDeviceParamCamaraImageNoticeText = @"不清晰?";//图像不清晰提示语
NSString * const language_homeDeviceParamCaptureCurrentImageButtonName = @"抓取实时图片";//抓取实时图片提示语
NSString * const language_homeDeviceParamResetDefaultButtonName = @"恢复默认";//设置摄像头宽度提示语

NSString * const language_homeDeviceParamInstallHeightMenuName = @"安装高度";//安装高度提示语
NSString * const language_homeDeviceParamCancelCapturePictureNotice = @"确定取消抓图吗?";//取消抓图提示

/**
 *  设备搜索界面
 */
NSString * const language_homeDeviceConfigSeacrchTitle = @"搜索设备";//设备配置网络搜索界面标题
NSString * const language_homeDeviceConfigSeacrchMicrophoneRefuseAccess = @"麦克风拒绝访问";//设备搜索界面麦克风拒绝访问提示
NSString * const language_homeDeviceConfigSeacrchMicrophoneRefuseAccessNoticeText = @"麦克风被拒绝访问,您将收不到设备的声音回应,你仍然可以继续配置";//麦克风拒绝访问后仍可继续配置提示

NSString * const language_homeDeviceConfigSeacrchOperationNoticeText = @"操作步骤";//操作步骤提示
NSString * const language_homeDeviceConfigSeacrchOperationStepOneNoticeText = @"1.连接设备电源";//操作步骤提示1
NSString * const language_homeDeviceConfigSeacrchOperationStepTwoNoticeText = @"2.等待绿灯快闪";//操作步骤提示2
NSString * const language_homeDeviceConfigSeacrchOperationStepThreeNoticeText = @"3.点击搜索开始搜索设备";//操作步骤提示3

NSString * const language_homeDeviceConfigSeacrchGeneralNoticeText = @"温馨提示";//温馨提示
NSString * const language_homeDeviceConfigSeacrchGeneralOneNoticeText = @"1.手机不能处于静音模式";//温馨提示1
NSString * const language_homeDeviceConfigSeacrchGeneralTwoNoticeText = @"2.确保手机离设备保持在0.5米以内";//温馨提示2
NSString * const language_homeDeviceConfigSeacrchButtonName = @"搜索";//搜索设备按钮名字

NSString * const language_homeDeviceConfigSeacrchNotFindDeviceNoticeText = @"未搜索到设备";//搜索设备未收到提示语
NSString * const language_homeDeviceConfigSeacrchNotFindContinueConfigDeviceNoticeText = @"如果在搜索过程中设备发出了声音，也可以点击【下一步】去配置设备网络";;//搜索设备未收到提示语

/**
 *  设备配网界面
 */
NSString * const language_homeDeviceConfigTitle = @"配置网络";//网络配置界面标题
NSString * const language_homeDeviceConfigNoWIFINoticeText = @"请将手机网络切换至设备所连接的Wi-Fi网络";//网络配置没有wifi提示语
NSString * const language_homeDeviceConfigWIFINameTooManyChineseChar = @"设备暂不支持这么多中文的Wi-Fi网络";//含有太多中文字符
NSString * const language_homeDeviceConfigWIFINameContainSpecialCharNotice = @"设备暂不支持特殊字符&的Wi-Fi网络";//wifi含有特殊字符提示


NSString * const language_homeDeviceConfigCurrentWifi = @"当前手机Wi-Fi";//网络配置,当前wifi

NSString * const language_homeDeviceConfigNetTypeTitle = @"网络类型";//网络配置,网络类型
NSString * const language_homeDeviceConfigWifiBtnName = @"WI-FI";//wifi按钮名称

NSString * const language_homeDeviceConfigLANBtnName = @"有线网络";//有线按钮名称
NSString * const language_homeDeviceConfigWifiPassPlacement = @"Wi-Fi密码";//wifi密码placement
NSString * const language_homeDeviceConfigIpTitle = @"IP设置";//ip标题
NSString * const language_homeDeviceConfigDHCPBtnName = @"动态";//动态网络按钮名
NSString * const language_homeDeviceConfigStaticBtnName = @"静态";//静态网络按钮名
NSString * const language_homeDeviceConfigIpAddressPlacement = @"IP地址";//ip地址placement
NSString * const language_homeDeviceConfigIpAddressCheckNotice = @"请输入合法的IP地址";//请输入合法ip
NSString * const language_homeDeviceConfigSubMarkPlacement = @"子网掩码";//子网掩码placement
NSString * const language_homeDeviceConfigSubMarkCheckNotice = @"请输入合法的子网掩码";//请输入合法子网掩码
NSString * const language_homeDeviceConfigGateWayPlacement = @"网关";//网关placement
NSString * const language_homeDeviceConfigNetGatewayCheckNotice = @"请输入合法的网关地址";//请输入合法网关
NSString * const language_homeDeviceConfigDNSPlacement = @"DNS";//DNSplacement
NSString * const language_homeDeviceConfigDNSAddressCheckNotice = @"请输入合法的DNS地址";//请输入合法NDS地址

NSString * const language_homeDeviceConfigWIFIEmptyPasswordNotice = @"【Wi-Fi】密码确定为空吗?";//配置过程空密码提示
NSString * const language_homeDeviceConfigConfigProcessSendParamsNoticeString = @"正在发送网络参数";//配置过程正在发送网络参数提
NSString * const language_homeDeviceConfigConfigProcessConfigingNet = @"网络参数发送完毕，正在配置设备网络";//网络参数发送完毕正在配置
NSString * const language_homeDeviceConfigOverNotice = @"配置完毕，稍后请查看设备的绿灯状态。如果绿灯常亮，说明配置网络成功。否则，请重新配置。";
NSString * const language_homeDeviceConfigSuccesNotice = @"配置设备网络成功" ;//配置成功

+(NSString*)languageValueForKey:(NSString *)key
{
    return [self homeLanguageValueForKey:key];
}
@end
