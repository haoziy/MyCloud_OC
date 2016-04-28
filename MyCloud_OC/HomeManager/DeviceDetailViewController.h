//
//  DeviceDetailViewController.h
//  EachPlan
//
//  Created by 申巧 on 15/7/8.
//  Copyright (c) 2015年 XiaoZhou. All rights reserved.
//

#import "BaseHiddenTabbarViewController.h"
@class DeviceModel;

@interface DeviceDetailViewController : BaseHiddenTabbarViewController<UITableViewDataSource,UITableViewDelegate>
{
    MRJBaseTableview *myTableView;
    NSArray *msgArray;
    NSArray *configArray;
    
    UIButton *bindBtn;//去绑定
    UIButton* ConfBtn;//去配置
    
    UIButton *reBootBtn;
    UIButton *deleteNetBtn;
}

@property (nonatomic,strong) DeviceModel *deviceModel;
@property (nonatomic,copy) NSString *deviceId;
@end
