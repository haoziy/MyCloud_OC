//
//  DeviceModel.h
//  EachPlan
//
//  Created by 申巧 on 15/7/8.
//  Copyright (c) 2015年 XiaoZhou. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DeviceOperationRule;
typedef enum {
    DeviceHardModelNone = 0,//未知
    DeviceHardModelM1 = 10,//10 M1
    DeviceHardModelM2,//11 M2
    DeviceHardModelM1Plus,//12 M1S
    DeviceHardModelM2Plus,//13 M2S
    DeviceHardModelM3,//14 M3
    DeviceHardModelM4//15 M4
}DeviceHardModel;//硬件型号

struct DeviceDetailPara {
    //扩容前
    float topPoint;
    float leftPoint;
    float bottomPoint;
    float rightPoint;
    //安装方向
    NSInteger direction;
   
    //扩容后
    NSInteger boxtop;
    NSInteger boxleft;
    NSInteger boxbottom;
    NSInteger boxright;
    
    
};
typedef struct DeviceDetailPara DeviceInstallPara;


@interface DeviceModel : NSObject

/*
 基础信息部分;设备列表返回部分
 */

//设备ID
@property (nonatomic,copy) NSString *deviceId;
//设备序列号
@property (nonatomic,copy) NSString *imei;
//设备别名
@property (nonatomic,copy) NSString *alias;
//是否在线
@property (nonatomic,assign) BOOL onLine;
//软件版本
@property (nonatomic,copy) NSString *softVersion;
//软件版本 数字型
@property (nonatomic,assign)NSInteger softVersionInt;
//权限规则
@property(nonatomic,strong)DeviceOperationRule *rule;
///设备硬件型号
@property (nonatomic,assign,readonly)DeviceHardModel hardModel;



/**
 进阶部分
 */

//是否配置网络
@property (nonatomic,assign) BOOL initNetwork;
//网络类型
@property(nonatomic,copy)NSString *netType;
//网关
@property(nonatomic,copy) NSString *gateway;
//ip
@property(nonatomic,copy) NSString *ipAddress;
//mask
@property(nonatomic,copy) NSString *mask;
//masterDNS
@property(nonatomic,copy) NSString *masterDNS;
//slaveDns
@property(nonatomic,copy) NSString *slaveDns;
//ssid wifi ssid
@property(nonatomic,copy) NSString *ssid;
//设备热点名称
@property(nonatomic,copy)NSString *wlanSsid;

//password 目前的wifi密码
@property (nonatomic,copy) NSString *password;
//encrypt 加密方式
@property(nonatomic,copy) NSString *encrypt;
//配置网络名
@property (nonatomic,copy) NSString *netName;


//设备MAC地址
@property (nonatomic,copy) NSString *imsi;
//设备无线MAC地址
@property (nonatomic,copy) NSString *wifi;
//图片路径
@property (nonatomic,copy) NSString *imagePath;


//最后XX时间
@property(nonatomic,strong) NSDate *lastDataTime;
@property(nonatomic,strong) NSDate *lastHeart;
@property(nonatomic,strong) NSDate *lastLogin;
@property(nonatomic,strong) NSDate *lastReport;
@property(nonatomic,strong) NSDate *serviceDate;
//型号名称
@property (nonatomic,copy) NSString *modeName;
//product
@property (nonatomic,copy) NSString *product;
//security
@property (nonatomic,copy) NSString *security;
//型号ID
@property (nonatomic,copy) NSString *modeId;
//镜头
@property (nonatomic,copy) NSString *lens;



//安装参数
//高度 下标
@property (nonatomic,copy) NSString *height;
//安装高度
@property (nonatomic,copy) NSString *installHeight;

//安装参数
//扩展之后的;是绝对数值
@property(nonatomic,assign)NSInteger boxBottom;//
@property(nonatomic,assign)NSInteger boxLeft;//
@property(nonatomic,assign)NSInteger boxRight;
@property(nonatomic,assign)NSInteger boxTop;

//扩展之前的;是相对坐标;
@property(nonatomic,assign)CGFloat bottomPoint;//
@property(nonatomic,assign)CGFloat leftPoint;//
@property(nonatomic,assign)CGFloat rightPoint;
@property(nonatomic,assign)CGFloat topPoint;

@property(nonatomic,assign)NSInteger direction;



//设备详情页面显示的型号名
@property (nonatomic,copy) NSString *displayMode;

@property (nonatomic,assign) DeviceInstallPara installPara;


@end

@interface DeviceOperationRule : NSObject
@property (nonatomic,assign) BOOL allowDel;
@property (nonatomic,assign) BOOL allowDelAccount;
@property (nonatomic,assign) BOOL allowDelNet;
@property (nonatomic,assign) BOOL allowGrap;
@property (nonatomic,assign) BOOL allowParamAlgorithm;
@property (nonatomic,assign) BOOL allowParamBase;
@property (nonatomic,assign) BOOL allowParamCamera;
@property (nonatomic,assign) BOOL allowQuit;
@property (nonatomic,assign) BOOL allowRestart;
@property (nonatomic,assign) BOOL allowServerSetting;
@property (nonatomic,assign) BOOL allowSetting;
@property (nonatomic,assign) BOOL allowSettingAccount;
@property (nonatomic,assign) BOOL allowTransfer;
@property (nonatomic,assign) BOOL allowUpgrade;
@end
