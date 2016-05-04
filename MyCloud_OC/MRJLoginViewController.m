//
//  MRJLoginViewController.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/8.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "MRJLoginViewController.h"
#import "LoginRegistStringValueContentManager.h"
#import "LoginRegistResourceManager.h"
#import "ChoicePrivateModelView.h"
#import "LoginRegistHttpHandler.h"
#import "HomeDeviceManagerViewController.h"

@interface MRJLoginViewController ()<ChoicePrivateModelViewDelegate>
{

    MRJTextField *loginAccountTF;
    MRJTextField *loginPassTF;
    
    UIButton *loginBtn;
//    ChoicePrivateModelView *choiceServiceAddressV;
}

@end

@implementation MRJLoginViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(void)viewDidAppear:(BOOL)animated
{
    if ([AppSingleton currentEnvironmentBaseURL]==nil) {
        [self setupPrivateCloudAddress:nil];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:[LoginRegistStringValueContentManager loginRegistLanguageValueForKey:language_login_serviceBtnName] style:UIBarButtonItemStylePlain target:self action:@selector(setupPrivateCloudAddress:)];
    self.navigationItem.rightBarButtonItem.tintColor = [MRJColorManager mrj_navigationTextColor];
    
    self.title = [LoginRegistStringValueContentManager loginRegistLanguageValueForKey:language_login_title];
    CGFloat height = [MRJSizeManager mrjInputSizeHeight];
    CGFloat pading = [MRJSizeManager mrjHorizonPaddding];
    for (int i = 0; i<2; i++) {
        UIImageView *img = nil;
        MRJTextField *tf = [[MRJTextField alloc]init];
        [self.backScrollView addSubview:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(@((height)*i+pading));
            make.height.mas_equalTo(@(height));
            make.centerX.mas_equalTo(tf.superview.mas_centerX);
            make.left.mas_equalTo(pading);
            make.right.mas_equalTo(pading);
            
        }];
        if (i==0) {
            img = [[UIImageView alloc]initWithImage:[LoginRegistResourceManager accountIconImage]];
            loginAccountTF = tf;
            tf.text = [AppSingleton shareInstace].lastLoginMobileOrEmail;
            tf.placeholder = [LoginRegistStringValueContentManager loginRegistLanguageValueForKey:language_login_accountPlacement];
        }else
        {
            img = [[UIImageView alloc]initWithImage:[LoginRegistResourceManager passwordIconImage]];
            
            loginPassTF = tf;
            tf.secureTextEntry = YES;
            tf.placeholder = [LoginRegistStringValueContentManager loginRegistLanguageValueForKey:language_login_passwordPlacement];
        }
        
        
        
        [tf addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(img.superview);
            make.left.mas_equalTo(0);
        }];
        tf.startLocation = pading;
    }
    
    UIButton *btn = [[UIButton alloc]init];
    loginBtn = btn;
    btn.clipsToBounds = YES;
    
    [btn setBackgroundImage:[MRJResourceManager buttonImageFromColor:[MRJColorManager mrj_secondaryTextColor] andSize:CGSizeMake(SCREEN_WIDTH-pading*2, height)] forState:UIControlStateDisabled];

    [btn setEnabled:NO];
    [btn setBackgroundImage:[MRJResourceManager buttonImageFromColor:[MRJColorManager mrj_mainThemeColor] andSize:CGSizeMake(SCREEN_WIDTH-pading*2, height)] forState:UIControlStateNormal];
    
    btn.layer.cornerRadius = [MRJSizeManager mrjButtonCornerRadius];
    [btn setTitle:[LoginRegistStringValueContentManager loginRegistLanguageValueForKey:language_login_title] forState:UIControlStateNormal];
    [self.backScrollView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginPassTF.mas_bottom).with.offset(pading*5);
        make.centerX.mas_equalTo(btn.superview);
        make.height.mas_equalTo(height);
        make.left.mas_equalTo(pading);
        make.right.mas_equalTo(pading);
    }];
    
    [self.backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 让scrollview的contentSize随着内容的增多而变化
        make.bottom.mas_equalTo(btn.mas_bottom).offset(-pading);
    }];
    RACSignal *loginSignal = [loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside];

    [loginSignal subscribeNext:^(id x) {
        [LoginRegistHttpHandler login_loginWithParams:@{@"username":loginAccountTF.text, @"password":loginPassTF.text,@"identify":@"0"} preExecute:^{
            //
        } successBlock:^(id obj) {
            if([obj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dict = (NSDictionary*)obj;
                if ([dict[request_status_key] integerValue]==0 ) {
                    [AppSingleton shareInstace].lastLoginMobileOrEmail = loginAccountTF.text;
                    [AppSingleton shareInstace].accountId = dict[@"data"][@"accountId"];
                    
                    HomeDeviceManagerViewController*  deviceManagerVC = [[HomeDeviceManagerViewController alloc]init];
                    self.navigationController.viewControllers = @[deviceManagerVC];
                }
            }
            
        } failedBlock:^(id obj) {
            HomeDeviceManagerViewController*  deviceManagerVC = [[HomeDeviceManagerViewController alloc]init];
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:deviceManagerVC];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
        } ];
    }];
    
    RACSignal *validUsernameSignal =
    [loginAccountTF.rac_textSignal
     map:^id(NSString *text) {
         return @([MRJStringCheckUtil checkPhoneNumber:text]||[MRJStringCheckUtil isValidateEmail:text]||text.length>0);
     }];
    RACSignal *validPassSingal = [loginPassTF.rac_textSignal
                                  map:^id(NSString *text) {
                                      return @(text.length>0);
                                  }];
    
    RACSignal *activeSignal =
    [RACSignal combineLatest:@[validUsernameSignal,validPassSingal]
                      reduce:^id(NSNumber *validAccount,NSNumber *validPass){
        return @([validAccount boolValue]&&[validPass boolValue]);
    }];

    [activeSignal subscribeNext:^(NSNumber*signupActive){
        loginBtn.enabled =[signupActive boolValue];
    }];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupPrivateCloudAddress:(id)sender
{
    [self.view endEditing:YES];
    ChoicePrivateModelView *choiceServiceAddressV;
    if (!choiceServiceAddressV)
    {
        choiceServiceAddressV = [[ChoicePrivateModelView alloc]init];
        choiceServiceAddressV.delegate = self;
        choiceServiceAddressV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
    }
    [self.view addSubview:choiceServiceAddressV];
    [choiceServiceAddressV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.navigationController.navigationBar.userInteractionEnabled = NO;
}
-(void)loginPressed:(id)sender
{
    
}
-(void)cancelOperation:(ChoicePrivateModelView*)view;
{
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    [view removeFromSuperview];
    
}
-(void)operationCompleted:(ChoicePrivateModelView*)view withResult:(NSData*)data;
{
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    [view removeFromSuperview];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)dealloc
{
    NSLog(@"%@ release",[self class]);
}
@end
