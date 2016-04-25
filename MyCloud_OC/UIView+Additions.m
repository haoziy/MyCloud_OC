//
//  UIView+Additions.m
//  EachPlan
//
//  Created by 申巧 on 15/1/16.
//  Copyright (c) 2015年 XiaoZhou. All rights reserved.
//

#import "UIView+Additions.h"
#import "UIView+Frame.h"

@implementation UIView (Additions)
+(UIView*)initeCellHeadNoTitle;//无文字的tablehead;
{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOP_PADDING)];
//    view.backgroundColor = MainBackgroundColor;
//    return view;
    return nil;
}
+(UIView *)initCellTitleViewWithTitle:(NSString *)title
{
//    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TableHeadHeight)];
    
//    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_PADDING, 20, 150, TableHeadHeight-20)];
//    label.font = SmallTextFont;
//    label.textColor = SecondaryTextColor;
//    label.text = title;
//    [label sizeThatFits:label.size];
//    [label sizeToFit];
//    label.x = LEFT_PADDING;
//    label.centerY = view.height/2;
//    view.backgroundColor = MainBackgroundColor;
//    [view addSubview:label];
    
    return nil;
}

+(UIView *)initCellLineViewWithFrame:(CGRect)frame{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    return view;
}

+(UIView *)initCellHeadViewWithTitle:(NSString *)title frame:(CGRect)frame textColor:(UIColor *)color leftMargin:(CGFloat)margin{
    UIView *view = [[UIView alloc] initWithFrame:frame];
//    view.backgroundColor = MainBackgroundColor;
    
//    if (title) {
//        UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){margin,0,view.width-margin,view.height}];
//        label.text = title;
//        label.font = SmallTextFont;
//        label.textColor = color;
//        [view addSubview:label];
//    }
    
    return view;
}

@end
