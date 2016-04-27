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
NSString* const indentifier_cellIdentifier = @"cell";

@interface HomeDeviceManagerViewController()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate>
{
    UITableView *deviceListTable;
    UITableView *searchTable;
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
    searchTable = [[UITableView alloc]init];
    allDevices = [[NSMutableArray alloc]init];
    
    
    
    [self.backScrollView removeFromSuperview];
    self.title = [HomeStringKeyContentValueManager homeLanguageValueForKey:language_homeDeviceManagerTitle];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:[HomeStringKeyContentValueManager homeLanguageValueForKey:language_homeDeviceManagerExitCurrentCloudTitle] style:UIBarButtonItemStylePlain target:self action:@selector(exitDeviceManager:)];
    self.navigationItem.rightBarButtonItem.tintColor = [MRJColorManager mrj_navigationTextColor];
    deviceListTable = [[UITableView alloc]init];
    deviceListTable.delegate = self;
    deviceListTable.dataSource  = self;
    [self.view addSubview:deviceListTable];
    [deviceListTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    searchViewController = [[UISearchController alloc]initWithSearchResultsController:nil];
    [searchViewController.view addSubview:searchTable];
    [searchTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(64, 0, 0, 0));
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
    NSDictionary *para = @{@"accountId":@"3254"};
    NSString *str = [NSString mrj_sigal_encode:@"{\"username\":\"alex.lo\",\"password\":\"\"}"];
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
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [MRJSizeManager mrjInputSizeHeight];
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    DeviceListCell *cell = (DeviceListCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
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
    
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark --searchViewController delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController;
{
    [searchData removeAllObjects];
    NSLog(@"%@",searchController.searchBar.text);
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
            if ([model.imei rangeOfString:searchController.searchBar.text options:NSCaseInsensitiveSearch].location != NSNotFound||[model.alias rangeOfString:searchController.searchBar.text options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [searchData addObject:allDevices[i]];
                searchTable.hidden = NO;
            }else
            {
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
    MNGSearchDeviceForConfigNetViewController *searchConfigVC = [[MNGSearchDeviceForConfigNetViewController alloc]initWithEnterWay:DeviceConfigEnteryFromDeviceList];
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
    [self.navigationController safetyPushViewController:searchConfigVC animated:YES];
}
@end
