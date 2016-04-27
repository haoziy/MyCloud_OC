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
#import "AFNetworkReachabilityManager.h"
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
    UIView *btnButtomV;
    
    DeviceConfigEnteryWay privateEnterWay;
    UIButton *searchBtn;
    CGFloat lastTipHeight;//最后一个温馨提示的位置
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
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

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
    
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                // Microphone enabled code
                NSLog(@"Microphone is enabled..");
            }
            else {
                // Microphone disabled code
                NSLog(@"Microphone is disabled..");
                
                // We're in a background thread here, so jump to main thread to do UI work.
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:@"麦克风拒绝访问"
                                                 message:@"麦克风被拒绝访问,您将收不到设备的声音回应,你仍然可以继续配置"
                                                delegate:nil
                                       cancelButtonTitle:@"确定"
                                       otherButtonTitles:nil] show];
                });
            }
        }];
    }
    [volumeViewSlider setValue:1.0f animated:NO];
    [sendPlayer setVolume:0.999];
    
}
-(void)createUI
{
    
    
    self.backScrollView.backgroundColor = [MRJColorManager mrj_mainBackgroundColor];
    CGFloat TableHeadHeight = [MRJSizeManager mrjTableHeadHeight];
    CGFloat VERTICAL_SAPCE = [MRJSizeManager mrjVerticalSpace];
    CGFloat LEFT_PADDING = [MRJSizeManager mrjHorizonPaddding];
    UIView *setpButtomV = [[UIView alloc]init];
    setpButtomV.backgroundColor = [MRJColorManager mrj_mainBackgroundColor];
    [self.backScrollView addSubview:setpButtomV];
    [setpButtomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(setpButtomV.superview).offset(0);
        make.left.equalTo(setpButtomV.superview.mas_left);
        make.centerX.equalTo(setpButtomV.superview.mas_centerX);
        make.height.mas_equalTo(TableHeadHeight);
    }];
    
    UILabel *stepLabel = [[UILabel alloc]init];
    stepLabel.text = @"操作步骤";
    stepLabel.font = [MRJSizeManager mrjMiddleTextFont];
    stepLabel.textColor = [MRJColorManager mrj_secondaryTextColor];
    [setpButtomV addSubview:stepLabel];
    [stepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(stepLabel.superview).offset([MRJSizeManager mrjHorizonPaddding]);
        make.centerY.mas_equalTo(stepLabel.superview.mas_centerY);
    }];
