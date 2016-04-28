//
//  DeviceInstallHeightCell.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/28.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "DeviceInstallHeightCell.h"

@implementation DeviceInstallHeightCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _selectedFlag = [[UIImageView alloc]init];
    }
    return self;
}
-(void)configCellwithTitle:(NSString*)title andImage:(UIImage*)image;
{
    [_selectedFlag removeFromSuperview];
    self.textLabel.text = title;
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textLabel.superview).offset(LEFT_PADDING);
        make.centerY.mas_equalTo(self.textLabel.superview.mas_centerY);
    }];
    if (image) {
        [self.contentView addSubview:_selectedFlag];
        [_selectedFlag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_selectedFlag.superview.mas_centerY);
            make.right.mas_equalTo(_selectedFlag.superview).offset(-LEFT_PADDING);
        }];
    }
}
@end
