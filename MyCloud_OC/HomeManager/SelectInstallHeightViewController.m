//
//  SelectInstallHeightViewController.m
//  EachPlan
//
//  Created by 申巧 on 15/7/8.
//  Copyright (c) 2015年 XiaoZhou. All rights reserved.
//

#import "SelectInstallHeightViewController.h"

#import "UIView+Frame.h"
#import "UIView+Additions.h"
#import "DeviceModel.h"
#import "DeviceInstallHeightCell.h"
#import "HomeStringKeyContentValueManager.h"
@interface SelectInstallHeightViewController()
{
    DeviceInstallHeightCell *defaultCell;//已经选中的cell
}

@end

@implementation SelectInstallHeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceParamSelectInstallHeightTitle];
    
    if ([_deviceModel.lens isEqualToString:@"1"]) {
        heightArray = @[[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceParamInstallHeightBelow2Point6],[HomeStringKeyContentValueManager languageValueForKey:language_homeDevcceParamInstallHeightEqual2Point6To2Point8],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceParamInstallHeightAbove2Point8]];
    }else if ([_deviceModel.lens isEqualToString:@"2"]){
        heightArray = @[[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceParamInstallHeightBelow3Point2],[HomeStringKeyContentValueManager languageValueForKey:language_homeDevcceParamInstallHeightEqual3Point2To3Point4],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceParamInstallHeightAbove3Point4]];
    }else if ([_deviceModel.lens isEqualToString:@"3"]){
        heightArray = @[[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceParamInstallHeightBelow3Point5],[HomeStringKeyContentValueManager languageValueForKey:language_homeDevcceParamInstallHeightEqual3Point5To3Point8],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceParamInstallHeightAbove3Point8]];
    }
//
    myTableView = [[MRJBaseTableview  alloc]init];
    myTableView.scrollEnabled = NO;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    [self.backScrollView removeFromSuperview];
    [self.view addSubview:myTableView];
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return heightArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myCell = @"MyCell";
    DeviceInstallHeightCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (!cell) {
        cell = [[DeviceInstallHeightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCell];
        defaultCell = cell;
    }
    if ([_deviceModel.installHeight isEqualToString:heightArray[indexPath.row]]) {
        [cell configCellwithTitle:heightArray[indexPath.row] andImage: [UIImage imageNamed:@"select"]];
    }else
    {
        [cell configCellwithTitle:heightArray[indexPath.row] andImage:nil];
    }
    if (indexPath.row ==0) {
        cell.isNeedTopSeprator = YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [defaultCell configCellwithTitle:defaultCell.textLabel.text andImage: nil];
    DeviceInstallHeightCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell configCellwithTitle:heightArray[indexPath.row] andImage: [UIImage imageNamed:@"select"]];
    defaultCell = cell;
    _deviceModel.height = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    ShopTableViewCell *cell = (ShopTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    cell.ringImageView.image = [UIImage imageNamed:@"select_white"];
}

@end
