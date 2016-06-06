#import "MNGDeviceNetConfigViewController.h"
#include "voiceRecog.h"
#import "HomeDeviceManagerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "HomeHttpHandler.h"
#import "AFNetworkReachabilityManager.h"
#import "HomeStringKeyContentValueManager.h"
#import "HomeResourceManager.h"
#import "DeviceDetailViewController.h"
static int  baseFrenqueceInConfig = 4000;
//根据错误编号，获得错误信息，该函数不是必需的
const char *recorderRecogErrorMsg(int _recogStatus)
{
	char *r = (char *)"unknow error";
	switch(_recogStatus)
	{
        case VD_ECCError:
            r = (char *)"ecc error";
            break;
        case VD_NotEnoughSignal:
            r = (char *)"not enough signal";
            break;
        case VD_NotHeaderOrTail:
            r = (char *)"signal no header or tail";
            break;
        case VD_RecogCountZero:
            r = (char *)"trial has expires, please try again";
            break;
	}
	return r;
}

//重载VoiceDecoder，主要是实现onRecognizerStart，onRecognizerEnd
@interface MyVoiceRecog : VoiceRecog
{
    MNGDeviceNetConfigViewController *ui;
}

- (id)init:(MNGDeviceNetConfigViewController *)_ui vdpriority:(VDPriority)_vdpriority;
@end

@implementation MyVoiceRecog

- (id)init:(MNGDeviceNetConfigViewController *)_ui vdpriority:(VDPriority)_vdpriority
{
    id r = [super init:_vdpriority];
    if (r != nil) {
        ui = _ui;
    }
    return r;
}

- (void) onRecognizerStart
{
    [ui onRecognizerStart];
}

- (void) onRecognizerEnd:(int)_result data:(char *)_data dataLen:(int)_dataLen
{
    [ui onRecognizerEnd:_result data:_data dataLen:_dataLen];
}

@end
@interface MNGDeviceNetConfigViewController ()<UIAlertViewDelegate>
{
    UIScrollView *scorllView;
    NSTimer *globalTimer;//整个配置过程计时器
    NSTimer *checkOnline;//轮询是否上线
    
    NSInteger checkTotalTime;//轮询总共耗时
    NSTimer *allConsumeTimer;//所有的过程的timer;

    
    NSMutableArray *messageArr;//发送的内容部分
    NSString *deviceSN;//设备序列号后六位
    NSString *currentSSID;//设备ssid
    BOOL isStaticNet;//静态网络.这种情况需要输入ip,掩码,网关,dns
    
    BOOL isSendNextMessage;//收到成功回应则发送下一条命令
    BOOL isNextLoop;//是否下一次配置
    NSInteger   index;//当前发送的下标
    
    UILabel *networkReachableWayLab;//网络连接方式
    UIView *backV;//半个背景区域;
    
    UIView *ipChoiceV;
    UIButton *dhcpBtn;//dhcp类型标识
    UIButton *staticBtn;//静态类型标识
    UIView *staticInputView;//静态ip配置时需要输入的部分;
    UIButton *confirmConfigBtn;//提交配置button
    
    MRJTextField *passTextField;//wifi密码
    MRJTextField *ipAddressTextField;//ip地址
    MRJTextField *subMarkTextField;//子网掩码
    MRJTextField *gateWayTextField;//网关地址
    MRJTextField *DNSTextField;//域名服务器地址
    
    
    UIView *holdView;//进度背景
    UILabel *proccessLab;//进度数字
    UILabel *processNotiLab;//进度提示
    UILabel *notificationLab;//当前进行的步骤
    UIView *processBar;//进度读条
    BOOL isCanAssignTask;//是否可以安排下一个任务
    CGFloat totalTimer;
//    UserEntity *user;
    
    NSMutableString *configLogStr;

    
    MRJContainerView *configNetTypeContainer;//网络类型选择背景;

//    UserEntity *entity;//操作者
    
    UIButton *confgiNetWorkTypeLanBtn;//有线或者wifi;
    UIButton *typeLanBtn;
    
    UIButton *confgiNetWorkTypeWifiBtn;//wifi类型;
    UIButton *typeWifiBtn;
    CGFloat totalHight;//
    UIView *wifiInputV;//wifi密码输入框以及wifissid所在V
    UIView *ipSetttingV;//ip选择V
    UIButton *dhcpLab;
    UIButton *staticLab;
    UIButton *dhcpFlagBtn;
    UIButton *staticFlagBtn;
    
}

@end


@implementation MNGDeviceNetConfigViewController

