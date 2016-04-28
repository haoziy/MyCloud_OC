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



#import "MNGSearchDeviceForConfigNetViewController.h"



@interface DeviceDetailViewController ()<UIAlertViewDelegate>
{
    NSString *defaultStr;
    UILabel *ssidByOffLineLab;//离线后显示ssid的lab
}

@end

@implementation DeviceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设备详情";
    defaultStr = @"";
    switch (_deviceModel.hardModel) {
        case DeviceHardModelM1:
            msgArray = @[@"名称",@"序列号",@"无线MAC",@"有线MAC",@"型号",@"固件版本"];
            break;
        case DeviceHardModelM1Plus:
            msgArray = @[@"名称",@"序列号",@"无线MAC",@"有线MAC",@"型号",@"固件版本"];
            break;
        case DeviceHardModelM2:
            msgArray = @[@"名称",@"序列号",@"无线MAC",@"型号",@"固件版本"];
            break;
        case DeviceHardModelM2Plus:
            msgArray = @[@"名称",@"序列号",@"无线MAC",@"型号",@"固件版本"];
            break;
        case DeviceHardModelM3:
            msgArray = @[@"名称",@"序列号",@"型号",@"固件版本"];
            break;
        case DeviceHardModelM4:
            msgArray = @[@"名称",@"序列号",@"型号",@"固件版本"];
            break;
        default:
            msgArray = @[@"名称",@"序列号",@"无线MAC",@"型号",@"固件版本"];
            break;
    }
    configArray = @[@"在线状态",@"网络配置",@"设备参数"];
    
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
    [reBootBtn setTitle:@"重启设备" forState:UIControlStateNormal];
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
    
    [reBootBtn addTarget:self action:@selector(reTurnOnDevice:) forControlEvents:UIControlEventTouchUpInside];
    
    deleteNetBtn = [UIButton mrj_generalBtnTitle:@"删除网络配置" normalTitleColor:NavigationTextColor highlightTitleColor:[MRJColorManager mrj_separatrixColor] normalBackImage:[MRJResourceManager buttonImageFromColor:[MRJColorManager mrj_alertColor] andSize:CGSizeMake(SCREEN_WIDTH-LEFT_PADDING*2, INPUT_HEIGHT)]  highlightBackImage:nil];
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
//    ConfBtn = [UIButton initWithBakColor:[UIColor clearColor] colorHighlighted:[UIColor clearColor] text:@"配置网络" size:(CGSize){90,40} tag:-1 cornerRadius:0];
//    ConfBtn.titleLabel.font = MainTitleFont;
//    [ConfBtn sizeToFit];
//    ConfBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [ConfBtn setTitleColor:PlainButtonColor forState:UIControlStateNormal];
//    [ConfBtn setTitleColor:SeparatrixColor forState:UIControlStateHighlighted];
//
//    ssidByOffLineLab = [[UILabel alloc]init];
//    ssidByOffLineLab.font = Cell_Font;
//    ssidByOffLineLab.textColor = MainTextColor;
//    [ConfBtn addTarget:self action:@selector(confNet:) forControlEvents:UIControlEventTouchUpInside];
//    
//
//    __block UIScrollView * scrollView = _myScrollView;
//    __block DeviceDetailViewController * self_ = self;
//    [_myScrollView addLegendHeaderWithRefreshingBlock:^{
//        [AppUtils showProgressMessageWithNotAllowTouch:TEXT_NETWORK_PROCESS];
//        [self_ loadData];
//        [scrollView.header endRefreshing];
//    }];
//    _myScrollView.header.updatedTimeHidden = YES;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindGateComplete:) name:DEVICE_BIND_GATE object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)loadData{
//    [DeviceManageHandler myDeviceDetailWithDeviceId:_deviceId Success:^(id obj) {
//        if ([obj isKindOfClass:[DeviceModel class]]) {
//            [AppUtils dismissHUD];
//            [reBootBtn removeFromSuperview];
//            [deleteNetBtn removeFromSuperview];
//            _deviceModel = obj;
//            defaultStr = _deviceModel.onLine?@"在线":@"离线";
//            switch (_deviceModel.hardModel) {
//                case DeviceHardModelM1:
//                    if (_deviceModel.initNetwork&&_deviceModel.onLine&&_deviceModel.softVersionInt>=133)//m1在线,初始化网络,版本大于133
//                    {
//                        deleteNetBtn.hidden = NO;
//                        reBootBtn.hidden = NO;
//                        [_myScrollView addSubview:reBootBtn];
//                        [_myScrollView addSubview:deleteNetBtn];
//                    }else
//                    {
//                        reBootBtn.hidden = YES;
//                        deleteNetBtn.hidden = YES;
//                    }
//                    break;
//                case DeviceHardModelM2://m2/m2s/m1s在线,初始化网络即可
//                    if (_deviceModel.initNetwork&&_deviceModel.onLine) {
//                        deleteNetBtn.hidden = NO;
//                        reBootBtn.hidden = NO;
//                        [_myScrollView addSubview:reBootBtn];
//                        [_myScrollView addSubview:deleteNetBtn];
//                    }else
//                    {
//                        reBootBtn.hidden = YES;
//                        deleteNetBtn.hidden = YES;
//                    }
//                    break;
//                case DeviceHardModelM1Plus:
//                    if (_deviceModel.initNetwork&&_deviceModel.onLine) {
//                        deleteNetBtn.hidden = NO;
//                        reBootBtn.hidden = NO;
//                        [_myScrollView addSubview:reBootBtn];
//                        [_myScrollView addSubview:deleteNetBtn];
//                    }else
//                    {
//                        reBootBtn.hidden = YES;
//                        deleteNetBtn.hidden = YES;
//                    }
//                    break;
//                case DeviceHardModelM2Plus:
//                    if (_deviceModel.initNetwork&&_deviceModel.onLine) {
//                        deleteNetBtn.hidden = NO;
//                        reBootBtn.hidden = NO;
//                        [_myScrollView addSubview:reBootBtn];
//                        [_myScrollView addSubview:deleteNetBtn];
//                    }else
//                    {
//                        reBootBtn.hidden = YES;
//                        deleteNetBtn.hidden = YES;
//                    }
//                    break;
//                case DeviceHardModelM3://M3在线就可以重启
//                    if (_deviceModel.onLine) {
//                        reBootBtn.hidden = NO;
//                        [_myScrollView addSubview:reBootBtn];
//                    }else
//                    {
//                        reBootBtn.hidden = YES;
//                    }
//                      deleteNetBtn.hidden = YES;
//                    break;
//                case DeviceHardModelM4://M4在线就可以重启
//                    if (_deviceModel.onLine) {
//                        reBootBtn.hidden = NO;
//                        [_myScrollView addSubview:reBootBtn];
//                    }else
//                    {
//                        reBootBtn.hidden = YES;
//                    }
//                    deleteNetBtn.hidden = YES;
//                default:
//                    break;
//            }
//            [myTableView reloadData];
//        }else{
//            [AppUtils showErrorMessage:obj];
//        }
//    } Failed:^(id obj) {
//        [AppUtils showErrorMessage:TEXT_SERVER_NOT_RESPOND];
//    }];
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
    static NSString *myCell = @"MyCell";
    DeviceDetailCell *cell;
    if (!cell) {
        cell = [[DeviceDetailCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:myCell];
    }
    CGFloat ROW_HEIGHT = [MRJSizeManager mrjInputSizeHeight];
    if (indexPath.section == 0) {
        NSString *text = msgArray[indexPath.row];
        if ([text isEqualToString:@"名称"]) {
            [cell configMainTableViewCellStyleWithText:text andDetailText:_deviceModel.alias cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
        }
        if ([text isEqualToString:@"无线MAC"]) {
            [cell configMainTableViewCellStyleWithText:text andDetailText:_deviceModel.wifi cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
        }
        if ([text isEqualToString:@"有线MAC"]) {
            [cell configMainTableViewCellStyleWithText:text andDetailText:_deviceModel.imsi cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
        }
        if ([text isEqualToString:@"序列号"]) {
            [cell configMainTableViewCellStyleWithText:text andDetailText:_deviceModel.imei cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
        }
        if ([text isEqualToString:@"型号"]) {
            [cell configMainTableViewCellStyleWithText:text andDetailText:_deviceModel.displayMode cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
        }
        if ([text isEqualToString:@"固件版本"]) {
            [cell configMainTableViewCellStyleWithText:text andDetailText:_deviceModel.softVersion cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
        }
    }else{
        NSString *text = configArray[indexPath.row];
        if ([text isEqualToString:@"在线状态"]) {
            NSString *online = defaultStr;
            [cell configMainTableViewCellStyleWithText:text andDetailText:online cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
        }
        if ([text isEqualToString:@"网络配置"]) {
            switch (_deviceModel.hardModel) {
                case DeviceHardModelNone://未在划定序列号范围类不支持配置网络
                    [cell configMainTableViewCellStyleWithText:text andDetailText:_deviceModel.netName cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
                    break;
                case DeviceHardModelM1://m1不支持配置网络
                    [cell configMainTableViewCellStyleWithText:text andDetailText:_deviceModel.netName cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
                    break;
                case DeviceHardModelM3://m3不支持配置网络
                    [cell configMainTableViewCellStyleWithText:text andDetailText:_deviceModel.netName cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
                    break;
                case DeviceHardModelM4://m4不支持配置网络
                    [cell configMainTableViewCellStyleWithText:text andDetailText:_deviceModel.netName cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
                    break;
                case DeviceHardModelM2:
                    if(_deviceModel.onLine)//在线
                    {
                        [cell configMainTableViewCellStyleWithText:text andDetailText:_deviceModel.netName cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
                    }else
                    {
                        if([_deviceModel initNetwork])//绑定网络
                        {
                            [cell removeFromSuperview];
                            cell = nil;
                            cell = [[DeviceDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                            [cell configMainTableViewCellStyleWithText:text andDetailText:nil cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
                            
                            
                            ssidByOffLineLab.text = _deviceModel.netName;
                            ssidByOffLineLab.textColor = SecondaryTextColor;
                            [ssidByOffLineLab sizeToFit];
                            CGFloat postion;
                            if (ssidByOffLineLab.width>90) {
                                postion = 90;
                            }else
                            {
                                postion = ssidByOffLineLab.width;
                            }
                            ConfBtn.origin = (CGPoint){cell.width-ConfBtn.width-RIGHT_PADDING*2,(ROW_HEIGHT-ConfBtn.height)/2};
                            [cell.contentView addSubview:ConfBtn];
                            ssidByOffLineLab.frame = CGRectMake(ConfBtn.x-postion, (cell.height-ssidByOffLineLab.height)/2, postion, ssidByOffLineLab.height);
                            [cell.contentView addSubview:ssidByOffLineLab];
                        }else
                        {
                            [cell configMainTableViewCellStyleWithText:text andDetailText:nil cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
                            ConfBtn.origin = (CGPoint){cell.width-ConfBtn.width-RIGHT_PADDING*2,(ROW_HEIGHT-ConfBtn.height)/2};
                            [cell.contentView addSubview:ConfBtn];
                        }
                    }
                    break;
                case DeviceHardModelM1Plus:
                    if(_deviceModel.onLine)//在线
                    {
                        [cell configMainTableViewCellStyleWithText:text andDetailText:_deviceModel.netName cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
                    }else
                    {
                        if([_deviceModel initNetwork])//绑定网络
                        {
                            [cell removeFromSuperview];
                            cell = nil;
                            cell = [[DeviceDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                            [cell configMainTableViewCellStyleWithText:text andDetailText:nil cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
                            
                            
                            ssidByOffLineLab.text = _deviceModel.netName;
                            ssidByOffLineLab.textColor = SecondaryTextColor;
                            [ssidByOffLineLab sizeToFit];
                            CGFloat postion;
                            if (ssidByOffLineLab.width>90) {
                                postion = 90;
                            }else
                            {
                                postion = ssidByOffLineLab.width;
                            }
                            ConfBtn.origin = (CGPoint){cell.width-ConfBtn.width-LEFT_PADDING*2,(ROW_HEIGHT-ConfBtn.height)/2};
                            [cell.contentView addSubview:ConfBtn];
                            ssidByOffLineLab.frame = CGRectMake(ConfBtn.x-postion, (cell.height-ssidByOffLineLab.height)/2, postion, ssidByOffLineLab.height);
                            [cell.contentView addSubview:ssidByOffLineLab];
                        }else
                        {
                            [cell configMainTableViewCellStyleWithText:text andDetailText:nil cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
                            ConfBtn.origin = (CGPoint){cell.width-ConfBtn.width-LEFT_PADDING*2,(ROW_HEIGHT-ConfBtn.height)/2};
                            [cell.contentView addSubview:ConfBtn];
                        }
                    }
                    break;
                case DeviceHardModelM2Plus:
                    if(_deviceModel.onLine)//在线
                    {
                        [cell configMainTableViewCellStyleWithText:text andDetailText:_deviceModel.netName cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
                    }else
                    {
                        if([_deviceModel initNetwork])//绑定网络
                        {
                            [cell removeFromSuperview];
                            cell = nil;
                            cell = [[DeviceDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                            [cell configMainTableViewCellStyleWithText:text andDetailText:nil cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
                            
                            
                            ssidByOffLineLab.text = _deviceModel.netName;
                            ssidByOffLineLab.textColor = SecondaryTextColor;
                            [ssidByOffLineLab sizeToFit];
                            CGFloat postion;
                            if (ssidByOffLineLab.width>90) {
                                postion = 90;
                            }else
                            {
                                postion = ssidByOffLineLab.width;
                            }
                            ConfBtn.origin = (CGPoint){cell.width-ConfBtn.width-LEFT_PADDING*2,(ROW_HEIGHT-ConfBtn.height)/2};
                            [cell.contentView addSubview:ConfBtn];
                            ssidByOffLineLab.frame = CGRectMake(ConfBtn.x-postion, (cell.height-ssidByOffLineLab.height)/2, postion, ssidByOffLineLab.height);
                            [cell.contentView addSubview:ssidByOffLineLab];
                        }else
                        {
                            [cell configMainTableViewCellStyleWithText:text andDetailText:nil cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
                            ConfBtn.origin = (CGPoint){cell.width-ConfBtn.width-LEFT_PADDING*2,(ROW_HEIGHT-ConfBtn.height)/2};
                            [cell.contentView addSubview:ConfBtn];
                        }
                    }
                    break;
                default:
                    [cell configMainTableViewCellStyleWithText:text andDetailText:_deviceModel.netName cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
                    break;
            }
        }
        if ([text isEqualToString:@"所在店铺"]) {
            if (_deviceModel.initBind) {
                [cell configMainTableViewCellStyleWithText:text andDetailText:[NSString stringWithFormat:@"%@(%@)",_deviceModel.shopName,_deviceModel.wayName] cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:YES selectHighlight:YES];
                [bindBtn removeFromSuperview];
            }else{
               
                [cell removeFromSuperview];
                cell = nil;
                cell = [[DeviceDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                [cell configMainTableViewCellStyleWithText:text andDetailText:nil cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:NO selectHighlight:NO];
                bindBtn.origin = (CGPoint){cell.width-bindBtn.width-RIGHT_PADDING*2,(ROW_HEIGHT-ConfBtn.height)/2};
                [cell.contentView addSubview:bindBtn];
            }
            
        }
        if ([text isEqualToString:@"设备参数"]) {
            [cell configMainTableViewCellStyleWithText:text andDetailText:nil cellSize:(CGSize){SCREEN_WIDTH,ROW_HEIGHT} disclosureIndicator:YES selectHighlight:YES];
        }
        if (indexPath.row==0) {
            [cell.contentView addSubview:[UIView initCellLineViewWithFrame:(CGRect){0,0,SCREEN_WIDTH,CELL_SPERITX_HEIGHT}]];
        }
        [cell.contentView addSubview:[UIView initCellLineViewWithFrame:(CGRect){0,ROW_HEIGHT-CELL_SPERITX_HEIGHT,SCREEN_WIDTH,CELL_SPERITX_HEIGHT}]];;
    }
    if (indexPath.row==0) {
        cell.isNeedTopSeprator = YES;
    }
    return cell;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
//    if (buttonIndex==1) {
//        if (alertView.tag==1000) {
//            UserEntity *entity = [UserDefaultsUtils customerObjectWithKey:USER_ENTITY];
//            [DeviceManageHandler reStartDeviceWithDeviceId:_deviceModel.deviceId taskCreateId:entity.accountId taskCreator:entity.accountId Success:^(id obj) {
//                if ([obj isKindOfClass:[NSDictionary class]]) {
//                    [AppUtils dismissHUD];
//                    [self loadData];
//                }else{
//                    [AppUtils showErrorMessage:obj];
//                    
//                }
//            } Failed:^(id obj) {
//                [AppUtils showErrorMessage:TEXT_SERVER_NOT_RESPOND];
//            }];
//
//        
//        }else if (alertView.tag==2000)
//        {
//            UserEntity *entity = [UserDefaultsUtils customerObjectWithKey:USER_ENTITY];
//            [DeviceManageHandler deleteDeviceNetworkWithDeviceId:_deviceModel.deviceId taskCreateId:entity.accountId taskCreator:entity.accountId Success:^(id obj) {
//                if ([obj isKindOfClass:[NSDictionary class]]) {
//                    [AppUtils dismissHUD];
//                    [AppUtils showAlertMessage:@"删除设备网络成功!稍后设备绿灯会快闪"];
//                    [self loadData];
//                    
//                }else{
//                    [AppUtils showErrorMessage:obj];
//                }
//            } Failed:^(id obj) {
//                [AppUtils showErrorMessage:TEXT_SERVER_NOT_RESPOND];
//            }];
//        }
//        
//    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        NSString *text = configArray[indexPath.row];
        if ([text isEqualToString:@"设备参数"]) {
            DeviceParameterViewController *devicePara = [[DeviceParameterViewController alloc] init];
            devicePara.deviceModel = _deviceModel;
            [self.navigationController safetyPushViewController:devicePara animated:YES];
        }
    }
}

#pragma RefreshCallback
-(void)updateDeviceMsg:(id)callback{
//    [_delegate updateDeviceMsg:nil];
    [self loadData];
}

-(void)bindGateComplete:(NSNotification *)notify{
    [self loadData];
}

-(void)bindShop:(UIButton *)sender{
    
//    ShopListViewController *shopListViewController = [[ShopListViewController alloc] initWithType:ShopListUseForDeviceDetailBindDevice];
//    shopListViewController.title = @"选择店铺";
//    shopListViewController.deviceModel = _deviceModel;
//    [self.navigationController safetyPushViewController:shopListViewController animated:YES];
}

-(void)confNet:(UIButton*)sender
{
//    if ([UserDefaultsUtils boolValueWithKey:IDENTITY] == YES){
//        [AppUtils showInfoMessage:@"当前是演示账号不能做提交操作"];
//        return;
//    }
//    MNGSearchDeviceForConfigNetViewController *searchDeviceVC = [[MNGSearchDeviceForConfigNetViewController alloc]initWithEnterWay:DeviceConfigEnteryFromDeviceDetail];
//    searchDeviceVC.deviceModel = _deviceModel;
//    [self.navigationController safetyPushViewController:searchDeviceVC animated:YES];

    
}

- (void)reTurnOnDevice:(UIButton *)sender{
//    if ([UserDefaultsUtils boolValueWithKey:IDENTITY] == YES){
//        [AppUtils showInfoMessage:@"当前是演示账号不能做提交操作"];
//        return;
//    }
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"设备重启需要1-2分钟，确定重启设备?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alert.tag = 1000;
//    [alert show];
    
}

- (void)deleteNetConfig:(UIButton *)sender{
//    if ([UserDefaultsUtils boolValueWithKey:IDENTITY] == YES){
//        [AppUtils showInfoMessage:@"当前是演示账号不能做提交操作"];
//        return;
//    }
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"确定删除设备的网络配置?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alert.tag = 2000;
//    [alert show];
    
}

@end
