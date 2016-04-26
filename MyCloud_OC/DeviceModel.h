//
//  DeviceModel.h
//  EachPlan
//
//  Created by 申巧 on 15/7/8.
//  Copyright (c) 2015年 XiaoZhou. All rights reserved.
//

#import <Foundation/Foundation.h>
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

//设备ID
@property (nonatomic,copy) NSString *deviceId;
//设备序列号
@property (nonatomic,copy) NSString *imei;
//设备别名
@property (nonatomic,copy) NSString *alias;
//是否在线
@property (nonatomic,assign) BOOL onLine;
//是否绑定
@property (nonatomic,assign) BOOL initBind;
//是否配置网络
@property (nonatomic,assign) BOOL initNetwork;
//型号ID
@property (nonatomic,copy) NSString *modeId;
//型号名称
@property (nonatomic,copy) NSString *modeName;
//镜头
@property (nonatomic,copy) NSString *lens;
//配置网络名
@property (nonatomic,copy) NSString *netName;
//图片路径
@property (nonatomic,copy) NSString *path;
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
//软件版本
@property (nonatomic,copy) NSString *softVersion;
//软件版本 数字型
@property (nonatomic,assign)NSInteger softVersionInt;
//m1网络类型
@property(nonatomic,copy)NSString *netType;
//设备MAC地址
@property (nonatomic,copy) NSString *imsi;
//设备无线MAC地址
@property (nonatomic,copy) NSString *wifi;
//设备硬件型号
@property (nonatomic,assign)DeviceHardModel hardModel;
//该设备是否被关联(0未被关联1被当前账户关联2被其他账户关联)
@property (nonatomic,assign) int falg;
//关联账号ID
@property (nonatomic,copy) NSString *accountId;
//关联账号名称
@property (nonatomic,copy) NSString *accountName;

//设备详情页面显示的型号名
@property (nonatomic,copy) NSString *displayMode;

@property (nonatomic,assign) DeviceInstallPara installPara;

+ (id)initWithDeviceId:(id)deviceId_ imei:(id)imei_ alias:(id)alias_ onLine:(id)onLine_ initBind:(id)initBind_ initNetwork:(id)initNetwork_ modeId:(id)modeId modeName:(id)modeName_ lens:(id)lens_ netName:(id)netName_ path:(id)path_ shopId:(id)shopId_ shopName:(id)shopName_ wayId:(id)wayId_ wayName:(id)wayName_ height:(id)height_ bindId:(id)bindId_ softVersion:(id)softVersion_ imsi:(id)imsi_ wifi:(id)wifi_;

@end
