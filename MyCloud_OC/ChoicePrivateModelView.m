//
//  ChoicePrivateModelView.m
//  EachPlan
//
//  Created by ZEROLEE on 15/10/20.
//  Copyright (c) 2015年 XiaoZhou. All rights reserved.
//

#import "ChoicePrivateModelView.h"
#import "UIView+additions.h"
#import "LoginRegistStringValueContentManager.h"
#import "LoginRegistHttpHandler.h"
#import "MRJCheckUtils.h"

NSString * const httpHeadFlagString = @"http://";
NSString * const httpsHeadFlagString = @"https://";
NSString * const appSubPath = @"/app/";
@implementation ChoicePrivateModelView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
     Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
-(void)setup
{
    CGFloat INPUT_HEIGHT = [MRJSizeManager mrjInputSizeHeight];
    CGFloat LEFT_PADDING = [MRJSizeManager mrjHorizonPaddding];
    CGFloat TOP_PADDING = [MRJSizeManager mrjVerticalPadding];
    //小背景部分
//    self.backgroundColor = [UIColor clearColor];
    UIView *mainV = [[UIView alloc]init];
    [self addSubview:mainV];
    [mainV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(LEFT_PADDING);
        make.right.mas_equalTo(self).offset(-LEFT_PADDING);
        make.height.mas_equalTo(3*INPUT_HEIGHT+TOP_PADDING);
        make.center.mas_equalTo(self);
    }];
    mainV.backgroundColor = [MRJColorManager mrj_mainBackgroundColor];
    mainV.layer.cornerRadius = [MRJSizeManager mrjButtonCornerRadius];
    
   // 标题
    UILabel *titileLab = [[UILabel alloc]init];
    titileLab.textAlignment = NSTextAlignmentCenter;
    titileLab.text = [LoginRegistStringValueContentManager languageValueForKey:language_login_serviceAddress];
    titileLab.textColor = [MRJColorManager mrj_mainTextColor];
    [mainV addSubview:titileLab];
    [titileLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mainV).offset(TOP_PADDING/2);
        make.centerX.mas_equalTo(mainV.mas_centerX);
    }];
    UIView *toplineV = [[UIView alloc]init];
    toplineV.backgroundColor = [MRJColorManager mrj_separatrixColor];
    [mainV addSubview:toplineV];
    [toplineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mainV).offset(INPUT_HEIGHT);
        make.width.mas_equalTo(mainV.mas_width);
        make.height.mas_equalTo([MRJSizeManager mrjSepritorHeight]);
        make.centerX.mas_equalTo(mainV.mas_centerX);
    }];
//
    _serviceAddressTF = [[MRJTextField alloc]init];
    _serviceAddressTF.text = [AppSingleton shareInstace].inputEnvironmentURL;
    [mainV addSubview:_serviceAddressTF];
    _serviceAddressTF.keyboardType = UIKeyboardTypeASCIICapable;
    _serviceAddressTF.placeholder = [LoginRegistStringValueContentManager languageValueForKey:language_login_serviceAddressPlacement];
    
    [_serviceAddressTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainV).offset(LEFT_PADDING);
        make.right.equalTo(mainV).offset(-LEFT_PADDING);
        make.height.mas_equalTo(INPUT_HEIGHT);
        make.center.mas_equalTo(mainV);
    }];
