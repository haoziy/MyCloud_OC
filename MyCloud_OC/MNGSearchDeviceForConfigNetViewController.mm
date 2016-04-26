//
//  MNGSearchDeviceForConfigNetViewController.m
//  EachPlan
//
//  Created by ZEROLEE on 15/9/15.
//  Copyright (c) 2015年 XiaoZhou. All rights reserved.
//

#import "MNGSearchDeviceForConfigNetViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "voiceRecog.h"
#import "MNGSearchDeviceSuccessView.h"
#import <AudioToolbox/AudioSession.h>

#import "MNGDeviceNetConfigViewController.h"
#import "HomeHttpHandler.h"
#import <MediaPlayer/MediaPlayer.h>

static int baseFrequence = 4000;
@interface MNGSearchDeviceForConfigNetViewController ()<MNGSearchDeviceSuccessDelegate>
{
    UILabel *lastTipsLab;//用来标记位置
    NSMutableArray *messageArr;
    NSString *deviceSN;
    NSTimer *myTimer;
    NSInteger sendCount;//重发遍数
    BOOL shoulSendNext;//是重发发送下一条
    NSString *searchMessageContent;//搜索设备命令
    
    DeviceConfigEnteryWay privateEnterWay;
    UIButton *searchBtn;
    CGFloat lastTipHeight;//最后一个温馨提示的位置
    UIScrollView *backScorllView;
    MNGSearchDeviceSuccessView *successV;//成功提示
    UIView *failV;//失败提示
    
    NSString *ipAddress;//为设备配置网络的ip
    NSString *port;//为设备配置网络的端口
    
    CALayer *waveLayer;//动画层
    NSTimer *animationTimer;//动画定时器

}

@end
@interface MyVoiceRecog : VoiceRecog
{
    MNGSearchDeviceForConfigNetViewController *viewController;
}
- (id)init:(MNGSearchDeviceForConfigNetViewController *)_ui vdpriority:(VDPriority)_vdpriority;
@end

@implementation MNGSearchDeviceForConfigNetViewController

int otherfreqs[] = {15000,15200,15400,15600,15800,16000,16200,16400,16600,16800,17000,17200,17400,17600,17800,18000,18200,18400,18600};


-(DeviceConfigEnteryWay)enterWay
{
    return privateEnterWay;
}

-(id)initWithEnterWay:(DeviceConfigEnteryWay)enterWay;
{
    if ([self init]) {
        privateEnterWay = enterWay;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    [DeviceManageHandler deviceGetServerIpAndPortByImei:_deviceModel.imei Success:^(id obj) {
//        if ([obj isKindOfClass:[NSDictionary class]]) {
//            ipAddress = obj[@"ip"];
//            port = obj[@"port"];
//        }
//        
//    } Failed:^(id obj) {
//        
//    }];

    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(-20, 20,60, 40)];
    [btn setImage:[UIImage imageNamed:@"arrowleft"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 45)];
    
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    backScorllView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height-64)];
    backScorllView.delaysContentTouches = NO;
    [self.view addSubview:backScorllView];
    self.title = @"搜索设备";
    messageArr = [NSMutableArray array];
    //    NSString *sn = @"1121409000121";
    NSString *sn = _deviceModel.imei;
    if (sn.length>6) {
        deviceSN = [sn substringFromIndex:sn.length-6];
        searchMessageContent = [NSString stringWithFormat:@"70%@",deviceSN];
    }else
    {
        return;
    }
    [self createUI];
    
}

