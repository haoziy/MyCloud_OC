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
#import "HomeHttpHandler.h"
static const int totolTimer = 60;
static const float BASE_WIDTH = 352;
static const float BASE_HEIGHT = 288;
static const float SLIDE_HEIGHT = 15;
@interface DeviceParameterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int consumeTimer;
    MRJBaseTableview *table;
    NSDictionary *param;
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
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
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
    cameraWith = MIN(SCREEN_WIDTH, SCREEN_HEIGHT)-LEFT_PADDING*2;
    cameraHeight = 250;
    
    cameraImage = [[UIImageView alloc] init];
    cameraImage.backgroundColor = [UIColor grayColor];
    [cameraImage setImageWithURL:[NSURL URLWithString:_deviceModel.imagePath] options:YYWebImageOptionShowNetworkActivity];
    [self.backScrollView addSubview:cameraImage];
    [cameraImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(cameraWith, cameraHeight));
        make.centerX.mas_equalTo(cameraImage.superview.centerX);
        make.top.mas_equalTo(label.mas_bottom).offset(TOP_PADDING);
    }];
    
    rangeSlider = [[WLRangeSlider alloc]initWithFrame:CGRectMake(LEFT_PADDING,0, cameraWith, SLIDE_HEIGHT)];
    rangeSlider.trackHighlightTintColor = MainThemeColor;
    rangeSlider.trackColor = NavigationTextColor;
    rangeSlider.thumbColor = SeparatrixColor;
    rangeSlider.delegate = self;
     [self.backScrollView addSubview:rangeSlider];
    
    
    //左右是比例;
    leftValue = (float)((float)_deviceModel.installPara.boxleft/(float)BASE_WIDTH);
    rightValue = (float)((float)_deviceModel.installPara.boxright/(float)BASE_WIDTH);//
    //上下是实际值
    topValue = (_deviceModel.installPara.boxtop/(float)BASE_HEIGHT)*cameraHeight;
    rangeSlider.leftValue = leftValue;
    rangeSlider.rightValue = rightValue;
    
   
    
    
    
    [rangeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cameraImage.mas_left);
        make.centerX.mas_equalTo(cameraImage.mas_centerX);
        make.centerY.mas_equalTo(cameraImage.mas_centerY).offset((topValue-cameraHeight/2));
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
    if (_deviceModel.rule.allowGrap&&_deviceModel.onLine) {
        
        catchImageBtn = [UIButton mrj_generalBtnTitle:[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceParamCaptureCurrentImageButtonName] normalTitleColor:PlainButtonColor highlightTitleColor:SeparatrixColor normalBackImage:nil highlightBackImage:nil];
        catchImageBtn.titleLabel.font = MiddleTextFont;
        [catchImageBtn addTarget:self action:@selector(catchRealTimeImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.backScrollView addSubview:catchImageBtn];
        [catchImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cameraImage.mas_bottom).offset(TOP_PADDING);
            make.right.mas_equalTo(cameraImage.mas_right).offset(0);
        }];
        
        UILabel *label1 = [[UILabel alloc]init];
        label1.font = MiddleTextFont;
        label1.textColor = MainTextColor;
        label1.text = [HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceParamCamaraImageNoticeText];
        [self.backScrollView addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(catchImageBtn);
            make.right.mas_equalTo(catchImageBtn.mas_left);
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
    
    param = @{@"deviceId":_deviceModel.deviceId?_deviceModel.deviceId:@"",@"accountId":[AppSingleton currentUser].accountId?[AppSingleton currentUser].accountId:@""};
    [RACObserve(_deviceModel,height) subscribeNext:^(id height){
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

}

-(void)saveInstallHeight:(UIButton *)sender{
    NSDictionary *dict = @{
                           @"deviceId":_deviceModel.deviceId?_deviceModel.deviceId:@"",
                           @"accountId":[AppSingleton currentUser].accountId?[AppSingleton currentUser].accountId:@"",
                           @"boxLeft":@((int)(leftValue*BASE_WIDTH)),
                           @"boxRight":@((int)(rightValue*BASE_WIDTH)),
                           @"boxTop": @((int)(topValue/cameraHeight*BASE_HEIGHT)),
                           @"boxBottom": @((int)(BASE_HEIGHT-topValue/cameraHeight*BASE_HEIGHT)),
                           @"direction": @(_deviceModel.direction),
                           @"height": _deviceModel.height,
                           };
    _deviceModel.boxLeft = leftValue*BASE_WIDTH;
    _deviceModel.boxRight = rightValue*BASE_WIDTH;
    _deviceModel.boxTop = topValue/cameraHeight*BASE_HEIGHT;
    _deviceModel.boxBottom = BASE_HEIGHT-topValue/cameraHeight*BASE_HEIGHT;
    [HomeHttpHandler home_saveDeviceParams:dict preExecute:^{
        
    } success:^(id obj) {
        if ([obj[request_status_key]integerValue]==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            
        }
    } failed:^(id obj) {
        
    }];
    
}

-(void)catchRealTimeImage:(UIButton *)sender{
    
    [HomeHttpHandler home_captureImageCMD:param preExecute:^{
        
    } success:^(id obj) {
        [self getNowImage];
        [timer invalidate];
        timer = nil;
        timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(getNowImage) userInfo:nil repeats:YES];
        [timer fire];
        consumeTimer = 0;
    } failed:^(id obj) {
        
    }];

}
-(void)stopCatchImage
{
    [timer invalidate];
    timer = nil;
    consumeTimer = 0;
    [MRJAppUtils dismissHUD];
}
-(void)getNowImage
{
    if (consumeTimer>=totolTimer) {
        [self stopCatchImage];
         [MRJAppUtils showErrorMessage:request_network_notwork_notice_message];
        return;
    }
    consumeTimer ++;
    [HomeHttpHandler home_catchImageURL:param preExecute:^{
        
    } success:^(id obj) {
        NSString *url = (NSString*)(obj[request_data_key][@"img"]);
        if (url==nil||[url isEqualToString:_deviceModel.imagePath]) {
            return ;
        }else
        {
            [cameraImage setImageWithURL:[NSURL URLWithString:url] options:YYWebImageOptionShowNetworkActivity];
            _deviceModel.imagePath = url;
            [MRJAppUtils showSuccessMessage:request_operation_success_notice_message];
            [self stopCatchImage];
            
        }
       
    } failed:^(id obj) {
    }];
    
    
}
-(void)resetDefaultHeight:(UIButton *)sender{
    rangeSlider.centerY = cameraImage.y+cameraImage.height/2;
    arrowImage.centerY = rangeSlider.centerY;
    rangeSlider.leftValue = 0;
    rangeSlider.rightValue = 1;
    _deviceModel.installHeight = heightArray[1];
    [table reloadData];


    height = @"3";
    leftValue = 0;
    rightValue = 1;
    topValue = cameraHeight/2;
    [self excultePara];
}


@end
