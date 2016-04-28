//
//  SelectInstallHeightViewController.h
//  EachPlan
//
//  Created by 申巧 on 15/7/8.
//  Copyright (c) 2015年 XiaoZhou. All rights reserved.
//

#import "BaseHiddenTabbarViewController.h"
@class DeviceModel;

@interface SelectInstallHeightViewController : BaseHiddenTabbarViewController<UITableViewDataSource,UITableViewDelegate>
{
    MRJBaseTableview *myTableView;
    
    NSArray *heightArray;
}


@property (nonatomic,strong) DeviceModel *deviceModel;


@end
