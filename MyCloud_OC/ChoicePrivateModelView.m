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
//    [IQKeyboardManager sharedManager].enable = YES;
    CGFloat INPUT_HEIGHT = [MRJSizeManager mrjInputSizeHeight];
    CGFloat LEFT_PADDING = [MRJSizeManager mrjHorizonPaddding];
    CGFloat TOP_PADDING = [MRJSizeManager mrjVerticalPadding];
    //小背景部分
//    self.backgroundColor = [UIColor clearColor];
    UIView *mainV = [[UIView alloc]init];
    [self addSubview:mainV];
    [mainV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(LEFT_PADDING);
        make.height.mas_equalTo(4*INPUT_HEIGHT+TOP_PADDING);
        make.centerY.mas_equalTo(self.centerY);
    }];
    mainV.backgroundColor = [MRJColorManager mrj_mainBackgroundColor];
    mainV.layer.cornerRadius = [MRJSizeManager mrjButtonCornerRadius];
    
    //标题
    UILabel *titileLab = [[UILabel alloc]init];
    titileLab.textAlignment = NSTextAlignmentCenter;
    titileLab.text = [LoginRegistStringValueContentManager languageValueForKey:language_login_serviceAddress];
    titileLab.textColor = [MRJColorManager mrj_mainTextColor];
    [mainV addSubview:titileLab];
    [titileLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(titileLab.superview.centerX);
        make.centerY.mas_equalTo(@(INPUT_HEIGHT/2));
//        make.top.mas_equalTo(TOP_PADDING);
    }];
    UIView *toplineV = [[UIView alloc]init];
    [mainV addSubview:toplineV];
    [toplineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(mainV.mas_width);
        make.height.mas_equalTo([MRJSizeManager mrjSepritorHeight]);
        make.top.mas_equalTo(INPUT_HEIGHT);
        make.centerX.mas_equalTo(mainV.mas_centerX);
    }];
    
    NSArray *arr = @[[LoginRegistStringValueContentManager languageValueForKey:language_login_serviceAddressPlacement]];
    
    for (int x=0; x<arr.count; x++) {
        MRJTextField *tf = [[MRJTextField alloc]initWithFrame:CGRectMake(LEFT_PADDING, TOP_PADDING+titileLab.height+INPUT_HEIGHT*x, mainV.width-LEFT_PADDING*2, INPUT_HEIGHT)];
        tf.placeholder = arr[x];
        if (x==0) {
            tf.keyboardType = UIKeyboardTypeASCIICapable;
            _ipTextField = tf;
        }else
        {
            tf.keyboardType = UIKeyboardTypeNumberPad;
            _portTextField = tf;
        }
        [mainV addSubview:tf];
    }
    

    
    
    //按钮部分
    UIView *seprateV = [[UIView alloc]initWithFrame:CGRectMake(0, mainV.height-INPUT_HEIGHT-1, mainV.width, 0.5)];//分割线
    seprateV.backgroundColor = [MRJColorManager mrj_separatrixColor];
    [mainV addSubview:seprateV];
    UIButton *cancelBtn  = [[UIButton alloc]initWithFrame:CGRectMake(0, mainV.height-INPUT_HEIGHT, (mainV.width-2)/2, INPUT_HEIGHT)];
    [cancelBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[MRJColorManager mrj_mainTextColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[MRJColorManager mrj_separatrixColor] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:[LoginRegistStringValueContentManager languageValueForKey:language_login_cancelBtnName] forState:UIControlStateNormal];
    
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(mainV.width/2, mainV.height-INPUT_HEIGHT, 0.5, INPUT_HEIGHT)];
    lineV.backgroundColor = [MRJColorManager mrj_separatrixColor];;
    [mainV addSubview:lineV];
    UIButton *confirmBtn  = [[UIButton alloc]initWithFrame:CGRectMake(mainV.width/2, mainV.height-INPUT_HEIGHT, (mainV.width-2)/2, INPUT_HEIGHT)];
    [confirmBtn setTitleColor:[MRJColorManager mrj_mainTextColor] forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[MRJColorManager mrj_separatrixColor] forState:UIControlStateHighlighted];
    [confirmBtn setTitle:[LoginRegistStringValueContentManager languageValueForKey:language_login_confirmBtnName] forState:UIControlStateNormal];

    [confirmBtn addTarget:self action:@selector(confirmTestValid:) forControlEvents:UIControlEventTouchUpInside];
    [mainV addSubview:cancelBtn];
    [mainV addSubview:confirmBtn];
    
}
-(void)dismiss:(UIButton*)btn
{
    if ([_delegate respondsToSelector:@selector(cancelOperation:)]) {
        [_delegate cancelOperation:self];
    }
}
-(void)confirmTestValid:(UIButton*)btn
{
    //发送验证请求
//    if (![AppUtils isValidatIP:_ipTextField.text]) {
//        [AppUtils showErrorMessage:@"请输入合法的ip地址"];
//        return;
//    }
//    if (!([_portTextField.text integerValue]>0&&[_portTextField.text integerValue]<65535)) {
//         [AppUtils showErrorMessage:@"请输入合法的端口"];
//        return;
//    }
//    NSString *url = [NSString stringWithFormat:@"http://%@:%@/app",_ipTextField.text,_portTextField.text];
//   __block NSString *heartBeatUrl = [NSString stringWithFormat:@"%@/heart.do",url];
//    [DeviceManageHandler deviceHeartBeatTestWithUrlString:heartBeatUrl Success:^(id obj) {
//        if ([obj isKindOfClass:[NSDictionary class]]) {
//            [AppUtils showSuccessMessage:@"连接私有云服务器成功"];
//            [APPSinglton shareInstance].environmentUrl = url;
//            [APPSinglton shareInstance].myCloudIP = _ipTextField.text;
//            [APPSinglton shareInstance].myCloudPort = _portTextField.text;
//            if ([_delegate respondsToSelector:@selector(operationCompleted:withResult:)]) {
//                [_delegate operationCompleted:self withResult:nil];
//            }
//        }else
//        {
//            [AppUtils showErrorMessage:@"连接私有云服务器失败，请检查服务器地址是否正确，或者手机和服务器是否在同一个网络"];
//        }
//    } Failed:^(id obj) {
//        [AppUtils showErrorMessage:@"连接私有云服务器失败，请检查服务器地址是否正确，或者手机和服务器是否在同一个网络"];
//    }];
}

@end
