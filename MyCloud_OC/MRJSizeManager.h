//
//  MRJSizeManager.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/8.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define TOP_PADDING [MRJSizeManager mrjVerticalSpace]
#define LEFT_PADDING [MRJSizeManager mrjHorizonPaddding]
#define MiddleTextFont [MRJSizeManager mrjMiddleTextFont]
#define INPUT_HEIGHT [MRJSizeManager mrjInputSizeHeight]
#define TableHeadHeight [MRJSizeManager mrjTableHeadHeight]
#define VERTICAL_SAPCE  [MRJSizeManager mrjVerticalSpace]
#define CELL_SPERITX_HEIGHT [MRJSizeManager mrjSepritorHeight]
#define RIGHT_PADDING [MRJSizeManager mrjHorizonPaddding]
extern CGFloat const font_navigationFontSize;//导航字体,最大的字体
extern CGFloat const font_mainTextFontSize;//大号字体
extern CGFloat const font_middleTextFontSize;//中号字体
extern CGFloat const font_smallTextFontSize;//小号文本字体



@interface MRJSizeManager : NSObject
//根据字符串以及字体大小,返回size
+(CGSize)getSizeWithText:(NSString *)text font:(UIFont *)font;

//根据字符串以及字体大小,最大size,返回实际size
+(CGSize)getSizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;



+(UIFont*)mrjFontOfSize:(CGFloat)size;
+(UIFont*)mrjNavigationFont;
+(UIFont*)mrjMainTextFont;
+(UIFont*)mrjMiddleTextFont;
+(UIFont*)mrjsmallTextFont;
+(CGFloat)mrjVerticalPadding;
+(CGFloat)mrjHorizonPaddding;
+(CGFloat)mrjInputSizeHeight;
+(CGFloat)mrjButtonCornerRadius;
+(CGFloat)mrjSepritorHeight;//分割线高度
+(CGFloat)mrjTableHeadHeight;

+(CGFloat)mrjVerticalSpace;
+(CGFloat)mrjHorizonSpace;;

@end
