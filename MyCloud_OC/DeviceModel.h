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
    int boxbottom;
    int boxleft;
    int boxright;
    int boxtop;
    int direction;
    int height;
    int leftPoint;
    int rightPoint;
    int topPoint;
    int bottomPoint;
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
//ssid
@property(nonatomic,copy) NSString *ssid;
//encrypt
@property(nonatomic,copy) NSString *encrypt;

//设备MAC地址
@property (nonatomic,copy) NSString *imsi;
//设备无线MAC地址
@property (nonatomic,copy) NSString *wifi;
//图片路径
@property (nonatomic,copy) NSString *imagePath;
//是否配置网络
@property (nonatomic,assign) BOOL initNetwork;

//最后XX时间
@property(nonatomic,strong) NSDate *lastDataTime;
@property(nonatomic,strong) NSDate *lastHeart;
@property(nonatomic,strong) NSDate *lastLogin;
@property(nonatomic,strong) NSDate *lastReport;
@property(nonatomic,strong) NSDate *serviceDate;
//型号名称
@property (nonatomic,copy) NSString *modeName;

//password
@property (nonatomic,copy) NSString *password;

//product
@property (nonatomic,copy) NSString *product;


//security
@property (nonatomic,copy) NSString *security;
//是否绑定
@property (nonatomic,assign) BOOL initBind;

//型号ID
@property (nonatomic,copy) NSString *modeId;

//镜头
@property (nonatomic,copy) NSString *lens;
//配置网络名
@property (nonatomic,copy) NSString *netName;

//绑定店铺ID
@property (nonatomic,copy) NSString *shopId;
//绑定店铺名称
@property (nonatomic,copy) NSString *shopName;
//绑定出入口ID
@property (nonatomic,copy) NSString *wayId;
//绑定出入口名
@property (nonatomic,copy) NSString *wayName;
//高度
@property (nonatomic,copy) NSString *height;
//安装高度
@property (nonatomic,copy) NSString *installHeight;
//绑定ID
@property (nonatomic,copy) NSString *bindId;

//m1网络类型
@property(nonatomic,copy)NSString *netType;


//该设备是否被关联(0未被关联1被当前账户关联2被其他账户关联)
@property (nonatomic,assign) int falg;
//关联账号ID
@property (nonatomic,copy) NSString *accountId;
//关联账号名称
@property (nonatomic,copy) NSString *accountName;

//设备详情页面显示的型号名
@property (nonatomic,copy) NSString *displayMode;

@property (nonatomic,assign) DeviceInstallPara installPara;

//+ (id)initWithDeviceId:(id)deviceId_ imei:(id)imei_ alias:(id)alias_ onLine:(id)onLine_ initBind:(id)initBind_ initNetwork:(id)initNetwork_ modeId:(id)modeId modeName:(id)modeName_ lens:(id)lens_ netName:(id)netName_ path:(id)path_ shopId:(id)shopId_ shopName:(id)shopName_ wayId:(id)wayId_ wayName:(id)wayName_ height:(id)height_ bindId:(id)bindId_ softVersion:(id)softVersion_ imsi:(id)imsi_ wifi:(id)wifi_;

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
