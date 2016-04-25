//
//  MRJColorManager.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/8.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "MRJColorManager.h"
NSString *const color_hex_navigationTextColorString = @"#FFFFFF";
NSString *const color_hex_mainTextColorString = @"#000000";
NSString *const color_hex_secondaryTextColorString = @"#999999";
NSString *const color_hex_noticeTextColorString = @"#FFFFFF";
NSString *const color_hex_mainThemeColorString= @"#f4a100";
NSString *const color_hex_mainBackgroundColorString = @"#f1f1f1";
NSString *const color_hex_alertColorString = @"#ff3300";
NSString *const color_hex_plainColorString = @"#03a9f4";
NSString *const color_hex_separatrixColorString = @"#dddddd";
@implementation MRJColorManager


+(UIColor*)mrj_navigationTextColor;
{
    return [UIColor colorWithHexString:color_hex_navigationTextColorString];
}
+(UIColor*)mrj_mainTextColor;
{
    return [UIColor colorWithHexString:color_hex_mainTextColorString];
}
+(UIColor*)mrj_secondaryTextColor;
{
    return [UIColor colorWithHexString:color_hex_secondaryTextColorString];
}
+(UIColor*)mrj_noticeTextColor;
{
    return [UIColor colorWithHexString:color_hex_noticeTextColorString];
}
+(UIColor*)mrj_mainThemeColor;
{
    return [UIColor colorWithHexString:color_hex_mainThemeColorString];
}
+(UIColor*)mrj_mainBackgroundColor;
{
    return [UIColor colorWithHexString:color_hex_mainBackgroundColorString];
}
+(UIColor*)mrj_alertColor;
{
    return [UIColor colorWithHexString:color_hex_alertColorString];
}
+(UIColor*)mrj_plainColor;
{
    return [UIColor colorWithHexString:color_hex_plainColorString];
}
+(UIColor*)mrj_separatrixColor;
{
    return [UIColor colorWithHexString:color_hex_separatrixColorString];
}
@end
