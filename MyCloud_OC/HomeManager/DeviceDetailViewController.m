//
//  DeviceDetailViewController.m
//  EachPlan
//
//  Created by 申巧 on 15/7/8.
//  Copyright (c) 2015年 XiaoZhou. All rights reserved.
//

#import "DeviceDetailViewController.h"
#import "DeviceModel.h"
#import "UIView+Frame.h"
#import "UIView+Additions.h"
#import "UIButton+MRJButton.h"
#import "DeviceParameterViewController.h"
#import "DeviceDetailCell.h"
#import "HomeStringKeyContentValueManager.h"
#import "HomeHttpHandler.h"
#import "DeviceDetailHasButtonCell.h"
#import "MNGSearchDeviceForConfigNetViewController.h"


extern NSString *const notification_device_online_status_key;
@interface DeviceDetailViewController ()<UIAlertViewDelegate,BaseTableViewCellDelegate>
{
    NSString *defaultStr;
    UILabel *ssidByOffLineLab;//离线后显示ssid的lab
    DeviceModel *tempDeviceForDeleteNet;
    DeviceModel *tempDeviceForReBoot;
}

@end
static NSString *myCell = @"MyCell";
@implementation DeviceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceDetailTitle];
    defaultStr = @"";
    switch (_deviceModel.hardModel) {
        case DeviceHardModelM1:
            msgArray = @[[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceAliaName],
                         [HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceSnNumber],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceWIFIMacAddress],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceLANMacAddress],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceHardModel],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceHardVersion]];
            break;
        case DeviceHardModelM1Plus:
            msgArray = @[[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceAliaName],
                         [HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceSnNumber],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceWIFIMacAddress],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceLANMacAddress],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceHardModel],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceHardVersion]];
            break;
        case DeviceHardModelM2:
            msgArray = @[[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceAliaName],
                         [HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceSnNumber],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceWIFIMacAddress],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceHardModel],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceHardVersion]];
            break;
        case DeviceHardModelM2Plus:
            msgArray = @[[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceAliaName],
                         [HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceSnNumber],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceWIFIMacAddress],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceHardModel],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceHardVersion]];
            break;
        case DeviceHardModelM3:
            msgArray = @[[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceAliaName],
                         [HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceSnNumber],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceHardModel],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceHardVersion]];
            break;
        case DeviceHardModelM4:
            msgArray = @[[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceAliaName],
                         [HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceSnNumber],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceHardModel],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceHardVersion]];
            break;
        default:
            msgArray = @[[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceAliaName],
                         [HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceSnNumber],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceWIFIMacAddress],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceHardModel],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceHardVersion]];
            break;
    }
    configArray = @[[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceOnlineStatus],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceNetConfig],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceParam]];
    
    myTableView = [[MRJBaseTableview alloc]init];
    myTableView.backgroundColor = self.view.backgroundColor;
    myTableView.scrollEnabled = NO;
    [self.backScrollView addSubview:myTableView];
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.and.right.mas_equalTo(0);
        make.centerX.mas_equalTo(myTableView.superview.mas_centerX);
        make.height.mas_equalTo((configArray.count+msgArray.count)*INPUT_HEIGHT+[MRJSizeManager mrjHorizonPaddding]*2);
    }];
    [myTableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    myTableView.dataSource = self;
    myTableView.delegate = self;

    reBootBtn = [[UIButton alloc]init];
    reBootBtn.clipsToBounds = YES;
    [reBootBtn setTitle:[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceResetButtonName] forState:UIControlStateNormal];
    reBootBtn.backgroundColor = [UIColor redColor];
    reBootBtn.layer.cornerRadius = [MRJSizeManager mrjButtonCornerRadius];
    [reBootBtn setBackgroundImage:[MRJResourceManager buttonImageFromColor:[MRJColorManager mrj_mainThemeColor] andSize:CGSizeMake(SCREEN_WIDTH-LEFT_PADDING*2, INPUT_HEIGHT)] forState:UIControlStateNormal];
    [self.backScrollView addSubview:reBootBtn];
    [reBootBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(myTableView.mas_bottom).offset(TOP_PADDING);
        make.left.mas_equalTo(LEFT_PADDING);
        make.centerX.mas_equalTo(reBootBtn.superview.mas_centerX);
        make.height.mas_equalTo(INPUT_HEIGHT);
    }];
    
    [reBootBtn addTarget:self action:@selector(reBootDevice:) forControlEvents:UIControlEventTouchUpInside];
    
    deleteNetBtn = [UIButton mrj_generalBtnTitle:[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceDeleteButtonName] normalTitleColor:NavigationTextColor highlightTitleColor:[MRJColorManager mrj_separatrixColor] normalBackImage:[MRJResourceManager buttonImageFromColor:[MRJColorManager mrj_alertColor] andSize:CGSizeMake(SCREEN_WIDTH-LEFT_PADDING*2, INPUT_HEIGHT)]  highlightBackImage:nil];
    [deleteNetBtn addTarget:self action:@selector(deleteNetConfig:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backScrollView addSubview:deleteNetBtn];
    [deleteNetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(reBootBtn.mas_bottom).offset(TOP_PADDING);
        make.left.mas_equalTo(LEFT_PADDING);
        make.centerX.mas_equalTo(deleteNetBtn.superview.mas_centerX);
        make.height.mas_equalTo(INPUT_HEIGHT);
    }];
    [self.backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(deleteNetBtn.mas_bottom).offset(TOP_PADDING*2);
    }];
    deleteNetBtn.hidden = YES;
    reBootBtn.hidden = YES;
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(netWorkStatusChange:) name:notification_device_online_status_key object:nil];
    

    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)loadData{
    [HomeHttpHandler getDeviceDetail:@{@"deviceId":_deviceModel.deviceId?_deviceModel.deviceId:@"",@"accountId":[AppSingleton currentUser].accountId?[AppSingleton currentUser].accountId:@""} preExecute:^{
        
    } success:^(id obj) {
        DeviceModel *model = (DeviceModel*)obj;
        DeviceOperationRule *rule = _deviceModel.rule;
        model.rule = rule;
        self.deviceModel = model;
        defaultStr = _deviceModel.onLine?@"在线":@"离线";
        [myTableView reloadData];
        if (_deviceModel.onLine==YES) {
            if (_deviceModel.rule.allowDelNet&&_deviceModel.rule.allowRestart) {
                deleteNetBtn.hidden = NO;
                reBootBtn.hidden = NO;
            }else if (_deviceModel.rule.allowRestart)
            {
                reBootBtn.hidden = NO;
            }else
            {
                deleteNetBtn.hidden = NO;
                [deleteNetBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(myTableView.mas_bottom).offset(TOP_PADDING);
                    make.left.mas_equalTo(LEFT_PADDING);
                    make.centerX.mas_equalTo(deleteNetBtn.superview.mas_centerX);
                    make.height.mas_equalTo(INPUT_HEIGHT);
                }];
            }
        }
        
    } failed:^(id obj) {
        
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return msgArray.count;
    }else{
        return configArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [MRJSizeManager mrjHorizonPaddding];
    }else{
        return [MRJSizeManager mrjHorizonPaddding];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,20}];
    view.backgroundColor = self.view.backgroundColor;
    
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DeviceDetailCell *cell;
    if (!cell) {
        cell = [[DeviceDetailCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:myCell];
    }
    CGFloat ROW_HEIGHT = [MRJSizeManager mrjInputSizeHeight];
    if (indexPath.section == 0) {
        NSString *text = msgArray[indexPath.row];
        if ([text isEqualToString:[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceAliaName]]) {
            [cell configMainTableViewCellStyleWithText:text andDetailText:_deviceModel.alias cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
        }
        if ([text isEqualToString:[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceWIFIMacAddress]]) {
            [cell configMainTableViewCellStyleWithText:text andDetailText:_deviceModel.wifi cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
        }
        if ([text isEqualToString:[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceLANMacAddress]]) {
            [cell configMainTableViewCellStyleWithText:text andDetailText:_deviceModel.imsi cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
        }
        if ([text isEqualToString:[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceSnNumber]]) {
            [cell configMainTableViewCellStyleWithText:text andDetailText:_deviceModel.imei cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
        }
        if ([text isEqualToString:[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceHardModel]]) {
            [cell configMainTableViewCellStyleWithText:text andDetailText:_deviceModel.displayMode cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
        }
        if ([text isEqualToString:[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceHardVersion]]) {
            [cell configMainTableViewCellStyleWithText:text andDetailText:_deviceModel.softVersion cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
        }
    }else{
        NSString *text = configArray[indexPath.row];
        if ([text isEqualToString:[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceOnlineStatus]]) {
            NSString *online = defaultStr;
            [cell configMainTableViewCellStyleWithText:text andDetailText:online cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
        }
        if ([text isEqualToString:[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceNetConfig]]) {
            DeviceDetailHasButtonCell *cell2 = [[DeviceDetailHasButtonCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"celll2"];
            cell2.deviceModel = self.deviceModel;
            [cell2 configMainTableViewCellStyleWithText:text andDetailText:_deviceModel.netName buttonOneName:nil buttonTwoName:nil];
            cell2.mrjDelegate = self;
            return cell2;
        }
        if ([text isEqualToString:[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceParam]]) {
            [cell configMainTableViewCellStyleWithText:text andDetailText:nil cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:YES selectHighlight:YES];
        }
    }
    cell.isNeedTopSeprator = indexPath.row==0;
    return cell;
}
#pragma baseCellDelegate
-(void)cell:(BaseTableViewCell*)cell operation:(MRJCellOperationType)type WithData:(id)data;
{
    if (type==MRJCellOperationTypeConfig) {
        MNGSearchDeviceForConfigNetViewController *searchConfigVC = [[MNGSearchDeviceForConfigNetViewController alloc]initWithEnterWay:DeviceConfigEnteryFromDeviceDetail];
        searchConfigVC.deviceModel = data;
        [self.navigationController safetyPushViewController:searchConfigVC animated:YES];
    }
}
#pragma mark -- alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex==1) {
        if (alertView.tag==1000) {
            if (buttonIndex==1) {
                NSDictionary *param = @{@"deviceId":tempDeviceForDeleteNet.deviceId?tempDeviceForDeleteNet.deviceId:@"",@"accountId":[AppSingleton currentUser].accountId?[AppSingleton currentUser].accountId:@""};
                [HomeHttpHandler home_rebootDeviceCMD:param preExecute:^{
                } success:^(id obj) {
                    if ([obj[request_status_key] integerValue]==0) {
                        [self loadData];
                    }
                } failed:^(id obj) {
                    
                }];
            }
        
        }else if (alertView.tag==2000)
        {
            if (buttonIndex==1) {
                NSDictionary *param = @{@"deviceId":tempDeviceForDeleteNet.deviceId?tempDeviceForDeleteNet.deviceId:@"",@"accountId":[AppSingleton currentUser].accountId?[AppSingleton currentUser].accountId:@""};
                [HomeHttpHandler home_deleteNetWorkCMD:param preExecute:^{
                } success:^(id obj) {
                    if ([obj[request_status_key] integerValue]==0) {
                        [self loadData];
                    }
                } failed:^(id obj) {
                    
                }];
            }
        }
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        NSString *text = configArray[indexPath.row];
        if ([text isEqualToString:[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceParam]]) {
            DeviceParameterViewController *devicePara = [[DeviceParameterViewController alloc] init];
            devicePara.deviceModel = _deviceModel;
            [self.navigationController safetyPushViewController:devicePara animated:YES];
        }
    }
}



- (void)reBootDevice:(UIButton *)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"设备重启需要1-2分钟，确定重启设备?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1000;
    [alert show];
    
}

- (void)deleteNetConfig:(UIButton *)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"确定删除设备的网络配置?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 2000;
    [alert show];
    
}
-(void)netWorkStatusChange:(NSNotification*)note
{
    [self loadData];
}


@end
