//
//  HomeDeviceManagerViewController.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/26.
//  Copyright © 2016年 laomi. All rights reserved.
//


#import "HomeDeviceManagerViewController.h"
#import "HomeStringKeyContentValueManager.h"
#import "BaseNavigationViewController.h"
#import "MRJLoginViewController.h"
#import "DeviceListCell.h"
#import "HomeHttpHandler.h"
#import "DeviceModel.h"
#import "MNGSearchDeviceForConfigNetViewController.h"
#import "MNGDeviceNetConfigViewController.h"
#import "DeviceDetailViewController.h"
NSString * const notification_device_online_status_key = @"notification_device_online_status_key" ;//设备网络状态发生变化
NSInteger const deletNetAlertTag = 2000;
NSInteger const exitAlertTag = 3000;

@interface HomeDeviceManagerViewController()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate,BaseTableViewCellDelegate,UIAlertViewDelegate>
{
    MRJBaseTableview *deviceListTable;
    MRJBaseTableview *searchTable;
    UISearchController *searchViewController;
    NSMutableArray *searchData;
    NSArray *deviceList;
    NSMutableArray *allDevices;
    DeviceModel *tempDeviceForDeleteNet;
    NSIndexPath *tempIndexPathForDeleteNet;
    
    UILabel *noDataLabel;
}

@end

@implementation HomeDeviceManagerViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    searchData = [[NSMutableArray alloc]init];
    searchTable = [[MRJBaseTableview alloc]init];
    allDevices = [[NSMutableArray alloc]init];
    
    
    
    [self.backScrollView removeFromSuperview];
    self.title = [HomeStringKeyContentValueManager homeLanguageValueForKey:language_homeDeviceManagerTitle];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:[HomeStringKeyContentValueManager homeLanguageValueForKey:language_homeDeviceManagerExitCurrentCloudTitle] style:UIBarButtonItemStylePlain target:self action:@selector(exitDeviceManager:)];
    self.navigationItem.rightBarButtonItem.tintColor = [MRJColorManager mrj_navigationTextColor];
    deviceListTable = [[MRJBaseTableview alloc]init];
    deviceListTable.delegate = self;
    deviceListTable.dataSource  = self;
    [self.view addSubview:deviceListTable];
    [deviceListTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    
    searchViewController = [[UISearchController alloc]initWithSearchResultsController:nil];
    [searchViewController.view addSubview:searchTable];
    [searchTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(64, 0, -64, 0));
    }];
    self.definesPresentationContext = YES;
    searchTable.delegate = self;
    searchTable.dataSource  = self;
    searchTable.hidden = YES;
    searchViewController.searchResultsUpdater = self;
    searchViewController.delegate = self;
    [searchViewController.searchBar sizeToFit];
    searchViewController.searchBar.tintColor = [MRJColorManager mrj_mainThemeColor];
    searchViewController.searchBar.placeholder = [HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerSearchDevicePlacement];
    deviceListTable.tableHeaderView = searchViewController.searchBar;
    [deviceListTable setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    __weak HomeDeviceManagerViewController * weakSelf = self;
    __weak MRJBaseTableview *weakTable = deviceListTable;
    deviceListTable.backgroundColor = self.view.backgroundColor;
    deviceListTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakTable.mj_header endRefreshing];
        [weakSelf loadData];
    }];
    deviceListTable.mj_header.backgroundColor = deviceListTable.backgroundColor;
    [self loadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(netWorkStatusChange:) name:notification_device_online_status_key object:nil];
}
-(void)loadData
{
    NSDictionary *para = @{@"accountId":[[AppSingleton currentUser] accountId]==nil?@"":[[AppSingleton currentUser] accountId]};
    [HomeHttpHandler getDeviceListParams:para preExecute:^{
        
    } success:^(id obj) {
        [deviceListTable.mj_header endRefreshing];
        if ([obj isKindOfClass:[NSArray class]]) {
            deviceListTable.noDataSetView.hidden = YES;
            deviceList = obj;
            [allDevices removeAllObjects];
            [allDevices addObjectsFromArray:deviceList[0]];
            [allDevices addObjectsFromArray:deviceList[1]];
            [deviceListTable reloadData];
        }else
        {
            deviceListTable.noDataSetView.hidden = NO;
        }
    } failed:^(id obj) {
      [deviceListTable.mj_header endRefreshing];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==searchTable) {
        return 0;
    }else 
    {
        return [MRJSizeManager mrjInputSizeHeight];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    if (tableView==searchTable) {
        return 0;
    }else if(section==0)
    {
        return [MRJSizeManager mrjVerticalSpace]*2;
    }else
    {
        return 0;
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (tableView==searchTable) {
        return nil;
    }else
    {
        
        UIView *view = [[UIView alloc]init];
        
        UILabel *label = [[UILabel alloc]init];
        view.backgroundColor = NavigationTextColor;
        label.text = [NSString stringWithFormat:@"%@ ",section==0?@"在线":@"离线"];
        [view addSubview:label];
        UILabel *label2 = [[UILabel alloc]init];
        label2.text = [NSString stringWithFormat:@"%ld台",(unsigned long)(section==0? ((NSArray*)deviceList[0]).count:((NSArray*)deviceList[1]).count)];
        label2.textColor = SecondaryTextColor;
        [view addSubview:label2];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(LEFT_PADDING);
            make.centerY.mas_equalTo(label.superview);
        }];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right);
            make.centerY.mas_equalTo(label2.superview);
        }];
        return view;
        
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==searchTable) {
        return 1;
    }
    return deviceList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (tableView==searchTable) {
        return searchData.count;
    }
    
    return  ((NSArray*)((NSArray*)deviceList[section])).count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    DeviceListCell *cell = (DeviceListCell*)[tableView dequeueReusableCellWithIdentifier:indentifier_cellIdentifier];
    if (!cell) {
        cell = [[DeviceListCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier_cellIdentifier];
    }
    cell.isNeedTopSeprator = indexPath.row==0;
    DeviceModel *model = nil;
    
    if (tableView==searchTable) {
        model = searchData[indexPath.row];
    }
    else
    {
        model = ((NSArray*)((NSArray*)deviceList[indexPath.section]))[indexPath.row];
    }
    cell.deviceModel = model;
    cell.mrjDelegate = self;
    return cell;
}
#pragma mark --notifcation callback
-(void)netWorkStatusChange:(NSNotification*)note
{
    [self loadData];
}

