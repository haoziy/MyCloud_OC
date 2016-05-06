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
    
    deviceListTable.backgroundColor = self.view.backgroundColor;
    deviceListTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [deviceListTable.mj_header endRefreshing];
        [self loadData];
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
            deviceList = obj;
            [allDevices removeAllObjects];
            [allDevices addObjectsFromArray:deviceList[0]];
            [allDevices addObjectsFromArray:deviceList[1]];
            [deviceListTable reloadData];
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
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (tableView==searchTable) {
        return nil;
    }else
    {
        
        UIView *view = [[UIView alloc]init];
        
        UILabel *label = [[UILabel alloc]init];
        view.backgroundColor = self.view.backgroundColor;
        label.text = [NSString stringWithFormat:@"%@ %lu台",section==0?@"在线":@"离线",(unsigned long)(section==0? ((NSArray*)deviceList[0]).count:((NSArray*)deviceList[1]).count)];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(LEFT_PADDING);
            make.centerY.mas_equalTo(label.superview);
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
    DeviceModel *model = nil;
    
    if (tableView==searchTable) {
        model = searchData[indexPath.row];
    }
    else
    {
        model = ((NSArray*)((NSArray*)deviceList[indexPath.section]))[indexPath.row];
    }
    cell.deviceModel = model;
    if (indexPath.row==0) {
        cell.isNeedTopSeprator = YES;
    }
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
    if (buttonIndex==1) {
        NSDictionary *param = @{@"deviceId":tempDeviceForDeleteNet.deviceId?tempDeviceForDeleteNet.deviceId:@"",@"accountId":[AppSingleton currentUser].accountId?[AppSingleton currentUser].accountId:@""};
        [HomeHttpHandler home_deleteNetWorkCMD:param preExecute:^{
        } success:^(id obj) {
            if ([obj[request_status_key] integerValue]==0) {
//                if (searchTable.hidden==NO) {
//                    DeviceModel *model = searchData[tempIndexPathForDeleteNet.row];
//                    model.onLine = NO;
//                    allDevices[tempIndexPathForDeleteNet.row] = model;
//                    [searchTable reloadRowAtIndexPath:tempIndexPathForDeleteNet withRowAnimation:UITableViewRowAnimationNone];
//                }else
//                {
//                    DeviceModel *model;
//                    if (tempIndexPathForDeleteNet.section==0) {
//                        model = onLineData[tempIndexPathForDeleteNet.row];
//                    }
//                    model.onLine = NO;
//                    deviceList[tempIndexPathForDeleteNet.section][tempIndexPathForDeleteNet.row] = model;
//                    [searchTable reloadRowAtIndexPath:tempIndexPathForDeleteNet withRowAnimation:UITableViewRowAnimationNone];
//                }
                [[NSNotificationCenter defaultCenter]postNotificationName:notification_device_online_status_key object:nil];
            }
        } failed:^(id obj) {
            
        }];
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
        alert.tag = 2000;
        tempDeviceForDeleteNet = data;
        [alert show];
        
    }else
    {

        MNGSearchDeviceForConfigNetViewController *searchConfigVC = [[MNGSearchDeviceForConfigNetViewController alloc]initWithEnterWay:DeviceConfigEnteryFromDeviceList];
        searchConfigVC.deviceModel = data;
        [RACObserve(searchConfigVC,deviceModel.onLine) subscribeNext:^(id x)
         {
             [deviceListTable reloadRowAtIndexPath:tempIndexPathForDeleteNet withRowAnimation:UITableViewRowAnimationNone];
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
    MRJLoginViewController *loginVC = [[MRJLoginViewController alloc]init];
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:loginVC];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
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
//    [RACObserve(searchConfigVC, deviceModel) subscribeNext:^(id x) {
//        if (searchTable.isHidden==NO) {
//            searchData[indexPath.row] = x;
//            [searchTable reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
//        }else
//        {
//            if (indexPath.section==0) {
//                onLineData[indexPath.row] = x;
//            }else
//            {
//                offLineData[indexPath.row] = x;
//            }
//           [deviceListTable reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
//        }
//        
//    }];
    [self.navigationController safetyPushViewController:searchConfigVC animated:YES];
}
@end