//    [self.backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        // 让scrollview的contentSize随着内容的增多而变化
//        make.bottom.mas_equalTo(setpButtomV.mas_bottom).offset(-VERTICAL_SAPCE);
//    }];
    UIView *setpOrderButtomV = [[UIView alloc]init];
    setpOrderButtomV.backgroundColor = [MRJColorManager mrj_navigationTextColor];
    [self.backScrollView addSubview:setpOrderButtomV];
    [setpOrderButtomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(3*TableHeadHeight+VERTICAL_SAPCE*2);
        make.top.mas_equalTo(setpButtomV.mas_bottom);
        make.left.equalTo(setpOrderButtomV.superview.mas_left);
        make.centerX.equalTo(setpOrderButtomV.superview.mas_centerX);
        
    }];
    NSArray *stepsArr = @[@"1.连接设备电源",@"2.等待绿灯快闪",@"3.点击搜索开始搜索设备"];
    UILabel *placementLabel=nil;//参照物;
    for (int x=0; x<3; x++)
    {
        
        UILabel *label = [[UILabel alloc]init];
        
        [setpOrderButtomV addSubview:label];
        label.text = stepsArr[x];
        label.textColor = [MRJColorManager mrj_mainTextColor];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(setpOrderButtomV).offset(LEFT_PADDING);
            if (placementLabel) {
                make.top.mas_equalTo(placementLabel.mas_bottom);
            }else
            {
                make.top.mas_equalTo(VERTICAL_SAPCE);
            }
            
            make.height.mas_equalTo(TableHeadHeight);
        }];

        placementLabel = label;
    
    }
    
    UIView *tipButtomV = [[UIView alloc]init];
    [self.backScrollView addSubview:tipButtomV];
    tipButtomV.backgroundColor = [MRJColorManager mrj_mainBackgroundColor];
    [tipButtomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(setpOrderButtomV.mas_bottom);
        make.height.mas_equalTo(TableHeadHeight);
        make.centerX.mas_equalTo(tipButtomV.superview.mas_centerX);
        make.left.equalTo(tipButtomV.superview);
        
    }];
    
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"温馨提示";
    tipLabel.font = [MRJSizeManager mrjMiddleTextFont];
    tipLabel.textColor = [MRJColorManager mrj_secondaryTextColor];
    [tipButtomV addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tipButtomV.centerY);
        make.left.mas_equalTo(LEFT_PADDING);
    }];
    
    UIView *tipOrderButtomV = [[UIView alloc]init];
    [self.backScrollView addSubview:tipOrderButtomV];
    tipOrderButtomV.backgroundColor = [MRJColorManager mrj_navigationTextColor];
    [tipOrderButtomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipButtomV.mas_bottom);
        make.height.mas_equalTo(TableHeadHeight*2+VERTICAL_SAPCE*2);
        make.centerX.equalTo(tipOrderButtomV.superview.mas_centerX);
        make.left.equalTo(tipOrderButtomV.superview);
    }];
    NSArray *tipsArr = @[@"1.手机不能处于静音模式",@"2.确保手机离设备保持在0.5米以内"];
    UILabel *tipPlacementLable;
    for (int x=0; x<tipsArr.count; x++)
    {
        UILabel *label = [[UILabel alloc]init];
        [tipOrderButtomV addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(LEFT_PADDING);
            if (tipPlacementLable) {
                make.top.mas_equalTo(tipPlacementLable.mas_bottom);
            }else
            {
                make.top.mas_equalTo(VERTICAL_SAPCE);
            }
            make.height.mas_equalTo(TableHeadHeight);
            
        }];
        tipPlacementLable = label;
        NSString *origStr = tipsArr[x];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:origStr attributes:@{NSFontAttributeName:[MRJSizeManager mrjMainTextFont],NSForegroundColorAttributeName:[MRJColorManager mrj_mainTextColor]}];
        label.attributedText = str;
        if(x==1)
        {
            NSString *targetStr = @"0.5米";
            
            [str addAttributes:@{NSForegroundColorAttributeName:[MRJColorManager mrj_mainThemeColor]} range:[origStr rangeOfString:targetStr]];
            label.attributedText = str;
            lastTipsLab = label;
            lastTipHeight = tipButtomV.height+tipButtomV.y+[MRJSizeManager mrjHorizonPaddding];
        }
        
    }
//
    
    btnButtomV = [[UIView alloc]init];
    [self.backScrollView addSubview:btnButtomV];
    [btnButtomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipOrderButtomV.mas_bottom).offset(VERTICAL_SAPCE);
        make.left.mas_equalTo(btnButtomV.superview);
        make.centerX.mas_equalTo(btnButtomV.superview.mas_centerX);
    }];
    
    
    UIButton *btn = [[UIButton alloc]init];
    [btnButtomV addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.center.mas_equalTo(btnButtomV);
    }];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setTitleColor:[MRJColorManager mrj_mainTextColor] forState:UIControlStateNormal];
    [btn setTitle:@"取消" forState:UIControlStateSelected];
    [btn setTitleColor:[MRJColorManager mrj_plainColor] forState:UIControlStateSelected];
    CALayer *buttomLayer = [[CALayer alloc]initWithLayer:btn.layer];
    [btn.layer addSublayer:buttomLayer];
    
    waveLayer = [CALayer layer];
    btn.layer.cornerRadius = 40;
    btn.layer.borderWidth = 2;
    btn.layer.borderColor = [[MRJColorManager mrj_mainTextColor]  CGColor];
    [btn addTarget:self action:@selector(sendSearchMessage:) forControlEvents:UIControlEventTouchUpInside];
    searchBtn = btn;
