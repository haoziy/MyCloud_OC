//
//  UIView+Additions.h
//  EachPlan
//
//  Created by 申巧 on 15/1/16.
//  Copyright (c) 2015年 XiaoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)
+(UIView*)initeCellHeadNoTitle;//无文字的tablehead;

+(UIView *)initCellTitleViewWithTitle:(NSString *)title;

/**
 *  表格每个cell的分隔线
 *
 *  @param frame frame
 *
 *  @return view对象
 */
+(UIView *)initCellLineViewWithFrame:(CGRect)frame;

/**
 *  好友列表页面,sectionHeadView
 *
 *  @param title  显示的标题
 *  @param frame  frame
 *  @param margin 左边距
 *
 *  @return view实体
 */
+(UIView *)initCellHeadViewWithTitle:(NSString *)title frame:(CGRect)frame textColor:(UIColor *)color leftMargin:(CGFloat)margin;

@end