//    //按钮部分
    UIView *seprateV = [[UIView alloc]init];//分割线
    seprateV.backgroundColor = [MRJColorManager mrj_separatrixColor];
    
    [mainV addSubview:seprateV];
    [seprateV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([MRJSizeManager mrjSepritorHeight]);
        make.width.mas_equalTo(mainV.mas_width);
        make.centerX.mas_equalTo(mainV.mas_centerX);
        make.top.equalTo(_serviceAddressTF.mas_bottom).offset(TOP_PADDING/2);
    }];
    //按钮中间分割线
    UIView *lineV = [[UIView alloc]init];
    lineV.backgroundColor = [MRJColorManager mrj_separatrixColor];;
    [mainV addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(mainV);
        make.width.mas_equalTo([MRJSizeManager mrjSepritorHeight]);
        make.top.equalTo(seprateV.mas_bottom).offset(1);
        make.bottom.equalTo(mainV).offset(-1);
    }];
    UIButton *cancelBtn  = [[UIButton alloc]init];
    [cancelBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[MRJColorManager mrj_mainTextColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[MRJColorManager mrj_separatrixColor] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:[LoginRegistStringValueContentManager languageValueForKey:language_login_cancelBtnName] forState:UIControlStateNormal];
    [mainV addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(seprateV.mas_bottom).offset(1);
        make.left.equalTo(mainV);
        make.right.equalTo(lineV.mas_left);
        make.bottom.equalTo(mainV).with.offset(-[MRJSizeManager mrjSepritorHeight]);
        
    }];
    
    
    UIButton *confirmBtn  = [[UIButton alloc]init];
    [mainV addSubview:confirmBtn];
    confirmBtn.enabled = NO;
    [confirmBtn setTitleColor:[MRJColorManager mrj_separatrixColor] forState:UIControlStateDisabled];
    [confirmBtn setTitleColor:[MRJColorManager mrj_mainTextColor] forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[MRJColorManager mrj_separatrixColor] forState:UIControlStateHighlighted];
    [confirmBtn setTitle:[LoginRegistStringValueContentManager languageValueForKey:language_login_confirmBtnName] forState:UIControlStateNormal];

    [confirmBtn addTarget:self action:@selector(confirmTestValid:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cancelBtn.mas_top);
        make.bottom.equalTo(cancelBtn.mas_bottom);
        make.left.equalTo(lineV.mas_right);
        make.right.equalTo(mainV);
    }];
    RACSignal *noContentSignal = [_serviceAddressTF.rac_textSignal map:^id(id value) {
        return @(_serviceAddressTF.text.length>0);
    }];
    [noContentSignal subscribeNext:^(id x) {
        confirmBtn.enabled = [x boolValue];
    }];
}
-(void)dismiss:(UIButton*)btn
{
    if ([_delegate respondsToSelector:@selector(cancelOperation:)]) {
        [_delegate cancelOperation:self];
    }
}
-(void)confirmTestValid:(UIButton*)btn
{
    NSString *baseUrl= nil;
    if (_serviceAddressTF.text.length==0) {
        return;
    }
    if ([_serviceAddressTF.text hasPrefix:httpHeadFlagString]) {
        baseUrl = [NSString stringWithFormat:@"%@/%@",_serviceAddressTF.text,appSubPath];
    }else if ([_serviceAddressTF.text hasPrefix:httpsHeadFlagString])
    {
        baseUrl = [NSString stringWithFormat:@"%@/%@",_serviceAddressTF.text,appSubPath];
    }else
    {
        baseUrl  = [NSString stringWithFormat:@"%@%@%@",httpHeadFlagString,_serviceAddressTF.text,appSubPath];
    }
    [LoginRegistHttpHandler login_checkHeartBeatFullURL:[NSString stringWithFormat:@"%@%@",baseUrl,api_loginRegist_heart_beat] preExecute:^{
        [MRJCheckUtils showProgressMessageWithNotAllowTouch:language_commen_waitProgressNotice];
    } successBlock:^(id obj) {
        [MRJCheckUtils showSuccessMessage:language_login_connectServiceSuccessNotice];
        [AppSingleton shareInstace].inputEnvironmentURL = _serviceAddressTF.text;
        [AppSingleton shareInstace].environmentUrl = baseUrl;
        if ([_delegate respondsToSelector:@selector(operationCompleted:withResult:)]) {
            [_delegate operationCompleted:self withResult:nil];
        }
    } failedBlock:^(id obj) {
        [MRJCheckUtils showErrorMessage:language_login_connectServiceFailNotice];
    }];
}

@end
