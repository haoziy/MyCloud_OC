//
//  MNGSearchDeviceForConfigNetViewController.h
//  EachPlan
//
//  Created by ZEROLEE on 15/9/15.
//  Copyright (c) 2015年 XiaoZhou. All rights reserved.
//

#import "BaseHiddenTabbarViewController.h"
#import "DeviceModel.h"

#include "VoiceDecoder.h"
#include "voiceEncoder.h"
typedef enum
{
    DeviceConfigEnteryFromDeviceList = 0,//从设备列表进入,
    DeviceConfigEnteryFromDeviceDetail//从设备详情进入
}DeviceConfigEnteryWay;

@interface MNGSearchDeviceForConfigNetViewController : BaseHiddenTabbarViewController
{
    VoiceRecog *receiveRecog;
    VoicePlayer *sendPlayer;
}

@property(nonatomic,strong)DeviceModel *deviceModel;
@property(nonatomic,readonly,assign)DeviceConfigEnteryWay enterWay;
-(id)initWithEnterWay:(DeviceConfigEnteryWay)enterWay;
@end
