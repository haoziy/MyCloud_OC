#import "MNGDeviceNetConfigViewController.h"
#include "voiceRecog.h"
#import "HomeDeviceManagerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "HomeHttpHandler.h"
#import "AFNetworkReachabilityManager.h"

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
    
//    BMKLocationService *locationService;
//    BMKAddressComponent *addressDetail;
//    BMKReverseGeoCodeResult *georesult;//地理位置信息
    double latitude;//纬度
    double longtitude;//经度
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
    
}

@end

CGFloat TOP_PADDING = [MRJSizeManager mrjVerticalSpace];
CGFloat LEFT_PADDING = [MRJSizeManager mrjHorizonPaddding];
UIFont *MiddleTextFont = [MRJSizeManager mrjMiddleTextFont];
UIColor *MainTextColor = [MRJColorManager mrj_mainTextColor];
CGFloat INPUT_HEIGHT = [MRJSizeManager mrjInputSizeHeight];
UIColor *NavigationTextColor = [MRJColorManager mrj_navigationTextColor];
CGFloat TableHeadHeight = [MRJSizeManager mrjTableHeadHeight];
UIColor *SecondaryTextColor = [MRJColorManager mrj_secondaryTextColor];
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
            [self.view.window addSubview:holdView];
            notificationLab.text =@"正在发送网络参数";
