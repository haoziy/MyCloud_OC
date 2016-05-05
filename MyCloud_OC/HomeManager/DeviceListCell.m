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
        [_operationBtn addTarget:self action:@selector(operaionBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:_operationBtn];
    }
    return self;
}

-(void)setDeviceModel:(DeviceModel *)deviceModel
{
    if (deviceModel) {
        _deviceModel = deviceModel;
        
        self.mainTextLabel.textColor = [MRJColorManager mrj_mainTextColor];
        self.secondTextLabel.textColor = [MRJColorManager mrj_secondaryTextColor];
        self.mainTextLabel.font = [MRJSizeManager mrjMainTextFont];
        self.secondTextLabel.font = [MRJSizeManager mrjMiddleTextFont];
        
        self.mainTextLabel.text = _deviceModel.alias==nil?@"":_deviceModel.alias;
        self.secondTextLabel.text = _deviceModel.imei;
        [self.mainTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset([MRJSizeManager mrjHorizonPaddding]);
            make.top.equalTo(self.contentView).offset(5);
        }];
        [self.secondTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset([MRJSizeManager mrjHorizonPaddding]);
            make.top.equalTo(self.contentView.mas_centerY).offset(5);
        }];
        
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
        
    }
}
-(void)operaionBtnPressed:(UIButton*)btn
{
    if ([self.mrjDelegate respondsToSelector:@selector(cell:operation:WithData:)]) {
        if (self.deviceModel.onLine) {
            [self.mrjDelegate cell:self operation:MRJCellOperationTypeDelete WithData:self.deviceModel];
        }else
        {
            [self.mrjDelegate cell:self operation:MRJCellOperationTypeConfig WithData:self.deviceModel];
        }
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
//    NSLog(@"%@",self.mainTextLabel.superview);
}

@end
