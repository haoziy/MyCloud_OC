//
//  MRJSizeManager.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/8.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "MRJSizeManager.h"


CGFloat const font_navigationFontSize = 20.0f;//导航字体,最大的字体
CGFloat const font_mainTextFontSize = 17.0f;//大号字体
CGFloat const font_middleTextFontSize = 15.0f;//中号字体
CGFloat const font_smallTextFontSize = 11.0f;;//小号文本字体

@implementation MRJSizeManager
+(UIFont*)mrjFontOfSize:(CGFloat)size;
{
    return [UIFont systemFontOfSize:size];
}

+(UIFont*)mrjNavigationFont;
{
    return [UIFont systemFontOfSize:font_navigationFontSize];
}
+(UIFont*)mrjMainTextFont;
{
    return [UIFont systemFontOfSize:font_mainTextFontSize];
}
+(UIFont*)mrjMiddleTextFont;
{
    return [UIFont systemFontOfSize:font_middleTextFontSize];
}
+(UIFont*)mrjsmallTextFont;
{
    return [UIFont systemFontOfSize:font_smallTextFontSize];
}
@end
