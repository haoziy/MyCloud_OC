//
//  LoginRegistStringValueContentManager.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/8.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "StringKeyContentValueManager.h"

extern NSString * const language_login_title;//登录标题
extern NSString * const language_login_serviceBtnName;//设置私有云服务器地址按钮名
extern NSString * const language_login_serviceAddress;//私有云服务器地址
extern NSString * const language_login_serviceAddressPlacement;//确定按钮名

extern NSString * const language_login_connectServiceSuccessNotice;//连接服务器成功提示
extern NSString * const language_login_connectServiceFailNotice;//连接服务器地址失败提示

extern NSString * const language_login_accountPlacement;//登录账号占位字符串
extern NSString * const language_login_passwordPlacement;//登录界面密码占位符
extern NSString * const language_login_noSettingServiceNotice;//未设置服务器地址就登录提示



@interface LoginRegistStringValueContentManager : StringKeyContentValueManager

@end
