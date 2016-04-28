//
//  DeviceInstallHeightCell.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/28.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface DeviceInstallHeightCell : BaseTableViewCell

@property(nonatomic,strong)UIImageView *selectedFlag;
-(void)configCellwithTitle:(NSString*)title andImage:(UIImage*)image;
@end
