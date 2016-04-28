//
//  DeviceListCell.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/26.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "BaseTableViewCell.h"
@class DeviceModel;
@interface DeviceListCell : BaseTableViewCell

@property(nonatomic,strong)DeviceModel *deviceModel;
@property(nonatomic,strong)UIButton *operationBtn;
@end
