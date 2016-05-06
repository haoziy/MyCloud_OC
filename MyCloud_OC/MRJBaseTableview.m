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
    }
    return self;
}
@end
