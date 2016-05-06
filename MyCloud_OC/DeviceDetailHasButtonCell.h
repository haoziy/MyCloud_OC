//
//  DeviceDetailHasButtonCell.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/5/6.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "DeviceModel.h"
@interface DeviceDetailHasButtonCell : BaseTableViewCell

@property(nonatomic,strong)DeviceModel *deviceModel;


-(void)configMainTableViewCellStyleWithText:(NSString *)mainText andDetailText:(NSString *)detailText buttonOneName:(NSString*)buttonOneName buttonTwoName:(NSString*)buttonTwoName;
@end
