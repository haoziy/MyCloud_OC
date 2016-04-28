//
//  UIButton+MRJButton.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/28.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (MRJButton)

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


+(instancetype)mrj_generalBtnTitle:(NSString*)title
                  normalTitleColor:(UIColor*)normalTitleColor
                    highlightTitleColor:(UIColor*)highlightTitleColor
                   normalBackImage:(UIImage*)normalBackImage
                highlightBackImage:(UIImage*)highlightBackImage;
@end