-(void)back:(UIBarButtonItem*)item
{
    [sendPlayer stop];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createRecognizeAndPlayer
{
    AVAudioSession *mySession = [AVAudioSession sharedInstance];
    [mySession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [mySession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
 
//
    
    int base = baseFrequence;
    for (int i = 0; i < sizeof(otherfreqs)/sizeof(int); i ++) {
        otherfreqs[i] = base + i * 200;
    }
    receiveRecog = [[MyVoiceRecog alloc] init:self vdpriority:VD_MemoryUsePriority];
    [receiveRecog setFreqs:otherfreqs freqCount:sizeof(otherfreqs)/sizeof(int)];
    
    sendPlayer=[[VoicePlayer alloc] init];
    [sendPlayer setFreqs:otherfreqs freqCount:sizeof(otherfreqs)/sizeof(int)];
    
//    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
//    UISlider* volumeViewSlider = nil;
//    for (UIView *view in [volumeView subviews]){
//        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
//            volumeViewSlider = (UISlider*)view;
//            break;
//        }
//    }
//    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
//        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
//            if (granted) {
//                // Microphone enabled code
//                NSLog(@"Microphone is enabled..");
//            }
//            else {
//                // Microphone disabled code
//                NSLog(@"Microphone is disabled..");
//                
//                // We're in a background thread here, so jump to main thread to do UI work.
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [[[UIAlertView alloc] initWithTitle:@"麦克风拒绝访问"
//                                                 message:@"麦克风被拒绝访问,您将收不到设备的声音回应,你仍然可以继续配置"
//                                                delegate:nil
//                                       cancelButtonTitle:@"确定"
//                                       otherButtonTitles:nil] show];
//                });
//            }
//        }];
//    }
//    [volumeViewSlider setValue:1.0f animated:NO];
    [sendPlayer setVolume:0.999];
    
}
-(void)createUI
{
//    UIView *setpButtomV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TableHeadHeight)];
    
    
    CGFloat TableHeadHeight = [MRJSizeManager mrjTableHeadHeight];
    CGFloat VERTICAL_SAPCE = [MRJSizeManager mrjHorizonPaddding];
    CGFloat LEFT_PADDING = [MRJSizeManager mrjHorizonPaddding];
    
    
    UILabel *stepLabel = [[UILabel alloc]initWithFrame:CGRectMake([MRJSizeManager mrjHorizonPaddding], 0, SCREEN_WIDTH-20, [MRJSizeManager mrjTableHeadHeight])];
    stepLabel.text = @"操作步骤";
    stepLabel.font = [MRJSizeManager mrjMiddleTextFont];
    stepLabel.textColor = [MRJColorManager mrj_secondaryTextColor];
    [backScorllView addSubview:stepLabel];
    UIView *setpButtomV = [[UIView alloc]initWithFrame:CGRectMake(0, stepLabel.height+stepLabel.y, SCREEN_WIDTH, 3*TableHeadHeight+VERTICAL_SAPCE*2)];
    setpButtomV.backgroundColor = [MRJColorManager mrj_navigationTextColor];
    NSArray *stepsArr = @[@"1.连接设备电源",@"2.等待绿灯快闪",@"3.点击搜索开始搜索设备"];
    for (int x=0; x<3; x++)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_PADDING, TableHeadHeight*x+VERTICAL_SAPCE, SCREEN_WIDTH-LEFT_PADDING, TableHeadHeight)];
        [setpButtomV addSubview:label];
        label.text = stepsArr[x];
        label.textColor = [MRJColorManager mrj_mainTextColor];
    }
    [backScorllView addSubview:setpButtomV];
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_PADDING,setpButtomV.height+setpButtomV.y , SCREEN_WIDTH-20, 25)];
    tipLabel.text = @"温馨提示";
    tipLabel.font = [MRJSizeManager mrjMiddleTextFont];
    tipLabel.textColor = [MRJColorManager mrj_secondaryTextColor];
    [backScorllView addSubview:tipLabel];
    
    UIView *tipButtomV = [[UIView alloc]initWithFrame:CGRectMake(0, tipLabel.height+tipLabel.y, SCREEN_WIDTH, TableHeadHeight*2+VERTICAL_SAPCE*2)];
    tipButtomV.backgroundColor = [MRJColorManager mrj_navigationTextColor];
    [backScorllView addSubview:tipButtomV];
    NSArray *tipsArr = @[@"1.手机不能处于静音模式",@"2.确保手机离设备保持在0.5米以内"];
//    CGFloat height = tipLabel.frame.size.height+tipLabel.frame.origin.y;
    for (int x=0; x<tipsArr.count; x++)
    {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_PADDING,VERTICAL_SAPCE+TableHeadHeight*x, SCREEN_WIDTH-LEFT_PADDING, TableHeadHeight)];
        [tipButtomV addSubview:label];
        NSString *origStr = tipsArr[x];
        CGRect rect = [origStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 60) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[MRJSizeManager mrjMainTextFont]} context:nil];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:origStr attributes:@{NSFontAttributeName:[MRJSizeManager mrjMainTextFont],NSForegroundColorAttributeName:[MRJColorManager mrj_mainTextColor]}];
        label.attributedText = str;
