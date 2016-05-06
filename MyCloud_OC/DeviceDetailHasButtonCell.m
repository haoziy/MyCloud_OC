//
//  DeviceDetailHasButtonCell.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/5/6.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "DeviceDetailHasButtonCell.h"
#import "UIButton+MRJButton.m"
@interface DeviceDetailHasButtonCell()
{
    UIButton *buttonOne;
    UIButton *buttonTwo;
}

@end

@implementation DeviceDetailHasButtonCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        buttonOne = [UIButton mrj_generalBtnTitle:@"配置网络" normalTitleColor:[MRJColorManager mrj_plainColor] highlightTitleColor:[MRJColorManager mrj_separatrixColor] normalBackImage:nil highlightBackImage:nil];
        buttonTwo = [UIButton mrj_generalBtnTitle:@"绑定店铺" normalTitleColor:[MRJColorManager mrj_plainColor] highlightTitleColor:[MRJColorManager mrj_separatrixColor] normalBackImage:nil highlightBackImage:nil];
        buttonOne.titleLabel.font = [MRJSizeManager mrjMiddleTextFont];
        buttonTwo.titleLabel.font = [MRJSizeManager mrjMiddleTextFont];
        [buttonOne addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [buttonTwo addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)buttonPressed:(UIButton*)btn
{
    if ([self.mrjDelegate respondsToSelector:@selector(cell:operation:WithData:)]) {
        if (btn==buttonTwo) {
            [self.mrjDelegate cell:self operation:MRJCellOperationTypeBindShop WithData:_deviceModel];
        }else
        {
            [self.mrjDelegate cell:self operation:MRJCellOperationTypeConfig WithData:_deviceModel];
        }
        
    }
}
-(void)configMainTableViewCellStyleWithText:(NSString *)mainText andDetailText:(NSString *)detailText buttonOneName:(NSString*)buttonOneName buttonTwoName:(NSString*)buttonTwoName;
{
    self.mainTextLabel.text = mainText;
    [self.mainTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([MRJSizeManager mrjHorizonPaddding]);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [buttonOne removeFromSuperview];
    [buttonTwo removeFromSuperview];
    self.secondTextLabel.text = detailText;
    if (_deviceModel.onLine==NO) {
        switch(_deviceModel.hardModel)
        {
            case DeviceHardModelNone://未在划定序列号范围类不支持配置网络
                break;
            case DeviceHardModelM1://m1不支持配置网络
                break;
            case DeviceHardModelM3://m3不支持配置网络
                break;
            case DeviceHardModelM4://m4不支持配置网络
                break;
            case DeviceHardModelM2:
                [self.contentView addSubview:buttonOne];
                break;
            case DeviceHardModelM1Plus:
                [self.contentView addSubview:buttonOne];
                break;
            case DeviceHardModelM2Plus:
                [self.contentView addSubview:buttonOne];
                break;
            default:
                break;
        }
        if (buttonOne.superview) {
            [buttonOne mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(buttonOne.superview);
                make.right.mas_equalTo(buttonOne.superview).offset(-[MRJSizeManager mrjHorizonPaddding]-LEFT_PADDING/2);
            }];
        }
        
        [self.secondTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (buttonOne.superview) {
               make.right.mas_equalTo(buttonOne.mas_bottom).offset(-[MRJSizeManager mrjHorizonSpace]);
            }else
            {
                make.right.mas_equalTo(self.secondTextLabel.superview).offset(-LEFT_PADDING);
            }
            make.width.lessThanOrEqualTo(self.mas_width).offset(-20);
            make.centerY.mas_equalTo(self.secondTextLabel.superview.mas_centerY);
        }];
    }else
    {
        if (detailText.length>0) {
            [self.secondTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.secondTextLabel.superview).offset(-[MRJSizeManager mrjHorizonPaddding]-LEFT_PADDING/2);
                make.centerY.mas_equalTo(self.secondTextLabel.superview.mas_centerY);
            }];
        }
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
@end
