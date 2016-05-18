//
//  MRJColorManager.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/8.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+mrjColor.h"

#define NavigationTextColor [MRJColorManager mrj_navigationTextColor]
#define SecondaryTextColor  [MRJColorManager mrj_secondaryTextColor]
#define MainTextColor  [MRJColorManager mrj_mainTextColor]
#define MainThemeColor [MRJColorManager mrj_mainThemeColor]
#define SeparatrixColor [MRJColorManager mrj_separatrixColor]
#define PlainButtonColor [MRJColorManager mrj_plainColor]
//#define NavigationTextColor [MRJColorManager mrj_navigationTextColor]
//#define NavigationTextColor [MRJColorManager mrj_navigationTextColor]
//#define NavigationTextColor [MRJColorManager mrj_navigationTextColor]


/**
 16进制颜色字符串
 导航栏上文字颜色一种,白色;
 导航栏/tabbar/主题颜色都是黄色;
 文本内容,如果只有单一级别文本,则用主文本色,如果出现两种级别,第二种颜色为次文本颜色,如果还有第三种颜色,则用notice色
 背景色
 分割线颜色
 .....
 **/
//导航栏字体颜色;
extern NSString *const color_hex_navigationTextColorString;

//文字内容一级文本颜色
extern NSString *const color_hex_mainTextColorString;

//文本内容二级文本颜色
extern NSString *const color_hex_secondaryTextColorString;
//文本三级文本颜色
extern NSString *const color_hex_noticeTextColorString;

//主色调;//黄色,tabbar颜色,导航栏背景色
extern NSString *const color_hex_mainThemeColorString;

//主背景色;
extern NSString *const color_hex_mainBackgroundColorString;

//警告色;负面操作色,红色
extern NSString *const color_hex_alertColorString;

//扁平化控件颜色
extern NSString *const color_hex_plainColorString;

//分割线颜色
extern NSString *const color_hex_separatrixColorString;

//button选中色
extern NSString *const color_hex_buttonHighlightColorString;
//e69900

@interface MRJColorManager : NSObject


+(UIColor*)mrj_navigationTextColor;
+(UIColor*)mrj_mainTextColor;
+(UIColor*)mrj_secondaryTextColor;
+(UIColor*)mrj_noticeTextColor;
+(UIColor*)mrj_mainThemeColor;
+(UIColor*)mrj_mainBackgroundColor;
+(UIColor*)mrj_alertColor;
+(UIColor*)mrj_plainColor;
+(UIColor*)mrj_separatrixColor;
+(UIColor*)mrj_buttonHighlightColor;
@end
