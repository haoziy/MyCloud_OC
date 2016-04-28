//
//  DeviceListCell.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/26.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "DeviceListCell.h"
#import "DeviceModel.h"
#import "HomeStringKeyContentValueManager.h"
@implementation DeviceListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _operationBtn = [[UIButton alloc]init];
        
    }
    return self;
}

-(void)setDeviceModel:(DeviceModel *)deviceModel
{
    if (deviceModel) {
        _deviceModel = deviceModel;
        
        self.textLabel.textColor = [MRJColorManager mrj_mainTextColor];
        self.detailTextLabel.textColor = [MRJColorManager mrj_secondaryTextColor];
        self.textLabel.font = [MRJSizeManager mrjMainTextFont];
        self.detailTextLabel.font = [MRJSizeManager mrjMiddleTextFont];
        
        self.textLabel.text = _deviceModel.alias;
        self.detailTextLabel.text = _deviceModel.imei;
        
        if (deviceModel.hardModel==DeviceHardModelNone||deviceModel.hardModel==
            DeviceHardModelM1) {
            [_operationBtn removeFromSuperview];
        }else
        {
            [self.contentView addSubview:_operationBtn];
            if(deviceModel.onLine)//在线,删除,红色
            {
                [_operationBtn setTitle:[HomeStringKeyContentValueManager homeLanguageValueForKey:language_homeDeviceManagerDelNetButtonName] forState:UIControlStateNormal];
                 [_operationBtn setTitleColor:[MRJColorManager mrj_alertColor] forState:UIControlStateNormal];
            }else
            {
                [_operationBtn setTitle:[HomeStringKeyContentValueManager homeLanguageValueForKey:language_homeDeviceManagerConfigNetButtonName] forState:UIControlStateNormal];
                [_operationBtn setTitleColor:[MRJColorManager mrj_plainColor] forState:UIControlStateNormal];
            }
            [_operationBtn setTitleColor:[MRJColorManager mrj_separatrixColor] forState:UIControlStateHighlighted];
            [_operationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_operationBtn.superview.mas_centerY);
                make.right.equalTo(_operationBtn.superview.mas_right).mas_offset(-[MRJSizeManager  mrjHorizonPaddding]);
            }];
            _operationBtn.titleLabel.font = [MRJSizeManager mrjMiddleTextFont];
        }
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset([MRJSizeManager mrjHorizonPaddding]);
            make.top.equalTo(self.contentView).offset(5);
        }];
        [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset([MRJSizeManager mrjHorizonPaddding]);
            make.top.equalTo(self.textLabel.mas_bottom).offset(5);
        }];
    }
}
@end