int freqs[] = {15000,15200,15400,15600,15800,16000,16200,16400,16600,16800,17000,17200,17400,17600,17800,18000,18200,18400,18600};
-(void)backToLast:(UIBarButtonItem*)item
{
    [player stop];
    if ([player isStopped]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (alertView.tag==100)//空密码配置
    {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        if (buttonIndex==1) {
            holdView.hidden = NO;
            notificationLab.text = language_homeDeviceConfigConfigProcessSendParamsNoticeString;
            [self startConfig];
        }
    }else if (alertView.tag==200)//成功配置后返回
    {
        [self popToEnterPlace:@"back"];
    }else if(alertView.tag==300)//成功配置后绑定店铺
    {
    }else if (alertView.tag==600)
    {
        [self popToEnterPlace:@"back"];
    }
    else
    {
        if (![player isStopped]) {
            [player stop];
            [self dealLogic];
            return;
        }
    }
}
-(void)popToEnterPlace:(NSString*)way
{
    if (self.enterWay==DeviceConfigEnteryFromDeviceDetail) {
        for (UIViewController *vc  in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[DeviceDetailViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }else if (self.enterWay==DeviceConfigEnteryFromDeviceList) {
        for (UIViewController *vc  in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[HomeDeviceManagerViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
}
#pragma mark --viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:[StringKeyContentValueManager languageValueForKey:language_commen_confirmBtnName] style:UIBarButtonItemStylePlain target:self action:@selector(beginConfig:)];
    [item setTintColor:[MRJColorManager mrj_navigationTextColor]];
    
    self.navigationItem.rightBarButtonItem = item;
    totalHight = TOP_PADDING;//默认的高度
    isCanAssignTask = YES;
    messageArr = [NSMutableArray array];
    self.title = [HomeStringKeyContentValueManager homeLanguageValueForKey:language_homeDeviceConfigTitle];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(-20, 20,60, 40)];
    [btn setImage:[HomeResourceManager home_configNetBackIcon] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 45)];
    
    [btn addTarget:self action:@selector(backToLast:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(calculateSubMarkGateWay:) name:UITextFieldTextDidEndEditingNotification object:nil];
    
    self.backScrollView.backgroundColor = [MRJColorManager mrj_mainBackgroundColor];
    //1:网络类型;
    if (_deviceModel.hardModel==DeviceHardModelM1Plus)//需要有线的情况
    {
        [self createNetTypeChoiceV];
    }
    [self createIPSettingV];
    [self createHoldV];
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            currentSSID = nil;
            NSString *orginStr=[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceConfigNoWIFINoticeText];
            if (status==AFNetworkReachabilityStatusReachableViaWiFi) {
                [self fetchSSIDInfo];
                if (currentSSID) {
                    orginStr = [NSString stringWithFormat:@"%@ %@",[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceConfigCurrentWifi],currentSSID];
                    ipSetttingV.hidden = NO;
                    passTextField.hidden = NO;
                }else
                {
                    ipSetttingV.hidden = YES;
                    passTextField.hidden = YES;
                    staticInputView.hidden = YES;
                }
                
            }else
            {
                ipSetttingV.hidden = YES;
                passTextField.hidden = YES;
                staticInputView.hidden = YES;
            }
            networkReachableWayLab.text = orginStr;
            [networkReachableWayLab setNeedsLayout];
        }];
    
    [manager startMonitoring];
    AVAudioSession *mySession = [AVAudioSession sharedInstance];
    [mySession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];

    
    int base = baseFrenqueceInConfig;
    for (int i = 0; i < sizeof(freqs)/sizeof(int); i ++) {
        freqs[i] = base + i * 200;
    }
    
    recog = [[MyVoiceRecog alloc] init:self vdpriority:VD_MemoryUsePriority];
    [recog setFreqs:freqs freqCount:sizeof(freqs)/sizeof(int)];
    
    player=[[VoicePlayer alloc] init];
    [player setFreqs:freqs freqCount:sizeof(freqs)/sizeof(int)];
    [player setVolume:1];
    [player setPlayerType:VE_SoundPlayer];
    


//    
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (version>=7)
    {
        [mySession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    }    
    [mySession setActive:YES error:nil];
    
    NSString *sn = _deviceModel.imei;
    if (sn.length>6) {
        deviceSN = [sn substringFromIndex:sn.length-6];
    }
//
}
#pragma mark --createNetTypeCHoiceV
-(void)createNetTypeChoiceV
{
    configNetTypeContainer = [[MRJContainerView alloc]init];//整個選擇網絡配置類型的容器
    
    [self.backScrollView addSubview:configNetTypeContainer];
    [configNetTypeContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(configNetTypeContainer.superview).offset(10);
        make.left.equalTo(configNetTypeContainer.superview.mas_left);
        make.centerX.equalTo(configNetTypeContainer.superview.mas_centerX);
    }];
    //wang
    MRJContainerView *netTypeTitleButtomV = [[MRJContainerView alloc]init];//配置网络标题背景
    netTypeTitleButtomV.backgroundColor = [MRJColorManager mrj_mainBackgroundColor];
    [configNetTypeContainer addSubview:netTypeTitleButtomV];
    [netTypeTitleButtomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(netTypeTitleButtomV.superview).offset(0);
        make.height.mas_equalTo(TableHeadHeight);
        make.width.equalTo(netTypeTitleButtomV.superview.mas_width);
        make.left.mas_equalTo(netTypeTitleButtomV.superview).offset(0);
        make.centerX.mas_equalTo(netTypeTitleButtomV.superview.mas_centerX);
    }];
    UILabel *netTypeLabel = [[UILabel alloc]init];
    netTypeLabel.font = [MRJSizeManager mrjMiddleTextFont];
    netTypeLabel.text = [HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceConfigNetTypeTitle];
    netTypeLabel.textColor = [MRJColorManager mrj_secondaryTextColor];
    [netTypeTitleButtomV addSubview:netTypeLabel];
    [netTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(netTypeLabel.superview.left).offset(LEFT_PADDING);
        make.centerY.mas_equalTo(netTypeLabel.superview.mas_centerY);
    }];
    UIView *netTypeBtnBttomV = [[UIView alloc]init];//选择网络几个按钮背景
    netTypeBtnBttomV.backgroundColor = NavigationTextColor;
    [configNetTypeContainer addSubview:netTypeBtnBttomV];
    [netTypeBtnBttomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(netTypeBtnBttomV.superview.left);
        make.height.mas_equalTo(INPUT_HEIGHT);
        make.width.mas_equalTo(netTypeBtnBttomV.superview.mas_width);
        make.top.mas_equalTo(netTypeTitleButtomV.mas_bottom);
        make.bottom.mas_equalTo(configNetTypeContainer.mas_bottom).offset(0);
    }];
    for (int x=0; x<4; x++) {
        UIButton *btn = [[UIButton alloc]init];
        [btn addTarget:self action:@selector(choiceNetType:) forControlEvents:UIControlEventTouchUpInside];
        if (x==0) {
            
            [btn setImage:[HomeResourceManager home_configNetUnSelectedBtnImage] forState:UIControlStateNormal];
            [btn setImage:[HomeResourceManager home_configNetSelectedBtnImage] forState:UIControlStateSelected];
            typeWifiBtn = btn;
            btn.selected = YES;
        }else if(x==1)
        {
            [btn setTitle:[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceConfigWifiBtnName] forState:UIControlStateNormal];
            [btn setTitleColor:[MRJColorManager mrj_secondaryTextColor] forState:UIControlStateNormal];
            [btn setTitleColor:[MRJColorManager mrj_mainTextColor] forState:UIControlStateSelected];
            confgiNetWorkTypeWifiBtn = btn;
            btn.selected = YES;
        }else if (x==2)
        {
            [btn setImage:[HomeResourceManager home_configNetUnSelectedBtnImage] forState:UIControlStateNormal];
            [btn setImage:[HomeResourceManager home_configNetSelectedBtnImage] forState:UIControlStateSelected];
            typeLanBtn = btn;
        }else
        {
            [btn setTitle:[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceConfigLANBtnName] forState:UIControlStateNormal];
            [btn setTitleColor:[MRJColorManager mrj_secondaryTextColor] forState:UIControlStateNormal];
            [btn setTitleColor:[MRJColorManager mrj_mainTextColor] forState:UIControlStateSelected];
            
            confgiNetWorkTypeLanBtn = btn;
        }
        
        [netTypeBtnBttomV addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(netTypeBtnBttomV.mas_centerY);
            if (x==0) {
                make.left.mas_equalTo(btn.superview.mas_left).offset(LEFT_PADDING);
            }else if (x==1)
            {
                make.left.mas_equalTo(typeWifiBtn.mas_right).offset([MRJSizeManager mrjHorizonSpace]);
            }else if (x==2)
            {
                make.left.mas_equalTo(btn.superview.mas_centerX).offset(LEFT_PADDING);
            }else
            {
                make.left.mas_equalTo(typeLanBtn.mas_right).offset([MRJSizeManager mrjHorizonSpace]);
            }
        }];
        
    }
}
#pragma mark --createIPSettingV
-(void)createIPSettingV
{
    wifiInputV = [[UIView alloc]init];
    wifiInputV.backgroundColor = [MRJColorManager mrj_mainBackgroundColor];
    [self.backScrollView addSubview:wifiInputV];
    [wifiInputV mas_makeConstraints:^(MASConstraintMaker *make) {
        if (configNetTypeContainer) {
            make.top.mas_equalTo(configNetTypeContainer.mas_bottom).offset(0);
        }
        else
        {
            make.top.mas_equalTo(wifiInputV.superview).offset(0);
        }
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.centerX.mas_equalTo(wifiInputV.superview.mas_centerX);
    }];
    
    networkReachableWayLab = [[UILabel alloc]init];
    networkReachableWayLab.text = @"";
    networkReachableWayLab.numberOfLines = 0;
    networkReachableWayLab.preferredMaxLayoutWidth = SCREEN_WIDTH-LEFT_PADDING*2;
    networkReachableWayLab.lineBreakMode = NSLineBreakByWordWrapping;
    networkReachableWayLab.textAlignment = NSTextAlignmentCenter;
    networkReachableWayLab.textColor = [MRJColorManager mrj_mainTextColor];
    [wifiInputV addSubview:networkReachableWayLab];
    [networkReachableWayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(networkReachableWayLab.superview.mas_centerX);
        make.top.mas_equalTo([MRJSizeManager mrjHorizonSpace]);
    }];
    
    passTextField = [[MRJTextField alloc]init];
    passTextField.placeholder = [HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceConfigWifiPassPlacement];
    
    
    [wifiInputV addSubview:passTextField];
    [passTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(networkReachableWayLab.mas_bottom).offset([MRJSizeManager mrjVerticalSpace]);
        make.left.mas_equalTo(passTextField.superview).offset(LEFT_PADDING);
        make.right.mas_equalTo(passTextField.superview).offset(-LEFT_PADDING);
        make.height.mas_equalTo(INPUT_HEIGHT);
        make.bottom.mas_equalTo(passTextField.superview.mas_bottom);
    }];
    
    
    ipSetttingV  = [[UIView alloc]init];
    [self.backScrollView addSubview:ipSetttingV];
    [ipSetttingV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wifiInputV.mas_bottom).offset(TOP_PADDING);
        make.left.mas_equalTo(ipSetttingV.superview);
        make.right.mas_equalTo(ipSetttingV.superview);
        make.centerX.mas_equalTo(ipSetttingV.superview.mas_centerX);
    }];
    UILabel *ipsettingTitle = [[UILabel alloc]init];
    ipsettingTitle.text = [HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceConfigIpTitle];
    ipsettingTitle.font = MiddleTextFont;
    ipsettingTitle.textColor = SecondaryTextColor;
    [ipSetttingV addSubview:ipsettingTitle];
    [ipsettingTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ipsettingTitle.superview).offset(LEFT_PADDING);
        make.top.mas_equalTo(ipsettingTitle.superview).offset([MRJSizeManager mrjVerticalSpace]);
    }];
    UIView *ipSettingBtnsButtomV = [[UIView alloc]init];
    ipSettingBtnsButtomV.backgroundColor = NavigationTextColor;
    [ipSetttingV addSubview:ipSettingBtnsButtomV];
    [ipSettingBtnsButtomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ipsettingTitle.mas_bottom).offset([MRJSizeManager mrjVerticalSpace]);
        make.left.mas_equalTo(ipSettingBtnsButtomV.superview.mas_left);
        make.right.mas_equalTo(ipSettingBtnsButtomV.superview.mas_right);
        make.height.mas_equalTo(INPUT_HEIGHT);
        make.bottom.mas_equalTo(ipSetttingV.mas_bottom);
    }];
    
    for (int x=0; x<4; x++) {
        UIButton *btn = [[UIButton alloc]init];
        [btn addTarget:self action:@selector(choiceIpType:) forControlEvents:UIControlEventTouchUpInside];
        if (x==0) {
            [btn setImage:[HomeResourceManager home_configNetUnSelectedBtnImage] forState:UIControlStateNormal];
            [btn setImage:[HomeResourceManager home_configNetSelectedBtnImage] forState:UIControlStateSelected];
            dhcpBtn = btn;
            btn.selected = YES;
        }else if(x==1)
        {
            [btn setTitle:[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceConfigDHCPBtnName]forState:UIControlStateNormal];
            [btn setTitleColor:[MRJColorManager mrj_secondaryTextColor] forState:UIControlStateNormal];
            [btn setTitleColor:[MRJColorManager mrj_mainTextColor] forState:UIControlStateSelected];
            dhcpLab = btn;
            btn.selected = YES;
        }else if (x==2)
        {
            [btn setImage:[HomeResourceManager home_configNetUnSelectedBtnImage] forState:UIControlStateNormal];
            [btn setImage:[HomeResourceManager home_configNetSelectedBtnImage] forState:UIControlStateSelected];
            staticBtn = btn;
        }else
        {
            [btn setTitle:[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceConfigStaticBtnName] forState:UIControlStateNormal];
            [btn setTitleColor:[MRJColorManager mrj_secondaryTextColor] forState:UIControlStateNormal];
            [btn setTitleColor:[MRJColorManager mrj_mainTextColor] forState:UIControlStateSelected];
            
            staticLab = btn;
        }
        
        [ipSettingBtnsButtomV addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(btn.superview.mas_centerY);
            if (x==0) {
                make.left.mas_equalTo(btn.superview.mas_left).offset(LEFT_PADDING);
            }else if (x==1)
            {
                make.left.mas_equalTo(dhcpBtn.mas_right).offset([MRJSizeManager mrjHorizonSpace]);
            }else if (x==2)
            {
                make.left.mas_equalTo(btn.superview.mas_centerX).offset(LEFT_PADDING);
            }else
            {
                make.left.mas_equalTo(staticBtn.mas_right).offset([MRJSizeManager mrjHorizonSpace]);
            }
        }];
    }
    staticInputView = [[UIView alloc]init];
    staticInputView.backgroundColor = NavigationTextColor;
    [self.backScrollView addSubview:staticInputView];
    [staticInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ipSetttingV.mas_bottom);
        make.height.mas_equalTo(INPUT_HEIGHT*4+TOP_PADDING);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.centerX.mas_equalTo(staticInputView.superview.mas_centerX);
    }];
    UIView *topSepratorLine = [[UIView alloc]init];
    topSepratorLine.backgroundColor = [MRJColorManager mrj_separatrixColor];
    [staticInputView addSubview:topSepratorLine];
    [topSepratorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo([MRJSizeManager mrjSepritorHeight]);
        make.left.mas_equalTo(0);
        make.centerX.mas_equalTo(topSepratorLine.superview.mas_centerX);
    }];
    
    
    
    
    NSArray *inputItemsArr = @[[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceConfigIpAddressPlacement],
                               [HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceConfigSubMarkPlacement],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceConfigGateWayPlacement],[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceConfigDNSPlacement]];
    for (int x=0; x<inputItemsArr.count; x++) {
        MRJTextField *textFiled = [[MRJTextField alloc]init];
        textFiled.keyboardType = UIKeyboardTypeDecimalPad;
        textFiled.placeholder = [NSString stringWithFormat:@"%@",inputItemsArr[x]];
        if (x==0) {
            textFiled.text = [AppSingleton shareInstace].wifiStatiConfigIP;
            ipAddressTextField = textFiled;
        }else if (x==1)
        {
            textFiled.text = [AppSingleton shareInstace].wifiStatiConfiMask;
            subMarkTextField = textFiled;
            
        }else if (x==2)
        {
            textFiled.text = [AppSingleton shareInstace].wifiStatiConfigGateWay;
            gateWayTextField = textFiled;
        }else if (x==3)
        {
            textFiled.text = [AppSingleton shareInstace].wifiStatiConfigDNS;
            DNSTextField = textFiled;
        }
        [staticInputView addSubview:textFiled];
        [textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(INPUT_HEIGHT);
            make.left.mas_equalTo(textFiled.superview.mas_left).offset(LEFT_PADDING);
            make.top.mas_equalTo(x*INPUT_HEIGHT);
            make.right.mas_equalTo(textFiled.superview.mas_right).offset(-LEFT_PADDING);
        }];
    }
    staticInputView.hidden = YES;
}
-(void)createHoldV
{
    holdView = [[UIView alloc]init];
    [self.view addSubview:holdView];
    holdView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [holdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    UIView *processView = [[UIView alloc]init];
    processView.layer.cornerRadius = 5;
    processView.clipsToBounds = YES;
    processView.backgroundColor = NavigationTextColor;
    [holdView addSubview:processView];
    [processView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(holdView);
        make.left.mas_equalTo(holdView).offset(LEFT_PADDING);
        make.right.mas_equalTo(holdView).offset(-LEFT_PADDING);
    }];
    
    
    processNotiLab = [[UILabel alloc]init];
    processNotiLab.text = language_commen_noticeStrig;
    processNotiLab.font = [MRJSizeManager mrjNavigationFont];
    processNotiLab.textColor = [MRJColorManager mrj_mainThemeColor];
    [processView addSubview:processNotiLab];
    
    [processNotiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(processNotiLab.superview).offset(LEFT_PADDING);
        make.right.mas_equalTo(processNotiLab.superview).offset(-LEFT_PADDING);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];

    UIView *sepLineV = [[UIView alloc]init];
    sepLineV.backgroundColor = [MRJColorManager mrj_mainThemeColor];
    [processView addSubview:sepLineV];
    [sepLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sepLineV.superview).offset(LEFT_PADDING);
        make.right.mas_equalTo(sepLineV.superview).offset(-LEFT_PADDING);
        make.top.mas_equalTo(processNotiLab.mas_bottom);
        make.height.mas_equalTo(3);
    }];
    
    UIView *buttomV = [[UIView alloc]init];
    buttomV.backgroundColor = [MRJColorManager mrj_navigationTextColor];
    [processView addSubview:buttomV];
    [buttomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sepLineV.mas_bottom).offset(3);
        make.bottom.mas_equalTo(buttomV.superview);
        make.left.mas_equalTo(buttomV.superview);
        make.right.mas_equalTo(buttomV.superview);
    }];
