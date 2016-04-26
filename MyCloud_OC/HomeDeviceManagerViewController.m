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
@interface HomeDeviceManagerViewController()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate>
{
    UITableView *deviceListTable;
    UITableView *searchTable;
    NSMutableArray *data;
    UISearchController *searchViewController;
    NSMutableArray *searchData;
    
}

@end

@implementation HomeDeviceManagerViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    data = [[NSMutableArray alloc]init];
    searchData = [[NSMutableArray alloc]init];
    searchTable = [[UITableView alloc]init];

    
    
    
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
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    searchTable.hidden = YES;
    searchViewController.searchResultsUpdater = self;
    searchViewController.delegate = self;
    [searchViewController.searchBar sizeToFit];
    deviceListTable.tableHeaderView = searchViewController.searchBar;
    [self loadData];
}
-(void)loadData
{
    [HomeHttpHandler getDeviceListParams:@{@"":@""} preExecute:^{
        
    } success:^(id obj) {
        
    } failed:^(id obj) {
        
    }];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 5;
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell.contentView).mas_offset(200);
        make.centerY.mas_equalTo(cell.contentView.mas_centerY);
    }];
    cell.textLabel.text = @"s";
    cell.detailTextLabel.text = @"aa";
    [cell.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(cell.contentView).mas_offset(-200);
        make.centerY.mas_equalTo(cell.contentView.mas_centerY);
    }];
    return cell;
}
#pragma mark --searchViewController delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController;
{
    
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
    
}
@end