//            [DeviceManageHandler deviceHeartBeatTestSuccess:^(id obj2) {
//                if ([obj2 [@"status"] integerValue]==0) {
//                    [globalTimer invalidate];
//                    globalTimer = nil;
//                    globalTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(globalSendMessage) userInfo:nil repeats:YES];
//                    [allConsumeTimer invalidate];
//                    allConsumeTimer = nil;
//                    allConsumeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeUI) userInfo:nil repeats:YES];
//                    [allConsumeTimer fire];
//                }else
//                {
//                    [holdView removeFromSuperview];
//                    self.view.userInteractionEnabled = YES;
//                    [AppUtils showErrorMessage:obj2[@"msg"]];
//                }
//                
//            } Failed:^(id obj) {
//                [holdView removeFromSuperview];
//                self.view.userInteractionEnabled = YES;
//                [AppUtils showErrorMessage:obj];
//            }];
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
//        for (UIViewController *vc  in self.navigationController.viewControllers) {
//            if ([vc isKindOfClass:[DeviceDetailViewController class]]) {
//                [self.navigationController popToViewController:vc animated:YES];
//            }
//        }
    }else if (self.enterWay==DeviceConfigEnteryFromDeviceList) {
        for (UIViewController *vc  in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[HomeDeviceManagerViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(beginConfig:)];
    [item setTintColor:[MRJColorManager mrj_navigationTextColor]];
    self.navigationItem.rightBarButtonItem = item;
    totalHight = TOP_PADDING;//默认的高度
    scorllView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scorllView.backgroundColor = self.view.backgroundColor;
    self.view = scorllView;
    scorllView.contentSize = CGSizeMake(SCREEN_WIDTH, 568);
 
    isCanAssignTask = YES;
    messageArr = [NSMutableArray array];
    self.title = @"配置网络";
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(-20, 20,60, 40)];
    [btn setImage:[UIImage imageNamed:@"arrowleft"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 45)];
    
    [btn addTarget:self action:@selector(backToLast:) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(calculateSubMarkGateWay:) name:UITextFieldTextDidEndEditingNotification object:nil];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, TOP_PADDING, 100, [MRJSizeManager mrjTableHeadHeight])];
    label.textColor = [MRJColorManager mrj_secondaryTextColor];
    label.text =  @"配置网络";
    label.font = [MRJSizeManager mrjMiddleTextFont];
    [label sizeToFit];
    label.x= 20;
    label.y=20;
    totalHight=label.height+label.y;
    //是否需要选择配置网络类型(无线/有线)
    if(_deviceModel.hardModel==DeviceHardModelM1Plus)
    {
        [self createNetTypeUI];
    }else
    {
        ///仅仅为了初始化必须选择一种方式
        confgiNetWorkTypeWifiBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, (40-15)/2, 15, 15)];
        [confgiNetWorkTypeWifiBtn setImage:[UIImage imageNamed:@"select_white"] forState:UIControlStateNormal];
        [confgiNetWorkTypeWifiBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        confgiNetWorkTypeWifiBtn.selected = YES;
        confgiNetWorkTypeLanBtn = [[UIButton alloc]init];
    }
    
    backV = [[UIView alloc]initWithFrame:CGRectMake(0, totalHight, SCREEN_WIDTH, 200)];
    [self.view addSubview:backV];
    //静态地址输入框
    [self createStaticInputV];
    //配置过程中的覆盖视图
    [self createHoldV];
    
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        networkReachableWayLab = [[UILabel alloc]init];
        currentSSID = nil;
        for (UIView *v in backV.subviews) {
            [v removeFromSuperview];
        }
        NSString *orginStr=@"请将手机网络切换至设备所连接的Wi-Fi网络";
        [confirmConfigBtn removeFromSuperview];
        if (status==AFNetworkReachabilityStatusReachableViaWiFi) {
            [self fetchSSIDInfo];
            if (currentSSID) {
                orginStr = [NSString stringWithFormat:@"当前手机Wi-Fi %@",currentSSID];
            }
        }
        CGRect rect = [orginStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-LEFT_PADDING*2, 60) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:MiddleTextFont} context:nil];
        networkReachableWayLab.numberOfLines = 0;
        networkReachableWayLab.lineBreakMode = NSLineBreakByWordWrapping;
        networkReachableWayLab.textColor = MainTextColor;
        networkReachableWayLab.font = MiddleTextFont;
        networkReachableWayLab.text = orginStr;
        networkReachableWayLab.frame = CGRectMake((SCREEN_WIDTH-LEFT_PADDING*2-rect.size.width)/2+LEFT_PADDING, 0, rect.size.width, rect.size.height);
        networkReachableWayLab.textAlignment = NSTextAlignmentCenter;
        if (confgiNetWorkTypeLanBtn.selected ==YES) {
            networkReachableWayLab.hidden = YES;
        }else
        {
            networkReachableWayLab.hidden = NO;
        }
        [backV addSubview:networkReachableWayLab];
        [self createUI];
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
-(void)createHoldV
{
    holdView = [[UIView alloc]initWithFrame:self.view.bounds];
    holdView.backgroundColor = [UIColor clearColor];
    UIView *processView = [[UIView alloc]initWithFrame:CGRectMake(20, (SCREEN_HEIGHT-200)/2, SCREEN_WIDTH-40, 200)];
//    processView.backgroundColor = RGBColor(114, 114, 114, 1);
    processView.layer.cornerRadius = 5;
    processView.clipsToBounds = YES;
    
    processNotiLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, processView.width-40, 30)];
    processNotiLab.text = @"提示";
    processNotiLab.font = [MRJSizeManager mrjNavigationFont];
    processNotiLab.textColor = [MRJColorManager mrj_mainThemeColor];
    [processView addSubview:processNotiLab];
    
    UIView *buttomV = [[UIView alloc]initWithFrame:CGRectMake(20, processNotiLab.height+processNotiLab.y, processView.width-40, processView.height-20-processNotiLab.height-processNotiLab.y)];
    buttomV.backgroundColor = [MRJColorManager mrj_navigationTextColor];
    [processView addSubview:buttomV];
    
    UIView *sepLineV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, buttomV.width, 3)];
    sepLineV.backgroundColor = [MRJColorManager mrj_mainThemeColor];
    [buttomV addSubview:sepLineV];
    notificationLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, buttomV.width, 50)];
    notificationLab.text = @"";
    notificationLab.numberOfLines = 0;
    notificationLab.lineBreakMode = NSLineBreakByWordWrapping;
    [buttomV addSubview:notificationLab];
    
    UIView *processBarBgV = [[UIView alloc]initWithFrame:CGRectMake(0, 60, notificationLab.width, 20)];
    processBarBgV.layer.cornerRadius = 2;
    [buttomV addSubview:processBarBgV];
    processBarBgV.backgroundColor  = [UIColor grayColor];
    processBar = [[UIView alloc]initWithFrame:CGRectMake(0, 60, 1, 20)];
    processBar.backgroundColor = [MRJColorManager mrj_mainThemeColor];
    [buttomV addSubview:processBar];
    
    proccessLab = [[UILabel alloc]initWithFrame:CGRectMake(0, buttomV.height-30, processView.width, 30)];
    proccessLab.textAlignment = NSTextAlignmentCenter;
    proccessLab.text = @"0%";
    [buttomV addSubview:proccessLab];
    
    
    [holdView addSubview:processView];
}
-(void)createStaticInputV
{
    staticInputView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, backV.width,INPUT_HEIGHT*4+TOP_PADDING)];
    staticInputView.backgroundColor = NavigationTextColor;
    NSArray *inputItemsArr = @[@"IP地址",@"子网掩码",@"网关",@"DNS"];
    for (int x=0; x<inputItemsArr.count; x++) {
        MRJTextField *textFiled = [[MRJTextField alloc]initWithFrame:CGRectMake(LEFT_PADDING,x*INPUT_HEIGHT, staticInputView.width-LEFT_PADDING*2,INPUT_HEIGHT)];
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
    }