//
    
    notificationLab = [[UILabel alloc]init];
    notificationLab.text = language_homeDeviceConfigConfigProcessSendParamsNoticeString;
    notificationLab.numberOfLines = 0;
    notificationLab.lineBreakMode = NSLineBreakByWordWrapping;
    [buttomV addSubview:notificationLab];
    [notificationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(notificationLab.superview);
        make.left.mas_equalTo(notificationLab.superview).offset(LEFT_PADDING);
        make.right.mas_equalTo(notificationLab.superview).offset(-LEFT_PADDING);
    }];
    
//
    UIView *processBarBgV = [[UIView alloc]init];
    processBarBgV.layer.cornerRadius = 2;
    [buttomV addSubview:processBarBgV];
    [processBarBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(notificationLab.mas_bottom).offset(3);
        make.left.mas_equalTo(processBarBgV.superview).offset(LEFT_PADDING);
        make.right.mas_equalTo(processBarBgV.superview).offset(-LEFT_PADDING);
        make.height.mas_equalTo(20);
    }];
    
    processBarBgV.backgroundColor  = [UIColor grayColor];
    processBar = [[UIView alloc]init];
    processBar.backgroundColor = [MRJColorManager mrj_mainThemeColor];
    [buttomV addSubview:processBar];
    [processBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(processBarBgV);
        make.left.mas_equalTo(processBarBgV);
        make.width.mas_equalTo(1);
        make.bottom.mas_equalTo(processBarBgV);
    }];
