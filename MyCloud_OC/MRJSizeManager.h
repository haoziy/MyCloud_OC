//
//  MRJSizeManager.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/8.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern CGFloat const font_navigationFontSize;//导航字体,最大的字体
extern CGFloat const font_mainTextFontSize;//大号字体
extern CGFloat const font_middleTextFontSize;//中号字体
extern CGFloat const font_smallTextFontSize;//小号文本字体



@interface MRJSizeManager : NSObject
+(UIFont*)mrjFontOfSize:(CGFloat)size;
+(UIFont*)mrjNavigationFont;
+(UIFont*)mrjMainTextFont;
+(UIFont*)mrjMiddleTextFont;
+(UIFont*)mrjsmallTextFont;
@end
