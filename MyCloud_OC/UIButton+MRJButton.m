//
//  UIButton+MRJButton.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/28.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "UIButton+MRJButton.h"

@implementation UIButton (MRJButton)

+(instancetype)mrj_generalBtnTitle:(NSString*)title
                  normalTitleColor:(UIColor*)normalTitleColor
               highlightTitleColor:(UIColor*)highlightTitleColor
                   normalBackImage:(UIImage*)normalBackImage
                highlightBackImage:(UIImage*)highlightBackImage;
{
    return [self initWithNormalTitle:title hightlightTitle:nil selectedTitle:nil disableTitle:nil noramalTitleColor:normalTitleColor hightlightTitleColor:highlightTitleColor selectedTitleColor:nil disableTitleColor:nil normalImage:nil hightlightImage:nil selectedImage:nil disableImage:nil normalBackImage:normalBackImage highlightBackImage:highlightBackImage selectedBackImage:nil disableBackImage:nil corRedius:[MRJSizeManager mrjButtonCornerRadius]];
}


+(instancetype)initWithNormalTitle:(NSString*)normalTitle
                   hightlightTitle:(NSString*)hightlightTitle
                     selectedTitle:(NSString*)selectedTitle
                      disableTitle:(NSString*)disableTitle
                 noramalTitleColor:(UIColor*)noramalTitleColor
              hightlightTitleColor:(UIColor*)hightlightTitleColor
                selectedTitleColor:(UIColor*)selectedTitleColor
                 disableTitleColor:(UIColor*)disableTitleColor
                       normalImage:(UIImage*)normalImage
                   hightlightImage:(UIImage*)hightlightImage
                     selectedImage:(UIImage*)selelctedImage
                      disableImage:(UIImage*)disableImage
                   normalBackImage:(UIImage*)normalBackImage
                highlightBackImage:(UIImage*)highlightBackImage
                 selectedBackImage:(UIImage*)selectedBackImage
                  disableBackImage:(UIImage*)disableBackImage
                         corRedius:(CGFloat)corRedius;
{
    
    UIButton *btn = [[UIButton alloc]init];
    btn.layer.cornerRadius = corRedius;
    btn.clipsToBounds = YES;
    if (noramalTitleColor) {
        [btn setTitleColor:noramalTitleColor forState:UIControlStateNormal];
    }
    if (hightlightTitleColor) {
        [btn setTitleColor:hightlightTitleColor forState:UIControlStateHighlighted];
    }
    if (selectedTitleColor) {
        [btn setTitleColor:selectedTitleColor forState:UIControlStateSelected];
    }
    if (disableTitleColor) {
        [btn setTitleColor:disableTitleColor forState:UIControlStateDisabled];
    }
    
    if (normalTitle) {
        [btn setTitle:normalTitle forState:UIControlStateNormal];
    }
    if (hightlightTitle) {
        [btn setTitle:normalTitle forState:UIControlStateHighlighted];
    }
    if (selectedTitle) {
        [btn setTitle:normalTitle forState:UIControlStateSelected];
    }
    if (disableTitle) {
        [btn setTitle:disableTitle forState:UIControlStateDisabled];
    }
    
    if (normalImage) {
        [btn setImage:normalImage forState:UIControlStateNormal];
    }
    if (hightlightImage) {
        [btn setImage:hightlightImage forState:UIControlStateHighlighted];
    }
    if (selelctedImage) {
        [btn setImage:selelctedImage forState:UIControlStateSelected];
    }
    if (disableImage) {
        [btn setImage:disableImage forState:UIControlStateDisabled];
    }
    
    if (normalBackImage) {
        [btn setBackgroundImage:normalBackImage forState:UIControlStateNormal];
    }
    if (highlightBackImage) {
        [btn setBackgroundImage:highlightBackImage forState:UIControlStateHighlighted];
    }
    if (selectedBackImage) {
        [btn setBackgroundImage:selectedBackImage forState:UIControlStateSelected];
    }
    if (disableBackImage) {
        [btn setBackgroundImage:disableBackImage forState:UIControlStateDisabled];
    }
    return btn;
}
@end