//
    proccessLab = [[UILabel alloc]initWithFrame:CGRectMake(0, buttomV.height-30, processView.width, 30)];
    proccessLab.textAlignment = NSTextAlignmentCenter;
    proccessLab.text = @"0%";
    [buttomV addSubview:proccessLab];
    [proccessLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(processBarBgV.mas_bottom).offset(4);
        make.left.mas_equalTo(proccessLab.superview).offset(LEFT_PADDING);
        make.right.mas_equalTo(proccessLab.superview).offset(-LEFT_PADDING);
        make.bottom.mas_equalTo(processView.mas_bottom).offset(-4);
    }];
    holdView.hidden = YES;
}
- (void)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id result = nil;
    for (NSString *ifnam in ifs)
    {
        result = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (result && [result count])
        {
            break;
        }
    }
    NSString *ssid,*macAddress;
    NSData *data = data;
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary*)result;
        ssid = dict[((__bridge NSString*)kCNNetworkInfoKeySSID)];
        CFRelease(kCNNetworkInfoKeySSID);
        macAddress = dict[((__bridge NSString*)kCNNetworkInfoKeyBSSID)];
        CFRelease(kCNNetworkInfoKeyBSSID);
        data = dict[((__bridge NSString*)kCNNetworkInfoKeySSIDData)];
        CFRelease(kCNNetworkInfoKeySSIDData);
    };
    currentSSID = ssid;

}
-(void)calculateSubMarkGateWay:(NSNotification*)note
{
    if (note.object==ipAddressTextField) {
        if (subMarkTextField.text.length==0) {
            if ([MRJAppUtils isValidatIP:ipAddressTextField.text]) {
                subMarkTextField.text = @"255.255.255.0";
                NSString *ip = ipAddressTextField.text;
                NSMutableString *reverIp = [[NSMutableString alloc]init];//反转后的ip地址
                for (NSInteger x=ip.length-1; x>=0; x--) {
                    [reverIp appendString:[ip substringWithRange:NSMakeRange(x, 1)]];
                }
                NSRange rang = [reverIp rangeOfString:@"."];
                NSString *str = [reverIp substringFromIndex:rang.location+rang.length];
                NSString *reverGateIp = [NSString stringWithFormat:@"1.%@",str];
                NSMutableString *gateIp = [[NSMutableString alloc]init];
                for (NSInteger x=reverGateIp.length-1; x>=0; x--) {
                    [gateIp appendString:[reverGateIp substringWithRange:NSMakeRange(x, 1)]];
                }
                
                gateWayTextField.text = gateIp;
            }
        }
    }
}
#pragma mark -- choice netType
-(void)choiceNetType:(UIButton*)btn
{
    confgiNetWorkTypeWifiBtn.selected = !confgiNetWorkTypeWifiBtn.selected;
    confgiNetWorkTypeLanBtn.selected  = !confgiNetWorkTypeLanBtn.selected;
    typeWifiBtn.selected = !typeWifiBtn.selected;
    typeLanBtn.selected = !typeLanBtn.selected;
    
    staticBtn.selected = NO;
    staticLab.selected = NO;
    dhcpBtn.selected = YES;
    dhcpLab.selected = YES;
    staticInputView.hidden  = YES;
    if (typeLanBtn.selected==YES) {
        wifiInputV.hidden = YES;
        ipSetttingV.hidden = NO;
        [ipSetttingV mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (configNetTypeContainer) {
                make.top.mas_equalTo(configNetTypeContainer.mas_bottom).offset(0);
            }
            else
            {
                make.top.mas_equalTo(ipSetttingV.superview).offset(0);
            }
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.centerX.mas_equalTo(ipSetttingV.superview.mas_centerX);
        }];
    }else
    {
        
        wifiInputV.hidden = NO;
        [wifiInputV mas_updateConstraints:^(MASConstraintMaker *make) {
            if (configNetTypeContainer) {
                make.top.mas_equalTo(configNetTypeContainer.mas_bottom).offset(0);
            }
            else
            {
                make.top.mas_equalTo(wifiInputV.superview).offset(0);
            }
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.centerX.mas_equalTo(wifiInputV.superview.mas_centerX);
        }];
        [ipSetttingV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(wifiInputV.mas_bottom).offset(TOP_PADDING);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.centerX.mas_equalTo(ipSetttingV.superview.mas_centerX);
        }];
    } 
    
}
#pragma mark --beginCofig
-(void)beginConfig:(UIButton*)btn
{
    [self.view endEditing:YES];
    
    //支持有线的情况下;
    if (configNetTypeContainer) {
        if (confgiNetWorkTypeWifiBtn.selected==YES)//wifi配置
        {
            if (![self isCheckSSIDOk])//检查ssid合法性
            {
                return;
            }
        }
        NSDictionary *dictStep1;
        if(staticBtn.selected==YES)//是静态网络
        {
            if (![self isCheckStaticConfigInputOk])//检查静态配置输入合法性
            {
                return;
            }
            [[NSUserDefaults standardUserDefaults]synchronize];
            if(confgiNetWorkTypeWifiBtn.selected==YES)//无线 静态ip
            {
                dictStep1  = @{@"cmd":@"2",@"snNumber":deviceSN,@"content":@"10"};//网络类型/ios/无线静态ip
            }else //有线 静态
            {
                dictStep1  = @{@"cmd":@"2",@"snNumber":deviceSN,@"content":@"12"};//网络类型,ios/有线静态ip
            }
            
            totalTimer =  300;
        }else
        {
            if(confgiNetWorkTypeWifiBtn.selected==YES)//无线dhcp
            {
                dictStep1  = @{@"cmd":@"2",@"snNumber":deviceSN,@"content":@"11"};//网络类型/ios/无线DHCP
            }else //有线 dhcp
            {
                dictStep1  = @{@"cmd":@"2",@"snNumber":deviceSN,@"content":@"13"};//网络类型,ios/
            }
            totalTimer =  180.f;
        }
        messageArr = [[NSMutableArray alloc]init];
        checkTotalTime = 0;
        index = 0;
        [messageArr addObject:dictStep1];
        //ssid和密码
        if (confgiNetWorkTypeWifiBtn.selected==YES) {
            NSDictionary *dictStep2 = @{@"cmd":@"0",@"snNumber":deviceSN,@"content":currentSSID};//ssid
            [messageArr addObject:dictStep2];
            if(currentSSID.length>7)
            {
                NSDictionary *dictStep2_more = @{@"cmd":@"0",@"snNumber":deviceSN,@"content":currentSSID};//ssid
                [messageArr addObject:dictStep2_more];
            }
            NSDictionary *dictStep3 = @{@"cmd":@"1",@"snNumber":deviceSN,@"content":[passTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]};//密码
            [messageArr addObject:dictStep3];
            if(passTextField.text.length>7)
            {
                NSDictionary *dictStep3_more = @{@"cmd":@"1",@"snNumber":deviceSN,@"content":[passTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]};//密码
                [messageArr addObject:dictStep3_more];
            }
        }
        
        //是否需要发送ip/gateway/mask/dns等
        if (staticBtn.selected==YES) {
            NSDictionary *ipDict = @{@"cmd":@"3",@"snNumber":deviceSN,@"content":ipAddressTextField.text};//ip地址
            [messageArr addObject:ipDict];
            
            NSDictionary *markDict = @{@"cmd":@"4",@"snNumber":deviceSN,@"content":subMarkTextField.text};//子网掩码
            [messageArr addObject:markDict];
            
            NSDictionary *gateDict = @{@"cmd":@"5",@"snNumber":deviceSN,@"content":gateWayTextField.text};//网关
            [messageArr addObject:gateDict];
            
            NSDictionary *dnsDict = @{@"cmd":@"6",@"snNumber":deviceSN,@"content":DNSTextField.text};//dns服务器地址
            [messageArr addObject:dnsDict];
        }
        NSDictionary *domainDict = @{@"cmd":@"a",@"snNumber":deviceSN,@"content":[NSString stringWithFormat:@"%@",_serverDomain?_serverDomain:_serverIp]};//授权域名
        [messageArr addObject:domainDict];
        NSDictionary *domainDict_more = @{@"cmd":@"a",@"snNumber":deviceSN,@"content":[NSString stringWithFormat:@"%@",_serverDomain?_serverDomain:_serverIp]};//长度可能过长,重复添加一条
        [messageArr addObject:domainDict_more];
        
        NSDictionary *endDict = @{@"cmd":@"8",@"snNumber":deviceSN,@"content":[NSString stringWithFormat:@"%@:%@",_serverIp,_serverPort]};//结束标识
        [messageArr addObject:endDict];
        NSDictionary *endDict_more = @{@"cmd":@"8",@"snNumber":deviceSN,@"content":[NSString stringWithFormat:@"%@:%@",_serverIp,_serverPort]};//结束标识
        [messageArr addObject:endDict_more];
        
        //加一倍
        for (int x=0; x<messageArr.count; x+=2) {
            NSDictionary *dict = [messageArr[x] mutableCopy];
            [messageArr insertObject:dict atIndex:x];
        }
        MRJUserModel *entity = [AppSingleton currentUser];
        configLogStr = [NSMutableString stringWithFormat:@"AccountEntity:AccountId=%@,username = %@,mobile = %@,email = %@;Device:deviceId = %@,imei = %@,imsi = %@,ssid = %@,softVersion = %@,deviceModel = %@ Client:mobileSystem = %@,mobileType = %@\n",entity.accountId,entity.userName,entity.mobile,entity.email,_deviceModel.deviceId,_deviceModel.imei,_deviceModel.imsi,currentSSID,_deviceModel.softVersion,_deviceModel.modeName,[UIDevice currentDevice].systemVersion,[UIDevice currentDevice].machineModelName];
        if (confgiNetWorkTypeWifiBtn.selected==YES)//配置的是无线
        {
            if(passTextField.text.length==0)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:language_homeDeviceConfigWIFIEmptyPasswordNotice delegate:self cancelButtonTitle:language_commen_cancelBtnName otherButtonTitles:language_commen_confirmBtnName, nil];
                alert.tag  = 100;
                [alert show];
                return;
            }
        }
        
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        [self.view.window addSubview:holdView];
        notificationLab.text = language_homeDeviceConfigConfigProcessSendParamsNoticeString;
    }
    else//只支持无线
    {
        if (![self isCheckSSIDOk])//检查ssid合法性
        {
            return;
        }
        
        NSDictionary *dictStep1;
        if(staticBtn.selected==YES)//是静态网络
        {
            if (![self isCheckStaticConfigInputOk])//检查静态配置输入合法性
            {
                return;
            }
            dictStep1  = @{@"cmd":@"2",@"snNumber":deviceSN,@"content":@"10"};//网络类型/ios/无线静态ip
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            totalTimer =  300;
        }else
        {
            dictStep1  = @{@"cmd":@"2",@"snNumber":deviceSN,@"content":@"11"};//网络类型/ios/无线DHCP
            totalTimer =  200.f;
        }
        messageArr = [[NSMutableArray alloc]init];
        checkTotalTime = 0;
        index = 0;
        [messageArr addObject:dictStep1];
        //ssid和密码
        NSDictionary *dictStep2 = @{@"cmd":@"0",@"snNumber":deviceSN,@"content":currentSSID};//ssid
        [messageArr addObject:dictStep2];
        if(currentSSID.length>7)
        {
            NSDictionary *dictStep2_more = @{@"cmd":@"0",@"snNumber":deviceSN,@"content":currentSSID};//ssid
            [messageArr addObject:dictStep2_more];
        }
        NSDictionary *dictStep3 = @{@"cmd":@"1",@"snNumber":deviceSN,@"content":[passTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]};//密码
        [messageArr addObject:dictStep3];
        if(passTextField.text.length>7)
        {
            NSDictionary *dictStep3_more = @{@"cmd":@"1",@"snNumber":deviceSN,@"content":passTextField.text};//密码
            [messageArr addObject:dictStep3_more];
        }
        
        //是否需要发送ip/gateway/mask/dns等
        if (staticBtn.selected==YES) {
            NSDictionary *ipDict = @{@"cmd":@"3",@"snNumber":deviceSN,@"content":ipAddressTextField.text};//ip地址
            [messageArr addObject:ipDict];
            
            NSDictionary *markDict = @{@"cmd":@"4",@"snNumber":deviceSN,@"content":subMarkTextField.text};//子网掩码
            [messageArr addObject:markDict];
            
            NSDictionary *gateDict = @{@"cmd":@"5",@"snNumber":deviceSN,@"content":gateWayTextField.text};//网关
            [messageArr addObject:gateDict];
            
            NSDictionary *dnsDict = @{@"cmd":@"6",@"snNumber":deviceSN,@"content":DNSTextField.text};//dns服务器地址
            [messageArr addObject:dnsDict];
        }
        
        NSDictionary *domainDict = @{@"cmd":@"a",@"snNumber":deviceSN,@"content":[NSString stringWithFormat:@"%@",_serverDomain?_serverDomain:_serverIp]};//授权域名
        [messageArr addObject:domainDict];
        NSDictionary *domainDict_more = @{@"cmd":@"a",@"snNumber":deviceSN,@"content":[NSString stringWithFormat:@"%@",_serverDomain?_serverDomain:_serverIp]};//长度可能过长,重复添加一条
        [messageArr addObject:domainDict_more];
        
        NSDictionary *endDict = @{@"cmd":@"8",@"snNumber":deviceSN,@"content":[NSString stringWithFormat:@"%@:%@",_serverIp,_serverPort]};//授权ip地址
        [messageArr addObject:endDict];
        NSDictionary *endDict_more = @{@"cmd":@"8",@"snNumber":deviceSN,@"content":[NSString stringWithFormat:@"%@:%@",_serverIp,_serverPort]};//
        [messageArr addObject:endDict_more];
        
        
        
        
        //加一倍
        for (int x=0; x<messageArr.count; x+=2) {
            NSDictionary *dict = [messageArr[x] mutableCopy];
            [messageArr insertObject:dict atIndex:x];
        }
        MRJUserModel *entity = [AppSingleton currentUser];
            configLogStr = [NSMutableString stringWithFormat:@"AccountEntity:AccountId=%@,username = %@,mobile = %@,email = %@;Device:deviceId = %@,imei = %@,imsi = %@,ssid = %@,softVersion = %@,deviceModel = %@ Client:mobileSystem = %@,mobileType = %@\n",entity.accountId,entity.userName,entity.mobile,entity.email,_deviceModel.deviceId,_deviceModel.imei,_deviceModel.imsi,currentSSID,_deviceModel.softVersion,_deviceModel.modeName,[UIDevice currentDevice].systemVersion,[UIDevice currentDevice].machineModelName];
        if(passTextField.text.length==0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:language_homeDeviceConfigWIFIEmptyPasswordNotice delegate:self cancelButtonTitle:language_commen_cancelBtnName otherButtonTitles:language_commen_confirmBtnName, nil];
            alert.tag  = 100;
            [alert show];
            return;
        }
        notificationLab.text = language_homeDeviceConfigConfigProcessSendParamsNoticeString;
    }
    [self startConfig];
    
    
}
-(void)startConfig
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    globalTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(globalSendMessage) userInfo:nil repeats:YES];
    [allConsumeTimer invalidate];
    allConsumeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeUI) userInfo:nil repeats:YES];
    [allConsumeTimer fire];
    holdView.hidden = NO;
    [holdView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.view.userInteractionEnabled = NO;
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    
}
#pragma mark --stopConfig
-(void)stopConfig
{
    [globalTimer invalidate];
    globalTimer = nil;
    [checkOnline invalidate];
    checkOnline = nil;
    [allConsumeTimer invalidate];
    allConsumeTimer = nil;
    checkTotalTime = 0;
    isCanAssignTask = YES;
    holdView.hidden = YES;
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    self.view.userInteractionEnabled = YES;
    self.navigationController.navigationBar.userInteractionEnabled = YES;
}
#pragma mark --check staticInput
-(BOOL)isCheckStaticConfigInputOk
{
    if (![MRJAppUtils isValidatIP:ipAddressTextField.text]) {
        [MRJAppUtils showErrorMessage:language_homeDeviceConfigIpAddressCheckNotice];
        return NO;
    }
    if (![MRJAppUtils isValidatIP:subMarkTextField.text]) {
        [MRJAppUtils showErrorMessage:language_homeDeviceConfigSubMarkCheckNotice];
        return NO;
    }
    if (![MRJAppUtils isValidatIP:gateWayTextField.text]) {
        [MRJAppUtils showErrorMessage:language_homeDeviceConfigNetGatewayCheckNotice];
        return NO;
    }
    if (![MRJAppUtils isValidatIP:DNSTextField.text]) {
        [MRJAppUtils showErrorMessage:language_homeDeviceConfigDNSAddressCheckNotice];
        return NO;
    }
    return YES;
}
#pragma mark --check ssid
-(BOOL)isCheckSSIDOk
{
    int x=0;
    for(int i=0; i< [currentSSID length];i++){
        int a = [currentSSID characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            x++;
        }
    }
    if (x>7) {
        [MRJAppUtils showAlertMessage:language_homeDeviceConfigWIFINameTooManyChineseChar];
        return NO;
    }
    NSRange range = [currentSSID rangeOfString:@"&"];
    if (range.length>0) {
        [MRJAppUtils showAlertMessage:language_homeDeviceConfigWIFINameContainSpecialCharNotice];
        return NO;
    }
    if ([currentSSID stringByReplacingOccurrencesOfString:@" " withString:@""].length<1) {
        [MRJAppUtils showErrorMessage:language_homeDeviceConfigNoWIFINoticeText];
        return NO;
    }
    return YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void) viewWillAppear:(BOOL)animated
{
    [recog start];
    [super viewWillAppear:animated];
}
#pragma mark --choice Ip type
-(void)choiceIpType:(UIButton*)btn
{
    dhcpLab.selected = !dhcpLab.selected;
    staticLab.selected = !staticLab.selected;
    dhcpBtn.selected  = !dhcpBtn.selected;
    staticBtn.selected = !staticBtn.selected;
    
    if (staticBtn.selected == YES) {
        staticInputView.hidden = NO;
    }else
    {
        staticInputView.hidden = YES;
    }
}
- (void) viewWillDisappear:(BOOL)animated
{
     [super viewWillDisappear:animated];
    [recog stop];
    [player stop];
    [self stopConfig];
    recog = nil;
    player = nil;
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)globalSendMessage
{
    if (![player isStopped])//如果有正在发送的消息,立即返回
    {
        return;
    }
    if(isCanAssignTask)//如果不能安排下一个预订任务,也返回
    {
        if(index==0)
        {
            NSDictionary *dict = messageArr[index];
            NSString *str = [self packageMessageWithCmd:dict[@"cmd"] deviceSN:deviceSN contentData:dict[@"content"]];
            if (str.length<1) {
                return;
            }
            NSString *cmdType = @"";
            
            switch ([dict[@"cmd"] integerValue]) {
                case 0:
                    if ([dict[@"cmd"] isEqualToString:@"a"]) {
                        cmdType = @"auth 域名命令";
                    }else
                    {
                        cmdType =@"Wi-Fi ssid";
                    }
                    break;
                case 1:
                    cmdType = @"Wi-Fi password";
                    break;
                case 2:
                {
                    NSInteger cmd = [[str substringFromIndex:str.length-1] integerValue];
                    switch (cmd) {
                        case 0:
                            cmdType = [NSString stringWithFormat:@"网络类型%@",@"无线静态"];
                            break;
                        case 1:
                             cmdType = [NSString stringWithFormat:@"网络类型%@",@"无线DHCP"];
                            break;
                        case 2:
                             cmdType = [NSString stringWithFormat:@"网络类型%@",@"有线静态"];
                            break;
                        case 3:
                             cmdType = [NSString stringWithFormat:@"网络类型%@",@"有线DHCP"];
                            break;
                        default:
                            break;
                    }
                }
                    break;
                case 3:
                    cmdType = @"IP 地址";
                    break;
                case 4:
                    cmdType = @"子网掩码";
                    break;
                case 5:
                    cmdType = @"网关地址";
                    break;
                case 6:
                    cmdType = @"DNS 服务器地址";
                    break;
                case 7:
                    cmdType = @"app 搜索命令";
                    break;
                case 8:
                    cmdType = @"auth ip端口登录命令";
                    break;
                default:
                    break;
            }
            [player playString:str playCount:1 muteInterval:0];
            NSString *log = [NSString stringWithFormat:@"第%ld秒发送第%ld条命令发送命令为%@,内容为%@",(long)checkTotalTime,(long)index+1,cmdType,str];
            NSLog(@"%@",log);
            [configLogStr appendString:[NSString stringWithFormat:@"%@\n",log]];
            isCanAssignTask = YES;
            index++;
            return;
        }
        isCanAssignTask = NO;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.1 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            if (index==messageArr.count)
            {
                notificationLab.text = language_homeDeviceConfigConfigProcessConfigingNet;
                index = 0;
                [checkOnline invalidate];
                checkOnline = nil;
                checkOnline = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(checkOnline) userInfo:nil repeats:YES];
                [checkOnline fire];
                return;
            }
            NSDictionary *dict = messageArr[index];
            NSString *str = [self packageMessageWithCmd:dict[@"cmd"] deviceSN:deviceSN contentData:dict[@"content"]];
            if (str.length<1) {
                return;
            }
            [player playString:str playCount:1 muteInterval:0];
            NSString *cmdType = @"";
            
            switch ([dict[@"cmd"] integerValue]) {
                case 0:
                    if ([dict[@"cmd"] isEqualToString:@"a"]) {
                        cmdType = @"auth 域名命令";
                    }else
                    {
                        cmdType =@"Wi-Fi ssid";
                    }
                    
                    break;
                case 1:
                    cmdType = @"Wi-Fi password";
                    break;
                case 2:
                {
                    NSInteger cmd = [[str substringFromIndex:str.length-1] integerValue];
                    switch (cmd) {
                        case 0:
                            cmdType = [NSString stringWithFormat:@"网络类型%@",@"无线静态"];
                            break;
                        case 1:
                            cmdType = [NSString stringWithFormat:@"网络类型%@",@"无线DHCP"];
                            break;
                        case 2:
                            cmdType = [NSString stringWithFormat:@"网络类型%@",@"有线静态"];
                            break;
                        case 3:
                            cmdType = [NSString stringWithFormat:@"网络类型%@",@"有线DHCP"];
                            break;
                        default:
                            break;
                    }
                }
                    break;
                case 3:
                    cmdType = @"IP 地址";
                    break;
                case 4:
                    cmdType = @"子网掩码";
                    break;
                case 5:
                    cmdType = @"网关地址";
                    break;
                case 6:
                    cmdType = @"DNS 服务器地址";
                    break;
                case 7:
                    cmdType = @"app 搜索命令";
                    break;
                case 8:
                    cmdType = @"auth 登录命令";
                    break;
                default:
                    
                    break;
            }
            NSString *log = [NSString stringWithFormat:@"第%ld秒发送第%ld条命令发送命令为%@,内容为%@",(long)checkTotalTime,(long)index+1,cmdType,str];
            [configLogStr appendString:[NSString stringWithFormat:@"%@\n",log]];
            NSLog(@"%@",log);
            ++index;
            isCanAssignTask = YES;
        });
    }
    
}
-(void)sendMessage
{

    
    
}
-(void)changeUI
{
    checkTotalTime++;
    processBar.width = (checkTotalTime/totalTimer)*processNotiLab.width>=processNotiLab.width?processNotiLab.width:(checkTotalTime/totalTimer)*processNotiLab.width;
    proccessLab.text = [NSString stringWithFormat:@"%d %%",(int)(((float)checkTotalTime/(float)totalTimer)*100.f)>99?99:(int)(((float)checkTotalTime/(float)totalTimer)*100.f)];
    proccessLab.textAlignment = NSTextAlignmentCenter;
}