//        label.size = CGSizeMake(rect.size.width, rect.size.height);
//        if (label.size.height>20) {
//            height+=label.size.height;
//        }else
//        {
//             height+=20;
//        }
        if(x==1)
        {
            NSString *targetStr = @"0.5米";
            
//            [str addAttributes:@{NSForegroundColorAttributeName:ButtonColor} range:[origStr rangeOfString:targetStr]];
            label.attributedText = str;
            lastTipsLab = label;
            lastTipHeight = tipButtomV.height+tipButtomV.y+[MRJSizeManager mrjHorizonPaddding];
        }
        
    }
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2,tipButtomV.height+tipButtomV.y+80, 80, 80)];
    btn.centerY = tipButtomV.height+tipButtomV.y+(SCREEN_HEIGHT-(tipButtomV.height+tipButtomV.y))/3.f;
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
//    [btn setTitleColor:MainTextColor forState:UIControlStateNormal];
    [btn setTitle:@"取消" forState:UIControlStateSelected];
//    [btn setTitleColor:PlainButtonColor forState:UIControlStateSelected];
    CALayer *buttomLayer = [[CALayer alloc]initWithLayer:btn.layer];
    [btn.layer addSublayer:buttomLayer];
    
    waveLayer = [CALayer layer];
    btn.layer.cornerRadius = 40;
    btn.layer.borderWidth = 2;
//    btn.layer.borderColor = [MainTextColor CGColor];
    [backScorllView addSubview:btn];
    [btn addTarget:self action:@selector(sendSearchMessage:) forControlEvents:UIControlEventTouchUpInside];
    searchBtn = btn;
    
//    failV = [[UIView alloc]initWithFrame:CGRectMake(LEFT_PADDING, searchBtn.frame.size.height+searchBtn.frame.origin.y+TOP_PADDING, SCREEN_WIDTH-LEFT_PADDING*2, SCREEN_HEIGHT-(searchBtn.frame.size.height+searchBtn.frame.origin.y-TOP_PADDING))];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, failV.width, 20)];
    NSString *str =[NSString stringWithFormat:@"未搜索到设备"];
//    NSMutableAttributedString *mutableAttributeStr = [[NSMutableAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:MainTextColor,NSFontAttributeName:MainTitleFont}];
    NSRange range = [str rangeOfString:_deviceModel.imei];
//    [mutableAttributeStr addAttributes:@{NSForegroundColorAttributeName:ButtonColor,NSFontAttributeName:MiddleTextFont} range:range];
//    label1.attributedText = mutableAttributeStr;
    label1.textAlignment = NSTextAlignmentCenter;
    [failV addSubview:label1];
    
    NSString *str2 = @"如果在搜索过程中设备发出了声音，也可以点击【下一步】去配置设备网络";
    UILabel *label = [[UILabel alloc]init];
