//
//  MRJBaseTableview.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/28.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "MRJBaseTableview.h"

@implementation MRJBaseTableview

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [MRJColorManager mrj_mainBackgroundColor];
        self.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.rowHeight = INPUT_HEIGHT;
        
        UILabel* noDataLabel = [[UILabel alloc]init];
        noDataLabel.text = @"暂时没有设备";
        [self addSubview:noDataLabel];
        [noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(noDataLabel.superview.mas_centerX);
            make.centerY.mas_equalTo(noDataLabel.superview.mas_centerY);
        }];
        _noDataSetView = noDataLabel;
        _noDataSetView.hidden = YES;
    }
    return self;
}
@end