-(void)checkOnline
{
    if (totalTimer-checkTotalTime>10)
    {
        NSDictionary *param = @{@"accountId":[AppSingleton currentUser].accountId?[AppSingleton currentUser].accountId:@"",@"deviceId":_deviceModel.deviceId?_deviceModel.deviceId:@""};
        [HomeHttpHandler home_checkDeviceOnlineStatus:param preExecute:^{
            
        } success:^(id obj) {
            if([obj[request_data_key][@"online"] boolValue]==YES)
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:notification_device_online_status_key object:nil];
                self.deviceModel.onLine = YES;
                [player stop];
                [self stopConfig];
                
                NSData *nsdata = [configLogStr dataUsingEncoding:NSUTF8StringEncoding];
                
                // Get NSString from NSData object in Base64
                NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
                NSDictionary *param = @{@"accountId":[AppSingleton currentUser].accountId?[AppSingleton currentUser].accountId:@"",@"deviceId":_deviceModel.deviceId?_deviceModel.deviceId:@"",@"log":base64Encoded?base64Encoded:@"",@"state":@"1"};
                [HomeHttpHandler home_uploadConfigLog:param preExecute:nil success:nil failed:nil];
                [self dealLogic];
            }else
            {
                
            }
            
        } failed:^(id obj) {
            
        }];
    }else//配置超时
    {
        [self stopConfig];
        NSData *nsdata = [configLogStr dataUsingEncoding:NSUTF8StringEncoding];
        
        // Get NSString from NSData object in Base64
        NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
        NSDictionary *param = @{@"accountId":[AppSingleton currentUser].accountId?[AppSingleton currentUser].accountId:@"",@"deviceId":_deviceModel.deviceId?_deviceModel.deviceId:@"",@"log":base64Encoded?base64Encoded:@"",@"state":@"0"};
        [HomeHttpHandler home_uploadConfigLog:param preExecute:nil success:nil failed:nil];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"配置完毕，稍后请查看设备的绿灯状态。如果绿灯常亮，说明配置网络成功。否则，请重新配置。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 600;
        [alertView show];
        processBar.width = (checkTotalTime/totalTimer)*processNotiLab.width>=processNotiLab.width?processNotiLab.width:(checkTotalTime/totalTimer)*processNotiLab.width;
        proccessLab.text = [NSString stringWithFormat:@"%d %%",(int)(((float)checkTotalTime/(float)totalTimer)*100.f)>99?99:(int)(((float)checkTotalTime/(float)totalTimer)*100.f)];
        proccessLab.textAlignment = NSTextAlignmentCenter;
    }
    
}
-(void)dealLogic//配置后的处理逻辑部分
{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"配置设备网络成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alert.tag = 200;
    [alert show];
}
- (void) onRecognizerStart
{
//    printf("------------------recognize start\n");
}
-(void)checkSendOver
{
}
- (void) showRecogResult:(NSString *)_msg
{
    
}

