//
//  DeviceParameterViewController.m
//  EachPlan
//
//  Created by 申巧 on 15/7/8.
//  Copyright (c) 2015年 XiaoZhou. All rights reserved.
//

#import "DeviceParameterViewController.h"
#import "UIView+Frame.h"
#import "DeviceModel.h"
#import "SelectInstallHeightViewController.h"
#import "UIButton+MRJButton.h"
#import "HomeStringKeyContentValueManager.h"
#import "HomeResourceManager.h"
static const int totolTimer = 60;
static const float BASE_WIDTH = 352;
static const float BASE_HEIGHT = 288;
static const float SLIDE_HEIGHT = 15;
@interface DeviceParameterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int consumeTimer;
    MRJBaseTableview *table;
}

@end
@implementation DeviceParameterViewController
{
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceParamTitle];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:[StringKeyContentValueManager languageValueForKey:language_commen_confirmBtnName] style:UIBarButtonItemStylePlain target:self action:@selector(saveInstallHeight:)];
    item.tintColor = NavigationTextColor;
    self.navigationItem.rightBarButtonItem = item;
    
    table = [[MRJBaseTableview alloc]init];
    
    table.delegate = self;
    table.dataSource = self;
    table.scrollEnabled = NO;
    [self.backScrollView addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(table.superview);
        make.left.mas_equalTo(table.superview);
        make.centerX.mas_equalTo(table.superview);
        make.height.mas_equalTo(INPUT_HEIGHT);
    }];
    

    UILabel *label = [[UILabel alloc]init];
    label.text = [HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceParamWidthNoticeText];
    label.textColor = SecondaryTextColor;
    label.numberOfLines = 0;
    label.preferredMaxLayoutWidth = MIN(SCREEN_WIDTH, SCREEN_HEIGHT)-LEFT_PADDING*2;
    label.font = [MRJSizeManager mrjsmallTextFont];
    label.textAlignment = NSTextAlignmentCenter;
     [self.backScrollView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(table.mas_bottom).offset(TOP_PADDING);
        make.left.mas_equalTo(label.superview).offset(LEFT_PADDING);
        make.centerX.mas_equalTo(label.superview);
    }];

    cameraImage = [[UIImageView alloc] init];
    cameraImage.backgroundColor = [UIColor whiteColor];
    [cameraImage setImageWithURL:[NSURL URLWithString:_deviceModel.imagePath] options:YYWebImageOptionShowNetworkActivity];
    [self.backScrollView addSubview:cameraImage];
    [cameraImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(MIN(SCREEN_WIDTH, SCREEN_HEIGHT)-LEFT_PADDING*2, 250));
        make.centerX.mas_equalTo(cameraImage.superview.centerX);
        make.top.mas_equalTo(label.mas_bottom).offset(TOP_PADDING);
    }];
    
    rangeSlider = [[WLRangeSlider alloc]initWithFrame:CGRectMake(LEFT_PADDING, 250/2, MIN(SCREEN_WIDTH, SCREEN_HEIGHT)-LEFT_PADDING*2, SLIDE_HEIGHT)];
    rangeSlider.trackHighlightTintColor = MainThemeColor;
    rangeSlider.trackColor = NavigationTextColor;
    rangeSlider.thumbColor = SeparatrixColor;
    rangeSlider.delegate = self;
    rangeSlider.leftValue = 0;
    rangeSlider.rightValue = 1;
    [self.backScrollView addSubview:rangeSlider];
    leftValue = rangeSlider.leftValue;
    rightValue = rangeSlider.rightValue;
    topValue = 250/2;
    

    [rangeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cameraImage.mas_left);
        make.centerX.mas_equalTo(cameraImage.mas_centerX);
        make.centerY.mas_equalTo(cameraImage.mas_centerY);
        make.width.mas_equalTo(cameraImage);
        make.height.mas_equalTo(SLIDE_HEIGHT);
    }];
    arrowImage = [[UIImageView alloc]initWithImage:[HomeResourceManager home_deviceParamArrow]];
    arrowImage.userInteractionEnabled = YES;
    [self.backScrollView addSubview:arrowImage];
    [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(rangeSlider.mas_centerY);
        make.left.mas_equalTo(cameraImage.mas_right);
    }];
    UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveSliderFrame:)];
    [arrowImage addGestureRecognizer:panGestureRecognizer];
    if (_deviceModel.rule.allowGrap) {
        UILabel *label1 = [[UILabel alloc]init];
        label1.font = MiddleTextFont;
        label1.textColor = MainTextColor;
        label1.text = [HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceParamCamaraImageNoticeText];
        [self.backScrollView addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cameraImage.mas_centerX).offset(0);
            make.top.mas_equalTo(cameraImage.mas_bottom).offset(TOP_PADDING);
        }];
        catchImageBtn = [UIButton mrj_generalBtnTitle:[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceParamCaptureCurrentImageButtonName] normalTitleColor:PlainButtonColor highlightTitleColor:SeparatrixColor normalBackImage:nil highlightBackImage:nil];
        catchImageBtn.titleLabel.font = MiddleTextFont;
        [catchImageBtn addTarget:self action:@selector(catchRealTimeImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.backScrollView addSubview:catchImageBtn];
        [catchImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label1.mas_right);
            make.centerY.mas_equalTo(label1.mas_centerY);
        }];
    }


    resetDefaultBtn = [UIButton mrj_generalBtnTitle:[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceParamResetDefaultButtonName]  normalTitleColor:NavigationTextColor highlightTitleColor:SeparatrixColor normalBackImage:[MRJResourceManager buttonImageFromColor:MainThemeColor andSize:CGSizeMake(MIN(SCREEN_WIDTH, SCREEN_HEIGHT)-LEFT_PADDING*2, INPUT_HEIGHT)] highlightBackImage:nil];
    [resetDefaultBtn addTarget:self action:@selector(resetDefaultHeight:) forControlEvents:UIControlEventTouchUpInside];
    [self.backScrollView addSubview:resetDefaultBtn];
    [resetDefaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(resetDefaultBtn.superview.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(MIN(SCREEN_WIDTH, SCREEN_HEIGHT)-LEFT_PADDING*2, INPUT_HEIGHT));
        if (catchImageBtn) {
            make.top.mas_equalTo(catchImageBtn.mas_bottom).offset(TOP_PADDING);
        }else
        {
            make.top.mas_equalTo(cameraImage.mas_bottom).offset(TOP_PADDING);
        }
        
    }];
    [self.backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(resetDefaultBtn.mas_bottom).offset(TOP_PADDING*2);
    }];
    
    
    [RACObserve(_deviceModel,height) subscribeNext:^(id height){
//        _deviceModel.installHeight = intstallHeight;
        [table reloadData];
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self modifyInstallHeight:nil];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    BaseTableViewCell *cell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:indentifier_cellIdentifier];
    if (!cell) {
        cell = [[BaseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier_cellIdentifier];
    }
    [cell configMainTableViewCellStyleWithText:[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceParamInstallHeightMenuName] andDetailText:_deviceModel.installHeight cellSize:CGSizeMake(0, 0) disclosureIndicator:YES selectHighlight:YES];
    return cell;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 0;
//}
- (void)loadData{
//    [DeviceManageHandler deviceParamsDetailWithDeviceId:_deviceModel.deviceId Success:^(id obj) {
//        if ([obj isKindOfClass:[DeviceModel class]]) {
//            [AppUtils dismissHUD];
//            DeviceModel *model = obj;
//            _deviceModel.installPara = model.installPara;
//            if ([_deviceModel.lens isEqualToString:@"1"]) {
//                if (_deviceModel.installPara.height == 0) {
//                    _deviceModel.installHeight = @"2.6米以下";
//                }else if (_deviceModel.installPara.height == 1){
//                    _deviceModel.installHeight = @"2.6~2.8米";
//                }else if (_deviceModel.installPara.height == 2){
//                    _deviceModel.installHeight = @"2.8米以上";
//                }
//            }else if ([_deviceModel.lens isEqualToString:@"2"]){
//                if (_deviceModel.installPara.height == 0) {
//                    _deviceModel.installHeight = @"3.2米以下";
//                }else if (_deviceModel.installPara.height == 1){
//                    _deviceModel.installHeight = @"3.2~3.4米";
//                }else if (_deviceModel.installPara.height == 2){
//                    _deviceModel.installHeight = @"3.4米以上";
//                }
//            }else if ([_deviceModel.lens isEqualToString:@"3"]){
//                if (_deviceModel.installPara.height == 0) {
//                    _deviceModel.installHeight = @"3.5米以下";
//                }else if (_deviceModel.installPara.height == 1){
//                    _deviceModel.installHeight = @"3.5~3.8米";
//                }else if (_deviceModel.installPara.height == 2){
//                    _deviceModel.installHeight = @"3.8米以上";
//                }
//            }
//            if ([_deviceModel.lens isEqualToString:@"1"]) {
//                heightArray = @[@"2.6米以下",@"2.6~2.8米",@"2.8米以上"];
//            }else if ([_deviceModel.lens isEqualToString:@"2"]){
//                heightArray = @[@"3.2米以下",@"3.2~3.4米",@"3.4米以上"];
//            }else if ([_deviceModel.lens isEqualToString:@"3"]){
//                heightArray = @[@"3.5米以下",@"3.5~3.8米",@"3.8米以上"];
//            }
//            height = [NSString stringWithFormat:@"%d",_deviceModel.installPara.height+2];
//            rangeSlider.centerY = cameraImage.y+cameraImage.height*(_deviceModel.installPara.topPoint/(float)BASE_HEIGHT);
//            topValue = rangeSlider.centerY-cameraImage.y;
//            arrowImage.centerY = rangeSlider.centerY;
//            rangeSlider.leftValue = (float)((float)_deviceModel.installPara.leftPoint/(float)BASE_WIDTH);
//            rangeSlider.rightValue = (float)((float)_deviceModel.installPara.rightPoint/(float)BASE_WIDTH);
//            leftValue = rangeSlider.leftValue;
//            rightValue = rangeSlider.rightValue;
//            [table reloadData];
//            
//            
//        }else{
//            [AppUtils showErrorMessage:obj];
//        }
//    } Failed:^(id obj) {
//        [AppUtils showErrorMessage:TEXT_SERVER_NOT_RESPOND];
//    }];
}

#pragma RefreshCallback
-(void)selectedHeightComplete:(id)callback{
    if ([callback isKindOfClass:[NSDictionary class]]) {
        _deviceModel.installHeight = callback[@"height"];
        _deviceModel.height = callback[@"value"];
        height = _deviceModel.height;
        [table reloadData];
    }
}



#pragma WLRangeSliderDelegate
-(void)leftValue:(float)left rightValue:(float)right{
    leftValue = left;
    rightValue = right;
}

-(void)moveSliderFrame:(UIPanGestureRecognizer *)recognizer{
    CGPoint translation = [recognizer translationInView:self.backScrollView];
    CGFloat padding = recognizer.view.center.y + translation.y;
    
    if (padding > cameraImage.y+cameraImage.height) {
        padding = cameraImage.y+cameraImage.height;
    }else if (padding < cameraImage.y){
        padding = cameraImage.y;
    }
    
    recognizer.view.centerY = padding;
    rangeSlider.y = padding-7;
    [recognizer setTranslation:CGPointZero inView:self.backScrollView];
    topValue = padding-cameraImage.y;
}

-(void)modifyInstallHeight:(UIButton *)sender{
    SelectInstallHeightViewController *installHeight = [[SelectInstallHeightViewController alloc] init];
    installHeight.deviceModel = _deviceModel;
    [self.navigationController safetyPushViewController:installHeight animated:YES];
}

- (void)excultePara{
    leftPoint = leftValue*cameraImage.width;
    rightPoint = rightValue*cameraImage.width;
    leftPoint = leftPoint*(float)BASE_WIDTH/cameraImage.width;
    rightPoint = (int)((float)rightPoint*(float)BASE_WIDTH/cameraImage.width);
    
    topPoint = topValue;
    bottomPoint = topPoint;
    topPoint = topPoint*BASE_HEIGHT/cameraImage.height;
    bottomPoint = bottomPoint*BASE_HEIGHT/cameraImage.height;
    
    //如果重合
    if (rightPoint == leftPoint) {
        if (rightPoint == BASE_WIDTH) {
            rightPoint = rightPoint-1;
            leftPoint = leftPoint-2;
        }else if (rightPoint == 0){
            leftPoint = leftPoint+1;
            rightPoint = rightPoint+2;
        }else{
            if (rightPoint == BASE_WIDTH-1) {
                leftPoint = leftPoint-1;
            }else{
                rightPoint = rightPoint+1;
            }
        }
    }
    else{
        //不重合
        if (leftPoint == 0) {
            leftPoint = 1;
            if (rightPoint == 1) {
                rightPoint = rightPoint+1;
            }
        }
        if (rightPoint == BASE_WIDTH) {
            rightPoint = rightPoint-1;
            if (leftPoint == rightPoint) {
                leftPoint = leftPoint-1;
            }
        }
    }
    if (topPoint == 0) {
        topPoint = 1;
    }
    if (bottomPoint == BASE_HEIGHT) {
        bottomPoint = bottomPoint-1;
    }
    bottomPoint = topPoint;
    
    //扩大2/3之后
    boxLeft = leftPoint-(leftPoint*2/3);
    boxRight = rightPoint+((BASE_WIDTH-rightPoint)*2/3);
    boxTop = topPoint-(topPoint*2/3);
    boxBottom = bottomPoint+((BASE_HEIGHT-bottomPoint)*2/3);
    
    if (boxRight == boxLeft) {
        if (boxRight == BASE_WIDTH) {
            boxRight = boxRight-1;
            boxLeft = boxLeft-2;
        }else if (boxRight == 0){
            boxLeft = boxLeft+1;
            boxRight = boxRight+2;
        }else{
            if (boxRight == BASE_WIDTH-1) {
                boxLeft = boxLeft-1;
            }else{
                boxRight = boxRight+1;
            }
        }
    }
    else{
        if (boxLeft == 0) {
            boxLeft = 1;
            if (boxRight == 1) {
                boxRight = boxRight+1;
            }
        }
        if (boxRight == BASE_WIDTH) {
            boxRight = boxRight-1;
            if (boxLeft == boxRight) {
                boxLeft = boxLeft-1;
            }
        }
    }
    
    if (boxTop == 0) {
        boxTop = 1;
    }
    if (boxBottom == BASE_HEIGHT) {
        boxBottom = boxBottom-1;
    }
}

-(void)saveInstallHeight:(UIButton *)sender{
//    if ([UserDefaultsUtils boolValueWithKey:IDENTITY] == YES){
//        [AppUtils showInfoMessage:@"当前是演示账号不能做提交操作"];
//        return;
//    }
//
//    [self excultePara];
//    
//    UserEntity *entity = [UserDefaultsUtils customerObjectWithKey:USER_ENTITY];
//    if (height==nil) {
//        return;
//    }
//    NSDictionary *para = @{@"deviceId":_deviceModel.deviceId==nil?@"":_deviceModel.deviceId,@"taskcreateid":entity.accountId==nil?@"":entity.accountId,@"taskcreator":entity.accountId==nil?@"":entity.accountId,@"leftPoint":@((int)leftPoint),@"rightPoint":@((int)rightPoint),@"topPoint":@((int)topPoint),@"bottomPoint":@((int)bottomPoint),@"boxleft":@(boxLeft),@"boxright":@((int)boxRight),@"boxtop":@((int)boxTop),@"boxbottom":@((int)boxBottom),@"direction":@(0),@"height":height,@"init":@(0)};
//   
//    [DeviceManageHandler updateDeviceParaWithParaDetail:para Success:^(id obj) {
//        if ([obj isKindOfClass:[NSDictionary class]]) {
//            [AppUtils dismissHUD];
//            
//            if ([_delegate respondsToSelector:@selector(updateDeviceMsg:)]) {
//                [_delegate updateDeviceMsg:nil];
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//        }else{
//            [AppUtils showErrorMessage:obj];
//        }
//    } Failed:^(id obj) {
//        [AppUtils showErrorMessage:TEXT_SERVER_NOT_RESPOND];
//    }];
}

-(void)catchRealTimeImage:(UIButton *)sender{
//    if ([UserDefaultsUtils boolValueWithKey:IDENTITY] == YES){
//        [AppUtils showInfoMessage:@"当前是演示账号不能做提交操作"];
//        return;
//    }
//    UserEntity *entity = [UserDefaultsUtils customerObjectWithKey:USER_ENTITY];
//    [DeviceManageHandler catchRealTimeImageWithDeviceId:_deviceModel.deviceId taskCreateId:entity.accountId taskCreator:entity.accountId Success:^(id obj) {
//        if ([obj isKindOfClass:[NSDictionary class]]) {
//            snId = obj[@"result"];
//            [self getNowImage];
//            [AppUtils showProgressMessageWithNotAllowTouch:@"正在获取实时图片..."];
//            [timer invalidate];
//            timer = nil;
//            timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(getNowImage) userInfo:nil repeats:YES];
//            [timer fire];
//            consumeTimer = 0;
//        }else{
//            [AppUtils showErrorMessage:obj];
//        }
//    } Failed:^(id obj) {
//        [AppUtils showErrorMessage:TEXT_SERVER_NOT_RESPOND];
//    }];
}
-(void)getNowImage
{
//    if (consumeTimer>=totolTimer) {
//        [AppUtils dismissHUD];
//        [AppUtils showErrorMessage:@"抓取超时,请重新试试"];
//        [[SQHttpHelper sharedHttpManager]cancelNetworkRequest];
//        [timer invalidate];
//        timer = nil;
//        consumeTimer = 0;
//        return;
//    }
//    consumeTimer ++;
//    [DeviceManageHandler getDeviceNowImageWithSnId:snId Success:^(id obj) {
//        if ([obj isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *result = obj;
//            if ([result[@"msg"] isEqualToString:@"成功"]) {
//                [cameraImage sd_setImageWithURL:[NSURL URLWithString:obj[@"result"]]];
//                [AppUtils dismissHUD];
//                [[SQHttpHelper sharedHttpManager]cancelNetworkRequest];
//                [timer invalidate];
//                timer = nil;
//            }
//        }
//    } Failed:^(id obj) {
//        [AppUtils showErrorMessage:obj];
//    }];
    
}
-(void)resetDefaultHeight:(UIButton *)sender{
//    if ([UserDefaultsUtils boolValueWithKey:IDENTITY] == YES){
//        [AppUtils showInfoMessage:@"当前是演示账号不能做提交操作"];
//        return;
//    }

    
    
    
    rangeSlider.centerY = cameraImage.y+cameraImage.height/2;
    arrowImage.centerY = rangeSlider.centerY;
    rangeSlider.leftValue = 0;
    rangeSlider.rightValue = 1;
    _deviceModel.installHeight = heightArray[1];
    [table reloadData];
//    installHeightBtn.rightTitle =

    height = @"3";
    leftValue = 0;
    rightValue = 1;
    topValue = cameraImage.height/2;
    [self excultePara];
}


@end
