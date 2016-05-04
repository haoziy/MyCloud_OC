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


@interface HomeDeviceManagerViewController()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate,BaseTableViewCellDelegate>
{
    MRJBaseTableview *deviceListTable;
    MRJBaseTableview *searchTable;
    NSMutableArray *onLineData;
    NSMutableArray *offLineData;
    UISearchController *searchViewController;
    NSMutableArray *searchData;
    NSDictionary *deviceList;
    NSMutableArray *allDevices;
}

@end

@implementation HomeDeviceManagerViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    onLineData = [[NSMutableArray alloc]init];
    offLineData = [[NSMutableArray alloc]init];
    
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
    [self loadData];
}
-(void)loadData
{
    NSDictionary *para = @{@"accountId":[[AppSingleton shareInstace] accountId]==nil?@"":[[AppSingleton shareInstace] accountId]};
    [HomeHttpHandler getDeviceListParams:para preExecute:^{
        
    } success:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            deviceList = obj;
            offLineData = [obj objectForKey:key_offLineDeviceKey];
            onLineData = [obj objectForKey:key_onLineDeviceKey];
            [allDevices removeAllObjects];
            [allDevices addObjectsFromArray:offLineData];
            [allDevices addObjectsFromArray:onLineData];
            [deviceListTable reloadData];
        }
    } failed:^(id obj) {
        
        
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
        label.text = [NSString stringWithFormat:@"%@ %lu台",section==0?@"在线":@"离线",(unsigned long)(section==0?onLineData.count:offLineData.count)];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(LEFT_PADDING);
            make.centerY.mas_equalTo(label.superview);
        }];
//        view.size = CGSizeMake(tableView.width,[MRJSizeManager mrjInputSizeHeight]);
//        [label sizeToFit];
//        label.origin = CGPointMake(LEFT_PADDING,(view.height-label.height)/2);
        return view;
        
    }
}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return [MRJSizeManager mrjTableHeadHeight];
//}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==searchTable) {
        return 1;
    }
    return [deviceList allKeys].count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (tableView==searchTable) {
        return searchData.count;
    }
    
    if (section==0) {
        return onLineData.count;
    }else
    {
        return offLineData.count;
    }
    return 0;
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
        if (indexPath.section==0) {
            model = onLineData[indexPath.row];
        }else
        {
            model = offLineData[indexPath.row];
        }
    }
    cell.deviceModel = model;
    if (indexPath.row==0) {
        cell.isNeedTopSeprator = YES;
    }
    cell.mrjDelegate = self;
    return cell;
}
#pragma mark --baseCellDelegateMethod
-(void)cell:(BaseTableViewCell*)cell operation:(MRJCellOperationType)type WithData:(id)data;
{
    if (type==MRJCellOperationTypeDelete) {
        
    }else
    {
//        MNGDeviceNetConfigViewController *searchConfigVC = [[MNGDeviceNetConfigViewController alloc]init];
                MNGSearchDeviceForConfigNetViewController *searchConfigVC = [[MNGSearchDeviceForConfigNetViewController alloc]initWithEnterWay:DeviceConfigEnteryFromDeviceList];
        searchConfigVC.deviceModel = data;
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
        if (indexPath.section==0) {
            model = onLineData[indexPath.row];
        }else
        {
            model = offLineData[indexPath.row];
        }
    }
    searchConfigVC.deviceModel = model;
    [RACObserve(searchConfigVC, deviceModel) subscribeNext:^(id x) {
        if (searchTable.isHidden==NO) {
            [searchTable reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
        }else
        {
           [deviceListTable reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }];
    [self.navigationController safetyPushViewController:searchConfigVC animated:YES];
}
@end
