//
//  DeviceModel.m
//  EachPlan
//
//  Created by 申巧 on 15/7/8.
//  Copyright (c) 2015年 XiaoZhou. All rights reserved.
//

#import "DeviceModel.h"
#import "NSString+Safe.h"

@implementation DeviceModel

+ (id)initWithDeviceId:(id)deviceId_ imei:(id)imei_ alias:(id)alias_ onLine:(id)onLine_ initBind:(id)initBind_ initNetwork:(id)initNetwork_ modeId:(id)modeId modeName:(id)modeName_ lens:(id)lens_ netName:(id)netName_ path:(id)path_ shopId:(id)shopId_ shopName:(id)shopName_ wayId:(id)wayId_ wayName:(id)wayName_ height:(id)height_ bindId:(id)bindId_ softVersion:(id)softVersion_ imsi:(id)imsi_ wifi:(id)wifi_{
    DeviceModel *model = [[[self class] alloc] init];
    
    if ((NSNull *)deviceId_ != [NSNull null]) {
        if ([deviceId_ isKindOfClass:[NSString class]]) {
            model.deviceId = deviceId_;
        }else{
            model.deviceId = [deviceId_ stringValue];
        }
    }
    if ((NSNull *)imei_ != [NSNull null]) {
        model.imei = imei_;
    }
    if ((NSNull *)alias_ != [NSNull null]) {
        model.alias = alias_;
    }
    if ((NSNull *)onLine_ != [NSNull null]) {
        model.onLine = [onLine_ boolValue];
    }
    if ((NSNull *)initBind_ != [NSNull null]) {
        model.initBind = [initBind_ boolValue];
    }
    if ((NSNull *)initNetwork_ != [NSNull null]) {
        model.initNetwork = [initNetwork_ boolValue];
    }
    if ((NSNull *)modeId != [NSNull null]) {
        if ([modeId isKindOfClass:[NSString class]]) {
            model.modeId = modeId;
        }else{
            model.modeId = [modeId stringValue];
        }
    }
    if ((NSNull *)modeName_ != [NSNull null]) {
        model.modeName = modeName_;
    }
    if ((NSNull *)lens_ != [NSNull null]) {
        model.lens = lens_;
    }
    if ((NSNull *)netName_ != [NSNull null]) {
        model.netName = netName_;
    }
    if ((NSNull *)path_ != [NSNull null]) {
        model.path = path_;
    }
    if ((NSNull *)shopId_ != [NSNull null]) {
        if ([shopId_ isKindOfClass:[NSString class]]) {
            model.shopId = shopId_;
        }else{
            model.shopId = [shopId_ stringValue];
        }
    }
    if ((NSNull *)wayId_ != [NSNull null]) {
        if ([wayId_ isKindOfClass:[NSString class]]) {
            model.wayId = wayId_;
        }else{
            model.wayId = [wayId_ stringValue];
        }
    }
    if ((NSNull *)shopName_ != [NSNull null]) {
        model.shopName = shopName_;
    }
    if ((NSNull *)wayName_ != [NSNull null]) {
        model.wayName = wayName_;
    }
    if ((NSNull *)height_ != [NSNull null]) {
        if ([height_ isKindOfClass:[NSString class]]) {
            model.height = height_;
        }else{
            model.height = [height_ stringValue];
        }
    }
    if ((NSNull *)modeName_ != [NSNull null]) {
        model.modeName = modeName_;
    }
    if ((NSNull *)bindId_ != [NSNull null]) {
        if ([bindId_ isKindOfClass:[NSString class]]) {
            model.bindId = bindId_;
        }else{
            model.bindId = [bindId_ stringValue];
        }
    }
    if ((NSNull *)softVersion_ != [NSNull null]) {
        model.softVersion = softVersion_;
    }
    if ((NSNull *)imsi_ != [NSNull null]) {
        model.imsi = imsi_;
    }
    if ((NSNull *)wifi_ != [NSNull null]) {
        model.wifi = wifi_;
    }
    if (model.imei) {
        NSString *str = [model.imei safeSubstringToIndex:2];
        switch ([str integerValue]) {
            case 10:
                model.hardModel = DeviceHardModelM1;
                break;
            case 11:
                model.hardModel = DeviceHardModelM2;
                break;
            case 12:
                model.hardModel = DeviceHardModelM1Plus;
                break;
            case 13:
                model.hardModel = DeviceHardModelM2Plus;
                break;
            case 14:
                model.hardModel = DeviceHardModelM3;
                break;
            case 15:
                model.hardModel = DeviceHardModelM4;
                break;
            default:
                model.hardModel = DeviceHardModelNone;
                break;
        }
    }
    return model;
}

- (void)setAccountId:(id)accountId{
    if ((NSNull *)accountId != [NSNull null]) {
        if ([accountId isKindOfClass:[NSString class]]) {
            _accountId = accountId;
        }else{
            _accountId = [accountId stringValue];
        }
    }
}

- (void)setAccountName:(id)accountName{
    if ((NSNull *)accountName != [NSNull null]) {
        if ([accountName isKindOfClass:[NSString class]]) {
            _accountName = accountName;
        }else{
            _accountName = [accountName stringValue];
        }
    }
}

@end