//
    failV = [[UIView alloc]init];
    [btnButtomV addSubview:failV];
    [failV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(searchBtn.mas_bottom).offset(VERTICAL_SAPCE);
        make.bottom.equalTo(btnButtomV).offset(-VERTICAL_SAPCE);
        make.left.mas_equalTo(failV.superview);
        make.centerX.mas_equalTo(failV.superview);
    }];
//
    UILabel *label1 = [[UILabel alloc]init];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [MRJColorManager mrj_mainTextColor];
    NSString *str =[NSString stringWithFormat:@"未搜索到设备"];
    label1.text = str;
    [failV addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(label1.superview.mas_centerX);
        make.top.mas_equalTo(label1.superview);
    }];
//
    NSString *str2 = @"如果在搜索过程中设备发出了声音，也可以点击【下一步】去配置设备网络";
    UILabel *label2 = [[UILabel alloc]init];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [MRJColorManager mrj_separatrixColor];
    label2.font = [MRJSizeManager mrjMiddleTextFont];
    label2.preferredMaxLayoutWidth = SCREEN_WIDTH-LEFT_PADDING*2;
    label2.lineBreakMode = NSLineBreakByWordWrapping;
    label2.numberOfLines = 0;
    [failV addSubview:label2];
    label2.text = str2;
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label1.mas_bottom).offset(VERTICAL_SAPCE);
        make.left.mas_equalTo(label2.superview).offset(LEFT_PADDING);
        make.centerX.mas_equalTo(label2.superview);
    }];