//    [staticInputView addSubview:[UIView initCellLineViewWithFrame:CGRectMake(0, staticInputView.height-0.5, staticInputView.width, 0.5)]];
}
-(void)createNetTypeUI
{
    [confgiNetWorkTypeWifiBtn removeFromSuperview];
    [confgiNetWorkTypeLanBtn removeFromSuperview];
    confgiNetWorkTypeWifiBtn = nil;
    confgiNetWorkTypeLanBtn = nil;
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, totalHight, SCREEN_WIDTH, TableHeadHeight)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_PADDING, 0,75, TableHeadHeight)];
    label.text = @"网络类型";
    label.font = MiddleTextFont;
    label.textColor = SecondaryTextColor;
    [v addSubview:label];
    [self.view addSubview:v];
    totalHight+=v.height;
    
    
    //选择网络类型区域
    UIView *configTypeV = [[UIView alloc]initWithFrame:CGRectMake(0, totalHight, SCREEN_WIDTH, INPUT_HEIGHT)];
    configTypeV.backgroundColor = NavigationTextColor;
//    [configTypeV addSubview:[UIView initCellLineViewWithFrame:CGRectMake(0, 0, configTypeV.width, 0.5)]];
//    [configTypeV addSubview:[UIView initCellLineViewWithFrame:CGRectMake(0, configTypeV.height-0.5, configTypeV.width, 0.5)]];
    confgiNetWorkTypeWifiBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, (INPUT_HEIGHT-15)/2, 15, 15)];
    [confgiNetWorkTypeWifiBtn setImage:[UIImage imageNamed:@"select_white"] forState:UIControlStateNormal];
    [confgiNetWorkTypeWifiBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [confgiNetWorkTypeWifiBtn addTarget:self action:@selector(choiceNetType:) forControlEvents:UIControlEventTouchUpInside];
    typeWifiBtn = [[UIButton alloc]initWithFrame:CGRectMake(confgiNetWorkTypeWifiBtn.width+confgiNetWorkTypeWifiBtn.x+5, (INPUT_HEIGHT-20)/2, (configTypeV.width/2-(confgiNetWorkTypeWifiBtn.width+confgiNetWorkTypeWifiBtn.x)), 20)];
    
    typeWifiBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [typeWifiBtn setTitle:@"Wi-Fi" forState:UIControlStateNormal];
    [typeWifiBtn setTitleColor:SecondaryTextColor forState:UIControlStateNormal];
    [typeWifiBtn setTitleColor:MainTextColor forState:UIControlStateSelected];
    [typeWifiBtn addTarget:self action:@selector(choiceNetType:) forControlEvents:UIControlEventTouchUpInside];
    typeWifiBtn.selected = YES;
    confgiNetWorkTypeWifiBtn.selected = YES;
    [configTypeV addSubview:confgiNetWorkTypeWifiBtn];
    [configTypeV addSubview:typeWifiBtn];
  
    
    confgiNetWorkTypeLanBtn = [[UIButton alloc]initWithFrame:CGRectMake(20+configTypeV.width/2, (INPUT_HEIGHT-15)/2, 15, 15)];
    [confgiNetWorkTypeLanBtn setImage:[UIImage imageNamed:@"select_white"] forState:UIControlStateNormal];
    [confgiNetWorkTypeLanBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [confgiNetWorkTypeLanBtn addTarget:self action:@selector(choiceNetType:) forControlEvents:UIControlEventTouchUpInside];
    typeLanBtn = [[UIButton alloc]initWithFrame:CGRectMake((confgiNetWorkTypeLanBtn.width+confgiNetWorkTypeLanBtn.x+5), (INPUT_HEIGHT-20)/2,configTypeV.width/2-(confgiNetWorkTypeLanBtn.width+confgiNetWorkTypeLanBtn.x), 20)];
    typeLanBtn.x = confgiNetWorkTypeLanBtn.width+confgiNetWorkTypeLanBtn.x+5;
    typeLanBtn.width = configTypeV.width - typeLanBtn.x;
    [typeLanBtn setTitleColor:SecondaryTextColor forState:UIControlStateNormal];
    [typeLanBtn setTitleColor:MainTextColor forState:UIControlStateSelected];
    typeLanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [typeLanBtn setTitle:@"有线网络" forState:UIControlStateNormal];
    [typeLanBtn addTarget:self action:@selector(choiceNetType:) forControlEvents:UIControlEventTouchUpInside];
    [configTypeV addSubview:confgiNetWorkTypeLanBtn];
    [configTypeV addSubview:typeLanBtn];
    [self.view addSubview:configTypeV];
    totalHight+=(configTypeV.height+10);

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
            if ([MRJCheckUtils isValidatIP:ipAddressTextField.text]) {
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
-(void)createUI
{
//    CGFloat location = networkReachableWayLab.height+networkReachableWayLab.y+10;
//    if (currentSSID) {
//        wifiInputV = [[UIView alloc]initWithFrame:CGRectMake(0, networkReachableWayLab.height+networkReachableWayLab.y+10, SCREEN_WIDTH, INPUT_HEIGHT)];
//        passTextField = [[MRJTextField alloc]initWithFrame:CGRectMake(LEFT_PADDING, 0, wifiInputV.width-LEFT_PADDING*2, INPUT_HEIGHT)];
//        passTextField.keyboardType = UIKeyboardTypeASCIICapable;
//        passTextField.placeholder = @"Wi-Fi密码";
//        [wifiInputV addSubview:passTextField];
//        if (confgiNetWorkTypeWifiBtn.selected==YES) {
//            [backV addSubview:wifiInputV];
//            location+=wifiInputV.height;
//        }
//    }
//    
//    ipSetttingV = [[UIView alloc]initWithFrame:CGRectMake(0, location,SCREEN_WIDTH,TableHeadHeight+ROW_HEIGHT)];
//    UILabel *ipSettingLab = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_PADDING, VERTICAL_SAPCE*2, SCREEN_WIDTH-LEFT_PADDING*2, TableHeadHeight)];
//    ipSettingLab.text = @"IP设置";
//    ipSettingLab.textColor = SecondaryTextColor;
//    ipSettingLab.font = MiddleTextFont;
//    [ipSetttingV addSubview:ipSettingLab];
//    
//    ipChoiceV = [[UIView alloc]initWithFrame:CGRectMake(0, ipSettingLab.height+ipSettingLab.y, SCREEN_WIDTH, ROW_HEIGHT)];
//    
//    [ipChoiceV addSubview:[UIView initCellLineViewWithFrame:CGRectMake(0, 0, ipChoiceV.width, 0.5)]];
//    [ipChoiceV addSubview:[UIView initCellLineViewWithFrame:CGRectMake(0, ipChoiceV.height-0.5,ipChoiceV.width, 0.5)]];
//    ipChoiceV.backgroundColor = NavigationTextColor;
//    dhcpBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, (ROW_HEIGHT-15)/2, 15, 15)];
//    [dhcpBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
//    [dhcpBtn setImage:[UIImage imageNamed:@"select_white"] forState:UIControlStateNormal];
//    [dhcpBtn addTarget:self action:@selector(choiceIpType:) forControlEvents:UIControlEventTouchUpInside];
//    dhcpBtn.selected = YES;
//
//    dhcpLab = [[UIButton alloc]initWithFrame:CGRectMake(dhcpBtn.width+dhcpBtn.x+5, (ROW_HEIGHT-20)/2, 40, 20)];
//    [dhcpLab setTitleColor:MainTextColor forState:UIControlStateSelected];
//    [dhcpLab setTitleColor:SecondaryTextColor forState:UIControlStateNormal];
//    dhcpLab.width = ipChoiceV.width/2-dhcpBtn.x-dhcpBtn.width;
//    [dhcpLab setTitle:@"动态" forState:UIControlStateNormal];
//    dhcpLab.selected = YES;
//    dhcpLab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [dhcpLab addTarget:self action:@selector(choiceIpType:) forControlEvents:UIControlEventTouchUpInside];
//    [ipChoiceV addSubview:dhcpBtn];
//    [ipChoiceV addSubview:dhcpLab];
//    [ipSetttingV addSubview:ipChoiceV];
//    
//    staticBtn = [[UIButton alloc]initWithFrame:CGRectMake(20+ipChoiceV.width/2,(ROW_HEIGHT-15)/2, 15, 15)];
//    [staticBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
//    [staticBtn addTarget:self action:@selector(choiceIpType:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [staticBtn setImage:[UIImage imageNamed:@"select_white"] forState:UIControlStateNormal];
//    staticLab = [[UIButton alloc]initWithFrame:CGRectMake(staticBtn.width+staticBtn.x+5, (ROW_HEIGHT-20)/2, 40, 20)];
//    [staticLab setTitle:@"静态" forState:UIControlStateNormal];
//    staticLab.width = ipChoiceV.width/2-40;
//    staticLab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [staticLab addTarget:self action:@selector(choiceIpType:) forControlEvents:UIControlEventTouchUpInside];
//    [staticLab setTitleColor:MainTextColor forState:UIControlStateSelected];
//    [staticLab setTitleColor:SecondaryTextColor forState:UIControlStateNormal];
//    [ipChoiceV addSubview:staticBtn];
//    [ipChoiceV addSubview:staticLab];
//    ipSetttingV.height = ipChoiceV.height+ipChoiceV.y;
//    
//
//    [backV addSubview:ipSetttingV];
//    backV.height = ipSetttingV.height+ipSetttingV.y+TOP_PADDING;
    
//    confirmConfigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [confirmConfigBtn setTitle:@"确定" forState:UIControlStateNormal];
//    confirmConfigBtn.backgroundColor = DefaultCellForegroundColor;
//    confirmConfigBtn.width = SCREEN_WIDTH*3/5;
//    confirmConfigBtn.height = 44;
//    confirmConfigBtn.centerX = SCREEN_WIDTH/2;
//    confirmConfigBtn.y = backV.height+backV.y+20;
//    [confirmConfigBtn addTarget:self action:@selector(beginConfig:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:confirmConfigBtn];
}
-(void)choiceNetType:(UIButton*)btn
{
    confgiNetWorkTypeWifiBtn.selected = !confgiNetWorkTypeWifiBtn.selected;
    confgiNetWorkTypeLanBtn.selected  = !confgiNetWorkTypeLanBtn.selected;
    if (confgiNetWorkTypeLanBtn.selected==YES) {
        networkReachableWayLab.hidden = YES;
        typeLanBtn.selected = YES;
        typeWifiBtn.selected = NO;
        [networkReachableWayLab removeFromSuperview];
        [wifiInputV removeFromSuperview];
        wifiInputV.height=0;
        ipSetttingV.y = 0;
        
        ipAddressTextField.text = [AppSingleton shareInstace].lanStatiConfigIP;
        subMarkTextField.text =  [AppSingleton shareInstace].lanStatiConfiMask;
        gateWayTextField.text =  [AppSingleton shareInstace].lanStatiConfigGateWay;
        DNSTextField.text =  [AppSingleton shareInstace].lanStatiConfigDNS;
        
    }
    else
    {
        networkReachableWayLab.hidden = NO;
        ipAddressTextField.text =  [AppSingleton shareInstace].wifiStatiConfigIP;
        subMarkTextField.text =  [AppSingleton shareInstace].wifiStatiConfiMask;
        gateWayTextField.text =  [AppSingleton shareInstace].wifiStatiConfigGateWay;
        DNSTextField.text =  [AppSingleton shareInstace].wifiStatiConfigDNS;
        typeLanBtn.selected = NO;
        typeWifiBtn.selected = YES;
        [backV addSubview:networkReachableWayLab];
        if(currentSSID)
        {
            wifiInputV.y = networkReachableWayLab.height+networkReachableWayLab.y;
            wifiInputV.height = 40;
            [backV addSubview:wifiInputV];
        }
        ipSetttingV.y = wifiInputV.height+wifiInputV.y;
    }
   
    backV.height = ipSetttingV.y+ipSetttingV.height+20;
    staticBtn.selected = NO;
    dhcpBtn.selected = YES;
    [staticInputView removeFromSuperview];
    backV.height = ipSetttingV.height+ipSetttingV.y+20;
    confirmConfigBtn.y = backV.height+backV.y+20;
}
#pragma mark --baidu location delegate
- (void)willStartLocatingUser;
{
    
}
/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser;
{
    
}
/**
// *用户方向更新后，会调用此函数
// *@param userLocation 新的用户位置
// */
//- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation;
//{
//    
//}
///**
// *用户位置更新后，会调用此函数
// *@param userLocation 新的用户位置
// */
//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation;
//{
//    longtitude =  userLocation.location.coordinate.longitude;
//    latitude = userLocation.location.coordinate.latitude;
//    [locationService stopUserLocationService];
//    BMKReverseGeoCodeOption *geoCode = [[BMKReverseGeoCodeOption alloc]init];
//    geoCode.reverseGeoPoint = userLocation.location.coordinate;
//    BMKGeoCodeSearch *serach = [[BMKGeoCodeSearch alloc]init];
//    serach.delegate = self;
//    [serach reverseGeoCode:geoCode];
//    
//    //    BMKLocationService
//}
//#pragma mark reverGeo delegate
///**
// *返回地址信息搜索结果
// *@param searcher 搜索对象
// *@param result 搜索结BMKGeoCodeSearch果
// *@param error 错误号，@see BMKSearchErrorCode
// */
//- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error;
//{
//    
//}
///**
// *返回反地理编码搜索结果
// *@param searcher 搜索对象
// *@param result 搜索结果
// *@param error 错误号，@see BMKSearchErrorCode
// */
//- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error;
//{
//    addressDetail = result.addressDetail;
//    georesult = result;
//    
//}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error;
{
    //    [AppUtils showErrorMessage:@"定位失败,请确认是否允许使用地理位置信息"];
}
-(void)beginConfig:(UIButton*)btn
{
//    [self.view endEditing:YES];
//    if (confgiNetWorkTypeWifiBtn.selected==YES)//wifi配置
//    {
//        int x=0;
//        for(int i=0; i< [currentSSID length];i++){
//            int a = [currentSSID characterAtIndex:i];
//            if( a > 0x4e00 && a < 0x9fff)
//            {
//                x++;
//            }
//        }
//        if (x>7) {
//            [AppUtils showAlertMessage:@"设备暂不支持这么多中文的Wi-Fi网络"];
//            return;
//        }
//        NSRange range = [currentSSID rangeOfString:@"&"];
//        if (range.length>0) {
//            [AppUtils showAlertMessage:@"设备暂不支持特殊字符&的Wi-Fi网络"];
//            return;
//        }
//        if ([currentSSID stringByReplacingOccurrencesOfString:@" " withString:@""].length<1) {
//            [AppUtils showErrorMessage:@"请将手机网络切换至设备所连接的Wi-Fi网络"];
//            return;
//        }
//    }
//    
//    
//    NSDictionary *dictStep1;
//    if(staticBtn.selected==YES)//是静态网络
//    {
//        if (![AppUtils isValidatIP:ipAddressTextField.text]) {
//            [AppUtils showErrorMessage:@"请输入合法的IP地址"];
//            return;
//        }
//        if (![AppUtils isValidatIP:subMarkTextField.text]) {
//            [AppUtils showErrorMessage:@"请输入合法的子网掩码"];
//            return;
//        }
//        if (![AppUtils isValidatIP:gateWayTextField.text]) {
//            [AppUtils showErrorMessage:@"请输入合法的网关地址"];
//            return;
//        }
//        if (![AppUtils isValidatIP:DNSTextField.text]) {
//            [AppUtils showErrorMessage:@"请输入合法的DNS地址"];
//            return;
//        }
//        if (confgiNetWorkTypeWifiBtn.selected==YES) {
//            
//            [UserDefaultsUtils saveValue:ipAddressTextField.text forKey:WIFI_STATIC_CONFIG_IP];
//            [UserDefaultsUtils saveValue:subMarkTextField.text forKey:WIFI_STATIC_CONFIG_MASK];
//            [UserDefaultsUtils saveValue:gateWayTextField.text forKey:WIFI_STATIC_CONFIG_GATEWAY];
//            [UserDefaultsUtils saveValue:DNSTextField.text forKey:WIFI_STATIC_CONFIG_DNS];
//        }else
//        {
//            [UserDefaultsUtils saveValue:ipAddressTextField.text forKey:LAN_STATIC_CONFIG_IP];
//            [UserDefaultsUtils saveValue:subMarkTextField.text forKey:LAN_STATIC_CONFIG_MASK];
//            [UserDefaultsUtils saveValue:gateWayTextField.text forKey:LAN_STATIC_CONFIG_GATEWAY];
//            [UserDefaultsUtils saveValue:DNSTextField.text forKey:LAN_STATIC_CONFIG_DNS];
//            
//        }
//        [[NSUserDefaults standardUserDefaults]synchronize];
//        if(confgiNetWorkTypeWifiBtn.selected==YES)//无线 静态ip
//        {
//            dictStep1  = @{@"cmd":@"2",@"snNumber":deviceSN,@"content":@"10"};//网络类型/ios/无线静态ip
//        }else //有线 静态
//        {
//            dictStep1  = @{@"cmd":@"2",@"snNumber":deviceSN,@"content":@"12"};//网络类型,ios/有线静态ip
//        }
//        
//        totalTimer =  300;
//    }else
//    {
//        if(confgiNetWorkTypeWifiBtn.selected==YES)//无线dhcp
//        {
//            dictStep1  = @{@"cmd":@"2",@"snNumber":deviceSN,@"content":@"11"};//网络类型/ios/无线DHCP
//        }else //有线 dhcp
//        {
//            dictStep1  = @{@"cmd":@"2",@"snNumber":deviceSN,@"content":@"13"};//网络类型,ios/
//        }
//        totalTimer =  200.f;
//    }
//    messageArr = [[NSMutableArray alloc]init];
//    checkTotalTime = 0;
//    index = 0;
//    [messageArr addObject:dictStep1];
//    //ssid和密码
//    if (confgiNetWorkTypeWifiBtn.selected==YES) {
//        NSDictionary *dictStep2 = @{@"cmd":@"0",@"snNumber":deviceSN,@"content":currentSSID};//ssid
//        [messageArr addObject:dictStep2];
//        if(currentSSID.length>7)
//        {
//            NSDictionary *dictStep2_more = @{@"cmd":@"0",@"snNumber":deviceSN,@"content":currentSSID};//ssid
//            [messageArr addObject:dictStep2_more];
//        }
//        NSDictionary *dictStep3 = @{@"cmd":@"1",@"snNumber":deviceSN,@"content":passTextField.text};//密码
//        [messageArr addObject:dictStep3];
//        if(passTextField.text.length>7)
//        {
//            NSDictionary *dictStep3_more = @{@"cmd":@"1",@"snNumber":deviceSN,@"content":passTextField.text};//密码
//            [messageArr addObject:dictStep3_more];
//        }
//    }
//    
//    //是否需要发送ip/gateway/mask/dns等
//    if (staticBtn.selected==YES) {
//        NSDictionary *ipDict = @{@"cmd":@"3",@"snNumber":deviceSN,@"content":ipAddressTextField.text};//ip地址
//        [messageArr addObject:ipDict];
//        
//        NSDictionary *markDict = @{@"cmd":@"4",@"snNumber":deviceSN,@"content":subMarkTextField.text};//子网掩码
//        [messageArr addObject:markDict];
//        
//        NSDictionary *gateDict = @{@"cmd":@"5",@"snNumber":deviceSN,@"content":gateWayTextField.text};//网关
//        [messageArr addObject:gateDict];
//        
//        NSDictionary *dnsDict = @{@"cmd":@"6",@"snNumber":deviceSN,@"content":DNSTextField.text};//dns服务器地址
//        [messageArr addObject:dnsDict];
//    }
//    NSDictionary *endDict = @{@"cmd":@"8",@"snNumber":deviceSN,@"content":[NSString stringWithFormat:@"%@:%@",_serverIp,_serverPort]};//结束标识
//    [messageArr addObject:endDict];
//    NSDictionary *endDict_more = @{@"cmd":@"8",@"snNumber":deviceSN,@"content":[NSString stringWithFormat:@"%@:%@",_serverIp,_serverPort]};//结束标识
//    [messageArr addObject:endDict_more];
//    
//    //加一倍
//    for (int x=0; x<messageArr.count; x+=2) {
//        NSDictionary *dict = [messageArr[x] mutableCopy];
//        [messageArr insertObject:dict atIndex:x];
//    }
//    configLogStr = [NSMutableString stringWithFormat:@"AccountEntity:AccountId=%@,username = %@,gender = %@,nickName = %@,fullName = %@,appSecret = %@,mobile = %@;Device:deviceId = %@,imei = %@,imsi = %@,ssid = %@,softVersion = %@ Client:mobileSystem = %@,mobileType = %@\n",entity.accountId,entity.username,entity.gender,entity.nickname,entity.fullname,entity.appSecret,entity.mobile,_deviceModel.deviceId,_deviceModel.imei,_deviceModel.imsi,currentSSID,_deviceModel.softVersion,[UIDevice currentDevice].systemVersion,[UIDevice currentDevice].model];
//    if (confgiNetWorkTypeWifiBtn.selected==YES)//配置的是无线
//    {
//        if(passTextField.text.length==0)
//        {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"【Wi-Fi】密码确定为空吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            alert.tag  = 100;
//            [alert show];
//            return;
//        }
//    }
//    
//    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
//    [self.view.window addSubview:holdView];
//    notificationLab.text =@"正在发送网络参数";
//    [DeviceManageHandler deviceHeartBeatTestSuccess:^(id obj2) {
//        if ([obj2 [@"status"] integerValue]==0) {
//            [globalTimer invalidate];
//            globalTimer = nil;
//            globalTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(globalSendMessage) userInfo:nil repeats:YES];
//            [allConsumeTimer invalidate];
//            allConsumeTimer = nil;
//            allConsumeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeUI) userInfo:nil repeats:YES];
//            [allConsumeTimer fire];
//        }else
//        {
//            [holdView removeFromSuperview];
//            self.view.userInteractionEnabled = YES;
//            [AppUtils showErrorMessage:obj2[@"msg"]];
//        }
//        
//        
//    } Failed:^(id obj) {
//        [holdView removeFromSuperview];
//        self.view.userInteractionEnabled = YES;
//        [AppUtils showErrorMessage:obj];
//    }];
    
    
    
}
- (void) viewWillAppear:(BOOL)animated
{
    NSLog(@"viewVillAppear");
    [recog start];
    [super viewWillAppear:animated];
}
-(void)choiceIpType:(UIButton*)btn
{
    dhcpLab.selected = !dhcpLab.selected;
    staticLab.selected = !staticLab.selected;
    dhcpBtn.selected  = !dhcpBtn.selected;
    staticBtn.selected = !staticBtn.selected;
    
    if (staticBtn.selected == YES) {
        staticInputView.origin = CGPointMake(0, ipSetttingV.y+ipSetttingV.height);
        backV.height = staticInputView.height +backV.height;
        [backV addSubview:staticInputView];
    }else
    {
        [staticInputView removeFromSuperview];
         backV.height = ipSetttingV.height+ipSetttingV.y;
    }
}
- (void) viewWillDisappear:(BOOL)animated
{
     [super viewWillDisappear:animated];
    [recog stop];
    [player stop];
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
                    cmdType = @"Wi-Fi ssid";
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
            [player playString:str playCount:1 muteInterval:0];
            NSString *log = [NSString stringWithFormat:@"第%ld秒发送第%ld条命令发送内容为%@",(long)checkTotalTime,(long)index+1,cmdType];
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
                notificationLab.text =@"网络参数发送完毕，正在配置设备网络";
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
                    cmdType =@"Wi-Fi ssid";
                    break;
                case 1:
                    cmdType = @"Wi-Fi password";
                    break;
                case 2:
                {
                    cmdType =[NSString stringWithFormat:@"网络类型%@",[[str substringFromIndex:str.length-1] integerValue]==0?@"无线静态":@"无线dhcp"];
                    
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
            NSString *log = [NSString stringWithFormat:@"第%ld秒发送第%ld条命令发送内容为%@",(long)checkTotalTime,(long)index+1,cmdType];
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
//    if (totalTimer-checkTotalTime>10) {
//        [DeviceManageHandler myDeviceDetailWithDeviceId:_deviceModel.deviceId Success:^(id obj) {
//            if ([obj isKindOfClass:[DeviceModel class]]) {
//                DeviceModel *model = obj;
//                if (model.onLine) {
//                    [player stop];
//                    [allConsumeTimer invalidate];
//                    allConsumeTimer = nil;
//                    [checkOnline invalidate];
//                    checkOnline = nil;
//                    [globalTimer invalidate];
//                    globalTimer = nil;
//                    self.view.userInteractionEnabled = YES;
//                    [holdView removeFromSuperview];
//                    [[SQHttpHelper sharedHttpManager]cancelNetworkRequest];
//                    [DeviceManageHandler deviceUploadNetConfigLogWithAccountId:entity.accountId creator:entity.accountId snNumber:_deviceModel.imei successStatus:@"1" content:configLogStr recode:@""];
//                    _deviceModel = obj;
//
//                    [self dealLogic];
//                }
//            }else{
//                [AppUtils showErrorMessage:obj];
//            }
//        } Failed:^(id obj) {
////            [AppUtils showErrorMessage:TEXT_SERVER_NOT_RESPOND];
//        }];
//        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
//    }else
//    {
//        [globalTimer invalidate];
//        globalTimer = nil;
//        [checkOnline invalidate];
//        checkOnline = nil;
//        [allConsumeTimer invalidate];
//        allConsumeTimer = nil;
//        checkTotalTime = 0;
//        isCanAssignTask = YES;
//        [holdView removeFromSuperview];
//        [DeviceManageHandler deviceUploadNetConfigLogWithAccountId:entity.accountId creator:entity.accountId snNumber:_deviceModel.imei successStatus:@"0" content:configLogStr recode:@""];
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"配置完毕，稍后请查看设备的绿灯状态。如果绿灯常亮，说明配置网络成功。否则，请重新配置。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        alertView.tag = 600;
//        [alertView show];
//        processBar.width = (checkTotalTime/totalTimer)*processNotiLab.width>=processNotiLab.width?processNotiLab.width:(checkTotalTime/totalTimer)*processNotiLab.width;
//        proccessLab.text = [NSString stringWithFormat:@"%d %%",(int)(((float)checkTotalTime/(float)totalTimer)*100.f)>99?99:(int)(((float)checkTotalTime/(float)totalTimer)*100.f)];
//        proccessLab.textAlignment = NSTextAlignmentCenter;
//        self.view.userInteractionEnabled = YES;
//        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
//    }
    
}
-(void)dealLogic//配置后的处理逻辑部分
{
//    if (longtitude!=-1&&latitude!=-1) {
//        [DeviceManageHandler deiceUploadGeoLocationWithsnNumber:_deviceModel.imei latitude:@(latitude) longtitude:@(longtitude) precision:@"1" province:addressDetail.province city:addressDetail.city area:addressDetail.district streetAddress:georesult.address gpsPositionType:@"cellarNet"];
//    }
//    if (!_deviceModel.initBind)//未绑定店铺
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"现在去绑定店铺" delegate:self cancelButtonTitle:nil otherButtonTitles:@"绑定店铺", nil];
//        alert.tag = 300;
//        [alert show];
//    }else
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"配置设备网络成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        alert.tag = 200;
//        [alert show];
//    }
    self.view.userInteractionEnabled = YES;
    
   
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
            msg = [NSString stringWithFormat:@"recognized string:%s", s];
		}
		else
		{
//			printf("------------------recognized data:%s\n", _data);
            msg = [NSString stringWithFormat:@"recognized data:%s", _data];
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
