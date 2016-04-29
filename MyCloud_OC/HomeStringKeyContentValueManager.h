//
//  HomeStringKeyContentValueManager.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/8.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "StringKeyContentValueManager.h"

/**
 *  设备管理界面
 */
extern NSString * const language_homeDeviceManagerTitle;//设备管理标题
extern NSString * const language_homeDeviceManagerExitCurrentCloudTitle;//设备管理 退出当前私有云标题
extern NSString * const language_homeDeviceManagerConfigNetButtonName;//配置网络按钮名
extern NSString * const language_homeDeviceManagerDelNetButtonName;//删除网络按钮名
extern NSString * const language_homeDeviceManagerSearchDevicePlacement;//搜索设备占位符
/**
 *  设备详情界面
 */
extern NSString * const language_homeDeviceManagerDeviceDetailTitle;//设备详情标题
extern NSString * const language_homeDeviceManagerDeviceSnNumber;//设备序列号
extern NSString * const language_homeDeviceManagerDeviceAliaName;//设备别名
extern NSString * const language_homeDeviceManagerDeviceWIFIMacAddress;//设备无线mac
extern NSString * const language_homeDeviceManagerDeviceLANMacAddress;//设备有线mac
extern NSString * const language_homeDeviceManagerDeviceHardModel;//设备型号
extern NSString * const language_homeDeviceManagerDeviceHardVersion;//固件版本
extern NSString * const language_homeDeviceManagerDeviceOnlineStatus;//在线状态
extern NSString * const language_homeDeviceManagerDeviceNetConfig;//网络配置
extern NSString * const language_homeDeviceManagerDeviceShopName;//所在店铺
extern NSString * const language_homeDeviceManagerDeviceParam;//设备参数
extern NSString * const language_homeDeviceManagerDeviceResetButtonName;//重启设备按钮名
extern NSString * const language_homeDeviceManagerDeviceDeleteButtonName;//删除设备按钮名
/**
 *  设备参数界面
 */
extern NSString * const language_homeDeviceParamTitle;//设备参数标题
extern NSString * const language_homeDeviceParamWidthNoticeText;//设置摄像头宽度提示语
extern NSString * const language_homeDeviceParamCamaraImageNoticeText;//图像不清晰提示语
extern NSString * const language_homeDeviceParamCaptureCurrentImageButtonName;//抓取实时图片提示语
extern NSString * const language_homeDeviceParamResetDefaultButtonName;//恢复默认按钮名
extern NSString * const language_homeDeviceParamInstallHeightMenuName;//安装高度提示语


/**
 *  搜索设备
 */
extern NSString * const language_homeDeviceConfigSeacrchTitle;//设备配置网络搜索界面标题
extern NSString * const language_homeDeviceConfigSeacrchMicrophoneRefuseAccess;//麦克风不可用提示
extern NSString * const language_homeDeviceConfigSeacrchMicrophoneRefuseAccessNoticeText;//麦克风不可以提示仍然可以配置提示
extern NSString * const language_homeDeviceConfigSeacrchOperationNoticeText;//操作步骤提示


extern NSString * const language_homeDeviceConfigSeacrchOperationStepOneNoticeText;//操作步骤提示1
extern NSString * const language_homeDeviceConfigSeacrchOperationStepTwoNoticeText;//操作步骤提示2
extern NSString * const language_homeDeviceConfigSeacrchOperationStepThreeNoticeText;//操作步骤提示3
extern NSString * const language_homeDeviceConfigSeacrchGeneralNoticeText;//温馨提示
extern NSString * const language_homeDeviceConfigSeacrchGeneralOneNoticeText;//温馨提示1
extern NSString * const language_homeDeviceConfigSeacrchGeneralTwoNoticeText;//温馨提示2
extern NSString * const language_homeDeviceConfigSeacrchButtonName;//搜索设备按钮名字
extern NSString * const language_homeDeviceConfigSeacrchNotFindDeviceNoticeText;//搜索设备未搜到提示语
extern NSString * const language_homeDeviceConfigSeacrchNotFindContinueConfigDeviceNoticeText;//未搜索到设备,继续配置提示语
/**
 *  配置网络
 */
extern NSString * const language_homeDeviceConfigTitle;//网络配置界面title
extern NSString * const language_homeDeviceConfigNoWIFINoticeText;//网络配置没有wifi提示语
extern NSString * const language_homeDeviceConfigCurrentWifi;//网络配置,当前wifi
extern NSString * const language_homeDeviceConfigNetTypeTitle;//网络配置,网络类型
extern NSString * const language_homeDeviceConfigWifiBtnName;//wifi按钮名称
extern NSString * const language_homeDeviceConfigLANBtnName;//有线按钮名称
extern NSString * const language_homeDeviceConfigWifiPassPlacement;//wifi密码placement
extern NSString * const language_homeDeviceConfigIpTitle;//ip标题
extern NSString * const language_homeDeviceConfigDHCPBtnName;//动态网络按钮名
extern NSString * const language_homeDeviceConfigStaticBtnName;//静态网络按钮名

extern NSString * const language_homeDeviceConfigIpAddressPlacement;//ip地址placement
extern NSString * const language_homeDeviceConfigSubMarkPlacement;//子网掩码placement
extern NSString * const language_homeDeviceConfigGateWayPlacement;//网关placement
extern NSString * const language_homeDeviceConfigDNSPlacement;//DNSplacement


@interface HomeStringKeyContentValueManager : StringKeyContentValueManager

@end