//
    UIButton *nextBtn = [[UIButton alloc]init];
    nextBtn.layer.cornerRadius = [MRJSizeManager mrjButtonCornerRadius];
    nextBtn.clipsToBounds = YES;
    [nextBtn setBackgroundImage:[MRJResourceManager buttonImageFromColor:[MRJColorManager mrj_mainThemeColor] andSize:CGSizeMake(100, [MRJSizeManager mrjInputSizeHeight])] forState:UIControlStateNormal];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[MRJColorManager mrj_navigationTextColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextOperation:) forControlEvents:UIControlEventTouchUpInside];
    [failV addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 44));
        make.top.equalTo(label2.mas_bottom).offset(VERTICAL_SAPCE);
        make.centerX.equalTo(failV);
        make.bottom.mas_equalTo(failV).offset(-VERTICAL_SAPCE);
    }];
    failV.hidden = YES;

    [self.backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 让scrollview的contentSize随着内容的增多而变化
        make.bottom.mas_equalTo(btnButtomV.mas_bottom);
    }];
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
////        [MRJCheckUtils showProgressMessageWithNotAllowTouch:@""];
////        [DeviceManageHandler deviceGetServerIpAndPortByImei:_deviceModel.imei Success:^(id obj) {
////            if([obj isKindOfClass:[NSDictionary class]])
////            {
////                [AppUtils dismissHUD];
////                ipAddress = obj[@"ip"];
////                port = obj[@"port"];
////                if (ipAddress&&port) {
////                    if ([AFNetworkReachabilityManager sharedManager].reachableViaWiFi) {
////                        MNGDeviceNetConfigViewController *configVC = [[MNGDeviceNetConfigViewController alloc]init];
////                        configVC.serverIp = ipAddress;
////                        configVC.serverPort  = port;
////                        configVC.enterWay = self.enterWay;
////                        configVC.deviceModel = _deviceModel;
////                        [self.navigationController safetyPushViewController:configVC animated:YES];
////                    }
////                    else
////                    {
////                        [AppUtils showErrorMessage:@"请将手机网络切换至设备所连接的Wi-Fi网络"];
////                        searchBtn.hidden = NO;
////                        searchBtn.selected = NO;
////                        searchBtn.layer.borderColor = [MainTextColor CGColor];
////                    }
////                }else
////                {
////                    
////                }
////            }else
////            {
////              [AppUtils showErrorMessage:obj];
////            }
////            
////        } Failed:^(id obj) {
////            [AppUtils showErrorMessage:obj];
////        }];
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
//            [MRJCheckUtils showErrorMessage:@"请将手机切换至即将为设备所连接的WI-FI网络"];
//            searchBtn.hidden = NO;
//            searchBtn.selected = NO;
//            searchBtn.layer.borderColor = [[MRJColorManager mrj_mainTextColor] CGColor];
//        }
//    }
//    if ([AFNetworkReachabilityManager sharedManager].reachableViaWiFi) {
//        MNGDeviceNetConfigViewController *configVC = [[MNGDeviceNetConfigViewController alloc]init];
//        configVC.serverIp = ipAddress;
//        configVC.serverPort = port;
//        configVC.enterWay = self.enterWay;
//        configVC.deviceModel = _deviceModel;
//        [self.navigationController safetyPushViewController:configVC animated:YES];
//    }
//    else
//    {
//        [MRJCheckUtils showErrorMessage:@"请将手机切换至即将为设备所连接的WI-FI网络"];
//        searchBtn.hidden = NO;
//        searchBtn.selected = NO;
//        searchBtn.layer.borderColor = [[MRJColorManager mrj_mainTextColor] CGColor];
//    }
    
    MNGDeviceNetConfigViewController *configVC = [[MNGDeviceNetConfigViewController alloc]init];
    configVC.serverIp = ipAddress;
    configVC.serverPort = port;
    configVC.enterWay = self.enterWay;
    configVC.deviceModel = _deviceModel;
    [self.navigationController safetyPushViewController:configVC animated:YES];
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
    searchBtn.layer.borderColor = [[MRJColorManager mrj_mainTextColor] CGColor];
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
}
- (void)sendSearchMessage:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        sender.layer.borderColor = [[MRJColorManager mrj_plainColor] CGColor];
        [myTimer invalidate];
        myTimer = nil;
        myTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(sendCMDMessage) userInfo:nil repeats:YES];
        waveLayer.frame = sender.bounds;
        waveLayer.cornerRadius =40;
        waveLayer.backgroundColor = [[UIColor colorWithHexString:@"#dadada"] CGColor];
        [sender.layer insertSublayer:waveLayer atIndex:1];
        [myTimer fire];
        
        [animationTimer invalidate];
        animationTimer = nil;
        animationTimer =[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(scaleBegin) userInfo:nil repeats:YES];
        [animationTimer fire];
    }else
    {
        waveLayer.transform = CATransform3DIdentity;
        [waveLayer removeFromSuperlayer];
        [animationTimer invalidate];
        animationTimer = nil;
        
        [sendPlayer stop];
        sender.layer.borderColor = [[MRJColorManager mrj_mainTextColor] CGColor];
        [myTimer invalidate];
        myTimer = nil;
        sendCount = 0;
    }
    if (!searchMessageContent) {
        return;
    }

    
}
-(void)sendCMDMessage
{
    
    failV.hidden  = YES;
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
        searchBtn.layer.borderColor = [[MRJColorManager mrj_mainTextColor] CGColor];
        [myTimer invalidate];
        myTimer = nil;
        failV.hidden = NO;
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
        [self searchSuccess];
    }
}
-(void)searchSuccess
{
    [successV removeFromSuperview];
    successV = [[ MNGSearchDeviceSuccessView alloc]initWithFrame:CGRectMake(0, 0, 320-60, 320-60) andDeviceSnNumber:_deviceModel.imei deviceAlias:_deviceModel.alias deviceMacAddress:_deviceModel.wifi];
    successV.center = searchBtn.center;
    successV.userInteractionEnabled = YES;
    successV.delegate = self;
    UIButton *btn = [[UIButton alloc]initWithFrame:successV.bounds];
    [successV addSubview:btn];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(searchSuccessForNextOperation:) forControlEvents:UIControlEventTouchUpInside];
    [btnButtomV addSubview:successV];
    searchBtn.hidden = YES;
    sendCount = 0;
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
