//
//  AppSinglon.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/6.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const baseURL_normal_environment;//正式环境
extern NSString *const baseURL_inner_environment;//内部测试环境
extern NSString *const baseURL_develop_environment;//开发环境
extern NSString *const baseFormURL_normal_environment;



@interface AppSingleton : NSObject
+(instancetype)shareInstace;

+(NSString*)currentEnvironmentBaseURL;

@property(nonatomic,copy)NSString *environmentUrl;//当前环境的url;
@property(nonatomic,copy)NSString *inputEnvironmentURL;//切换私有云时,用户的输入信息;
@property(nonatomic,copy)NSString *myFormsIP;//如果是私有云的情况下报表中心ip
@property(nonatomic,copy)NSString *myFormsPort;//如果是私有云报表中心端口
@property(nonatomic,copy)NSString *myCloudIP;//如果是私有云的话则保存私有云ip
@property(nonatomic,copy)NSString *myCloudPort;//如果是私有云的话则保存私有云端口

@property(nonatomic,copy)NSString *lastLoginMobileOrEmail;//上次登录的账号
@property(nonatomic,copy)NSString *formsEnvironmentUrl;//报表中心的url;
@property(nonatomic,copy)NSString *wifiStatiConfigIP;//配置网络时候的静态ip
@property(nonatomic,copy)NSString *lanStatiConfigIP;//配置网络时候的静态ip

@property(nonatomic,copy)NSString *wifiStatiConfiMask;//配置网络时候的掩码
@property(nonatomic,copy)NSString *lanStatiConfiMask;//配置网络时候的掩码

@property(nonatomic,copy)NSString *wifiStatiConfigGateWay;//配置网络时候的网关
@property(nonatomic,copy)NSString *lanStatiConfigGateWay;//配置网络时候的网关

@property(nonatomic,copy)NSString *wifiStatiConfigDNS;//配置网络时候的静态DNS
@property(nonatomic,copy)NSString *lanStatiConfigDNS;//配置网络时候的静态DNS
@end
