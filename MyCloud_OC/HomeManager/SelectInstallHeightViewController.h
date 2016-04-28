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
    UITableView *myTableView;
    
    NSArray *heightArray;
}

@property (weak, nonatomic) IBOutlet UIScrollView *mySccrollView;

@property (nonatomic,strong) DeviceModel *deviceModel;


@end
