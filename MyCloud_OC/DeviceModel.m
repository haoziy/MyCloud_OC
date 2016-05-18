//
//  DeviceModel.m
//  EachPlan
//
//  Created by 申巧 on 15/7/8.
//  Copyright (c) 2015年 XiaoZhou. All rights reserved.
//

#import "DeviceModel.h"
#import "NSString+Safe.h"

@implementation DeviceOperationRule

@end

@implementation DeviceModel
-(DeviceHardModel)hardModel
{
    NSString *str = [self.imei safeSubstringToIndex:2];
    switch ([str integerValue]) {
        case 10:
            return  DeviceHardModelM1;
        case 11:
            return  DeviceHardModelM2;
        case 12:
            return  DeviceHardModelM1Plus;
        case 13:
            return  DeviceHardModelM2Plus;
        case 14:
            return  DeviceHardModelM3;
        case 15:
            return  DeviceHardModelM4;
        default:
            return  DeviceHardModelNone;
    }
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"onLine" : @"online",
             @"modeName":@"mode",
             @"imagePath":@"img",
             @"wifi":@"wlanMac",
             };
}
-(DeviceInstallPara)installPara
{
    struct DeviceDetailPara param = {(CGFloat)self.topPoint,(CGFloat)self.leftPoint,(CGFloat)self.bottomPoint,(CGFloat)self.rightPoint,(int)self.direction,(NSInteger)self.boxTop,(NSInteger)self.boxLeft,(NSInteger)self.boxBottom,(NSInteger)self.boxRight};
    return param;
}
-(NSString*)modeName
{
    switch (self.hardModel) {
        case DeviceHardModelM1:
            return @"M1";
        case DeviceHardModelM2:
            return @"M2";
        case DeviceHardModelM1Plus:
            return @"M1S";
        case DeviceHardModelM2Plus:
            return @"M2S";
        case DeviceHardModelM3:
            return @"M3";
        case DeviceHardModelM4:
            return @"M4";
        default:
            return @"Mx";
    }
}
-(NSString*)installHeight
{
    NSString *len = @"";
    if ([self.lens isEqualToString:@"1"]) {
        len = @"18";
        if ([self.height isEqualToString:@"1"]) {
            return  @"2.6米以下";
        }else if ([self.height isEqualToString:@"2"]){
            return  @"2.6~2.8米";
        }else if ([self.height isEqualToString:@"3"]){
            return  @"2.8米以上";
        }
    }else if ([self.lens isEqualToString:@"2"]){
        len = @"28";
        if ([self.height isEqualToString:@"1"]) {
            return  @"3.2米以下";
        }else if ([self.height isEqualToString:@"2"]){
            return  @"3.2~3.4米";
        }else if ([self.height isEqualToString:@"3"]){
            return  @"3.4米以上";
        }
    }else if ([self.lens isEqualToString:@"3"]){
        len = @"36";
        if ([self.height isEqualToString:@"1"]) {
            return  @"3.5米以下";
        }else if ([self.height isEqualToString:@"2"]){
            return  @"3.5~3.8米";
        }else if ([self.height isEqualToString:@"3"]){
            return  @"3.8米以上";
        }
    }
    return @"";
}
-(NSString*)height
{
    if ([_height integerValue]<1) {
        _height = @"1";
    }
    if ([_height integerValue]>3) {
        _height = @"3";
    }
    return _height;
}
-(NSString*)lens
{
    
    if ([_lens integerValue]==1||[_lens integerValue]==2||[_lens integerValue]==3) {
        return _lens;
    }else
    {
        if(self.imei.length>3)
        {
            return [self.imei substringWithRange:NSMakeRange(2, 1)];
        }
        else
        {
            return @"";
        }
    }
}
-(NSString*)displayMode
{
    NSString *len = @"";
    if ([self.lens isEqualToString:@"1"]) {
        len = @"18";
    }else if ([self.lens isEqualToString:@"2"])
    {
        len = @"28";
    }else if ([self.lens isEqualToString:@"3"])
    {
        len = @"36";
    }
    return [NSString stringWithFormat:@"%@-%@",self.modeName,len];
}
-(NSString*)netName
{
    if ([_netType isEqualToString:@"0"]) {
        return @"有线";
    }else if([_netType isEqualToString:@"1"])
    {
        return @"有线";
    }else
    {
        return self.ssid;
    }
}
@end