//    NSMutableAttributedString *mutableAttributeStr2 = [[NSMutableAttributedString alloc]initWithString:str2 attributes:@{NSForegroundColorAttributeName:SecondaryTextColor,NSFontAttributeName:MiddleTextFont}];
//    CGRect  rect = [str2 boundingRectWithSize:CGSizeMake(failV.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName:DefaultTableSectionHeaderColor,NSFontAttributeName:MiddleTextFont} context:NULL];
//    label.numberOfLines = 0;
//    label.lineBreakMode = NSLineBreakByCharWrapping;
//    label.attributedText = mutableAttributeStr2;
//    [label sizeToFit];
//    label.frame = CGRectMake(0, label1.height+10, rect.size.width, rect.size.height);
//    label.textAlignment = NSTextAlignmentCenter;
////    [failV addSubview:label];
////
//    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SMALLBUTTON_WIDTH, 40)];
//    nextBtn.layer.cornerRadius = 5;
////    nextBtn.clipsToBounds = YES;
////    [nextBtn setBackgroundImage:[AppUtils buttonImageFromColor:ButtonColor andSize:nextBtn.size] forState:UIControlStateNormal];
//
//    nextBtn.x = (failV.width-nextBtn.width)/2;
//    nextBtn.y = label.y+label.height+8;
//    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
//    [nextBtn setTitleColor:NavigationTextColor forState:UIControlStateNormal];
//    [nextBtn addTarget:self action:@selector(nextOperation:) forControlEvents:UIControlEventTouchUpInside];
//    [failV addSubview:nextBtn];
//    if (failV.height+failV.y>backScorllView.height) {
//        backScorllView.contentSize = CGSizeMake(SCREEN_WIDTH,failV.height+failV.y+64);
//    }
    backScorllView.delaysContentTouches = NO;
    
}
-(void)searchSuccessForNextOperation:(UIView *)view;
{
    [successV removeFromSuperview];
    [view removeFromSuperview];
    [self nextOperation:nil];
}
-(void)nextOperation:(id)sender
{
//    if(!ipAddress||!port)
//    {
//        [AppUtils showProgressMessageWithNotAllowTouch:TEXT_NETWORK_PROCESS];
//        [DeviceManageHandler deviceGetServerIpAndPortByImei:_deviceModel.imei Success:^(id obj) {
//            if([obj isKindOfClass:[NSDictionary class]])
//            {
//                [AppUtils dismissHUD];
//                ipAddress = obj[@"ip"];
//                port = obj[@"port"];
//                if (ipAddress&&port) {
//                    if ([AFNetworkReachabilityManager sharedManager].reachableViaWiFi) {
//                        MNGDeviceNetConfigViewController *configVC = [[MNGDeviceNetConfigViewController alloc]init];
//                        configVC.serverIp = ipAddress;
//                        configVC.serverPort  = port;
//                        configVC.enterWay = self.enterWay;
//                        configVC.deviceModel = _deviceModel;
//                        [self.navigationController safetyPushViewController:configVC animated:YES];
//                    }
//                    else
//                    {
//                        [AppUtils showErrorMessage:@"请将手机网络切换至设备所连接的Wi-Fi网络"];
//                        searchBtn.hidden = NO;
//                        searchBtn.selected = NO;
//                        searchBtn.layer.borderColor = [MainTextColor CGColor];
//                    }
//                }else
//                {
//                    
//                }
//            }else
//            {
//              [AppUtils showErrorMessage:obj];
//            }
//            
//        } Failed:^(id obj) {
//            [AppUtils showErrorMessage:obj];
//        }];
//    }else
//    {
//        if ([AFNetworkReachabilityManager sharedManager].reachableViaWiFi) {
//            MNGDeviceNetConfigViewController *configVC = [[MNGDeviceNetConfigViewController alloc]init];
//            configVC.serverIp = ipAddress;
//            configVC.serverPort = port;
//            configVC.enterWay = self.enterWay;
//            configVC.deviceModel = _deviceModel;
//            [self.navigationController safetyPushViewController:configVC animated:YES];
//        }
//        else
//        {
//            [AppUtils showErrorMessage:@"请将手机切换至即将为设备所连接的WI-FI网络"];
//            searchBtn.hidden = NO;
//            searchBtn.selected = NO;
//            searchBtn.layer.borderColor = [MainTextColor CGColor];
//        }
//    }
    
    
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createRecognizeAndPlayer];
    [receiveRecog start];
    searchBtn.hidden = NO;
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [receiveRecog stop];
    searchBtn.selected = NO;