- (void) onRecognizerEnd:(int)_result data:(char *)_data dataLen:(int)_dataLen
{
    NSString *msg = nil;
	char s[100];
    if (_result == VD_SUCCESS)
	{
//		printf("------------------recognized data:%s\n", _data);
//        //title = @"recognize ok";
		enum InfoType infoType = vr_decodeInfoType(_data, _dataLen);
		if(infoType == IT_STRING)
		{
			vr_decodeString(_result, _data, _dataLen, s, sizeof(s));
//			printf("string:%s\n", s);
//            msg = [NSString stringWithFormat:@"recognized string:%s", s];
		}
		else
		{
//			printf("------------------recognized data:%s\n", _data);
//            msg = [NSString stringWithFormat:@"recognized data:%s", _data];
		}
	}
	else
	{
//		printf("------------------recognize invalid data, errorCode:%d, error:%s\n", _result, recorderRecogErrorMsg(_result));
	}
    if(msg != nil)[self performSelectorOnMainThread:@selector(showRecogResult:) withObject:msg waitUntilDone:NO];
}


/**
 独立指令 
 7号指令 app搜索设备
 
 消息指令最多共7个
 0号指令 发送wifi ssid信号,其中限制ssid信号长度最多为32个字节
 1号指令 发送wifi密码,
 2号指令 发送网络类型+wifi认证模式和加密方式,网路类型有0:无限静态,1:无限dhcp,2:有线静态,3:有线dhcp
 
 3号指令 有2号指令中的网络类型字段决定如果2号指令的网络模式是dhcp(无线/有线)则发送结束.若是静态ip(无线/有线)
 则3号指令发送ip地址;
 4号指令 存在与否同3号 子网掩码
 5号指令 存在与否同3号 网关
 6号指令 存在与否同3号 DNS服务器

 8号指令 云服务器IP地址和端口号
 
 
 */
/**
 *  消息打包
 *
 *  @param cmd      消息指令
 *  @param snNumber 设备序列号最后6位
 *  @param content  消息内容;
 *
 *  @return 返回组装好的消息
 */
-(NSString *)packageMessageWithCmd:(NSString*)cmd deviceSN:(NSString*)snNumber contentData:(NSString*)content
{
    NSString *str = [cmd stringByAppendingFormat:@"0%@%@",snNumber,content];
    return str;
}
/**
 *  消息拆包
 *
 *  @param message 原消息内容
 *
 *  @return 拆分后的消息返回结果
 */
-(NSDictionary*)decodeMessage:(NSString*)message
{
    if ([message stringByReplacingOccurrencesOfString:@" " withString:@""].length!=10) {
        return nil;
    }
    NSString *cmd = [message substringToIndex:1];
    NSString *type = [message substringWithRange:NSMakeRange(1, 1)];
    NSString *snNumber = [message substringWithRange:NSMakeRange(2, 6)];
    NSString *content = [message substringFromIndex:message.length-1];
    return  @{@"receiveCmd":cmd,@"type":type,@"receiveSnNumber":snNumber,@"receiveContent":content};
}
-(void)dealloc
{
    
}
@end