#pragma mark --alertViewDelegateMethod
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (alertView.tag==deletNetAlertTag) {
        if (buttonIndex==1) {
            NSDictionary *param = @{@"deviceId":tempDeviceForDeleteNet.deviceId?tempDeviceForDeleteNet.deviceId:@"",@"accountId":[AppSingleton currentUser].accountId?[AppSingleton currentUser].accountId:@""};
            [HomeHttpHandler home_deleteNetWorkCMD:param preExecute:^{
            } success:^(id obj) {
                if ([obj[request_status_key] integerValue]==0) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:notification_device_online_status_key object:nil];
                }
            } failed:^(id obj) {
                
            }];
        }
    }else if(alertView.tag ==exitAlertTag)
    {
        if (buttonIndex==1) {
            MRJLoginViewController *loginVC = [[MRJLoginViewController alloc]init];
            self.navigationController.viewControllers = @[loginVC];
        }
       
    }
    
}
#pragma mark --baseCellDelegateMethod
-(void)cell:(BaseTableViewCell*)cell operation:(MRJCellOperationType)type WithData:(id)data;
{
    if (searchTable.hidden == YES) {
        tempIndexPathForDeleteNet = [deviceListTable indexPathForCell:cell];
    }else
    {
        tempIndexPathForDeleteNet = [deviceListTable indexPathForCell:cell];
    }
    if (type==MRJCellOperationTypeDelete) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"确定删除设备的网络配置?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = deletNetAlertTag;
        tempDeviceForDeleteNet = data;
        [alert show];
        
    }else
    {

        MNGSearchDeviceForConfigNetViewController *searchConfigVC = [[MNGSearchDeviceForConfigNetViewController alloc]initWithEnterWay:DeviceConfigEnteryFromDeviceList];
        searchConfigVC.deviceModel = data;
        
        __weak MRJBaseTableview *weakTable = deviceListTable;
        [searchConfigVC getAuthInfo];
        [RACObserve(searchConfigVC,deviceModel.onLine) subscribeNext:^(id x)
         {
             [weakTable reloadRowAtIndexPath:tempIndexPathForDeleteNet withRowAnimation:UITableViewRowAnimationNone];
         }];
        [self.navigationController safetyPushViewController:searchConfigVC animated:YES];
    }
    
}

#pragma mark --searchViewController delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController;
{
    [searchData removeAllObjects];
    if (searchViewController.searchBar.text.length==0) {
        searchTable.hidden = YES;
        
        [searchTable reloadData];
        return;
    }else
    {
        for (NSUInteger i = 0; i < [allDevices count]; i ++)
        {
            DeviceModel *model = allDevices[i];
            //在每一个model里查找这个字符串\n，判断有没有
            if ((model.imei.length>0&&[model.imei rangeOfString:searchController.searchBar.text options:NSCaseInsensitiveSearch].location != NSNotFound)||(model.alias.length>0&&[model.alias rangeOfString:searchController.searchBar.text options:NSCaseInsensitiveSearch].location != NSNotFound)) {
                [searchData addObject:allDevices[i]];
                searchTable.hidden = NO;
            }
            
        }
    }
    [searchTable reloadData];
}
- (void)willPresentSearchController:(UISearchController *)searchController;
{
    
}
- (void)didPresentSearchController:(UISearchController *)searchController;
{
    
}
- (void)willDismissSearchController:(UISearchController *)searchController;
{
     
}
- (void)didDismissSearchController:(UISearchController *)searchController;
{
    [deviceListTable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    searchTable.hidden = YES;
}
- (void)presentSearchController:(UISearchController *)searchController;
{
    
}
-(void)exitDeviceManager:(id)sender
{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"确定要退出吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = exitAlertTag;
    [alert show];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DeviceDetailViewController *searchConfigVC = [[DeviceDetailViewController alloc]init];
    DeviceModel *model = nil;
    
    if (tableView==searchTable) {
        model = searchData[indexPath.row];
    }else
    {
        model = ((NSArray*)((NSArray*)deviceList[indexPath.section]))[indexPath.row];
    }
    searchConfigVC.deviceModel = model;
    [self.navigationController safetyPushViewController:searchConfigVC animated:YES];
}
@end