//    searchBtn.layer.borderColor = [MainTextColor CGColor];
    receiveRecog = nil;
    sendPlayer = nil;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)scaleBegin
{
    if (!waveLayer.superlayer) {
        return;
    }
    const float maxScale=3.5;
    if (waveLayer.transform.m11<maxScale) {
        if (waveLayer.transform.m11==1.0) {
            [waveLayer setTransform:CATransform3DMakeScale(1.05, 1.05, 1.0)];
            
        }else{
            [waveLayer setTransform:CATransform3DScale(waveLayer.transform, 1.05, 1.05, 1.0)];
        }
    }else{
        [waveLayer removeFromSuperlayer];
        CATransform3D t =  CATransform3DIdentity;
        waveLayer.transform = t;
        
        [self performSelector:@selector(initAnimation) withObject:nil afterDelay:0.5];
    }
}
-(void)initAnimation
{
    [searchBtn.layer insertSublayer:waveLayer atIndex:1];
//     [searchBtn.layer addSublayer:waveLayer];
}
- (void)sendSearchMessage:(UIButton*)sender {
    sender.selected = !sender.selected;
//    if (sender.selected == YES) {
//        sender.layer.borderColor = [PlainButtonColor CGColor];
//        [myTimer invalidate];
//        myTimer = nil;
//        myTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(sendCMDMessage) userInfo:nil repeats:YES];
//        waveLayer.frame = sender.bounds;
//        waveLayer.cornerRadius =40;
//        waveLayer.backgroundColor = [[AppUtils colorWithHexString:@"#dadada"] CGColor];
//        [sender.layer insertSublayer:waveLayer atIndex:1];
//        [myTimer fire];
//        
//        [animationTimer invalidate];
//        animationTimer = nil;
//        animationTimer =[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(scaleBegin) userInfo:nil repeats:YES];
//        [animationTimer fire];
//    }else
//    {
//        waveLayer.transform = CATransform3DIdentity;
//        [waveLayer removeFromSuperlayer];
//        [animationTimer invalidate];
//        animationTimer = nil;
//        
//        [sendPlayer stop];
//        sender.layer.borderColor = [MainTextColor CGColor];
//        [myTimer invalidate];
//        myTimer = nil;
//        sendCount = 0;
//    }
//    if (!searchMessageContent) {
//        return;
//    }

    
}
-(void)sendCMDMessage
{
    
    if (failV.superview) {
        [failV removeFromSuperview];
    }
    if (sendCount<1)//
    {
        [sendPlayer playString:searchMessageContent playCount:1 muteInterval:0];
        shoulSendNext = NO;
        sendCount++;
    }
    else
    {
        [animationTimer invalidate];
        animationTimer = nil;
        waveLayer.transform = CATransform3DIdentity;
        [waveLayer removeFromSuperlayer];
        
        
        sendCount = 0;
        searchBtn.selected = NO;
//        searchBtn.layer.borderColor = [MainTextColor CGColor];
        [myTimer invalidate];
        myTimer = nil;
        [backScorllView  addSubview:failV];

    }
   
}
- (void) onRecognizerStart
{
    printf("------------------recognize start\n");
}
- (void) onRecognizerEnd:(int)_result data:(char *)_data dataLen:(int)_dataLen
{
    NSString *msg = nil;
    char s[100];
    if (_result == VD_SUCCESS)
    {
        printf("------------------recognized data:%s\n", _data);
        enum InfoType infoType = vr_decodeInfoType(_data, _dataLen);
        if(infoType == IT_STRING)
        {
            vr_decodeString(_result, _data, _dataLen, s, sizeof(s));
            printf("string:%s\n", s);
            msg = [NSString stringWithFormat:@"%s", s];
        }
        else
        {
            printf("------------------recognized data:%s\n", _data);
            msg = [NSString stringWithFormat:@"%s", _data];
        }
    }
    else
    {
//        printf("------------------recognize invalid data, errorCode:%d, error:%s\n", _result, recorderRecogErrorMsg(_result));
    }
    if(msg != nil)[self performSelectorOnMainThread:@selector(dealLogic:) withObject:msg waitUntilDone:NO];
}
-(void)dealLogic:(NSString*)_msg
{
    if (deviceSN.length<2) {
        return;
    }
    NSString *sn = [deviceSN substringFromIndex:deviceSN.length-2];
    if ([sn isEqualToString:_msg])//说明收到成功回应,发送下一条
    {
        [myTimer invalidate];
        myTimer = nil;
        [animationTimer invalidate];
        animationTimer = nil;
        [waveLayer removeFromSuperlayer];
        waveLayer.transform = CATransform3DIdentity;
        [successV removeFromSuperview];
        successV = [[ MNGSearchDeviceSuccessView alloc]initWithFrame:CGRectMake(0, lastTipHeight, 320-60, 320-60) andDeviceSnNumber:_deviceModel.imei deviceAlias:_deviceModel.alias deviceMacAddress:_deviceModel.wifi];
        successV.centerX = SCREEN_WIDTH/2;
        successV.userInteractionEnabled = YES;
        successV.delegate = self;
        UIButton *btn = [[UIButton alloc]initWithFrame:successV.bounds];
        [successV addSubview:btn];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(searchSuccessForNextOperation:) forControlEvents:UIControlEventTouchUpInside];
        [backScorllView addSubview:successV];
        searchBtn.hidden = YES;
        sendCount = 0;
        
        
    }
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
//-(NSString *)packageMessageWithCmd:(NSString*)cmd deviceSN:(NSString*)snNumber contentData:(NSString*)content
//{
//    NSString *str = [cmd stringByAppendingFormat:@"0%@%@",snNumber,content];
//    return str;
//}
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
