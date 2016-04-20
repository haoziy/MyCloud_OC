//
//  MRJLoginViewController.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/8.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "MRJLoginViewController.h"
#import "LoginRegistStringValueContentManager.h"
#import "Masonry.h"

@interface MRJLoginViewController ()
{
    UITextField *ipAddressTF;
    UITextField *portTF;
    UITextField *donmainTF;
    UITextField *loginAccountTF;
    UITextField *loginPassTF;
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
//    NSLog(@"%@",self.backScrollView);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [LoginRegistStringValueContentManager loginRegistLanguageValueForKey:language_login_title];
    CGFloat heitght = 32;
    CGFloat pading = 18;
    for (int i = 0; i<5; i++) {
        UITextField *tf = [[UITextField alloc]init];
        self.backScrollView.backgroundColor = [UIColor grayColor];
        [self.backScrollView addSubview:tf];
        tf.backgroundColor = [UIColor redColor];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(@((heitght + pading)*i));
            make.height.mas_equalTo(@(heitght));
            make.centerX.mas_equalTo(tf.superview.mas_centerX);
            make.left.mas_equalTo(pading);
            make.right.mas_equalTo(pading);
            
        }];
        
        
        
        if (i==0) {
            ipAddressTF = tf;
            tf.placeholder = [LoginRegistStringValueContentManager loginRegistLanguageValueForKey:language_login_ipAddressPlacement];
        }else if(i==1)
        {
            portTF = tf;
            tf.placeholder = [LoginRegistStringValueContentManager loginRegistLanguageValueForKey:language_login_portPlacement];
        }
        else if(i==2)
        {
            donmainTF = tf;
            tf.placeholder = [LoginRegistStringValueContentManager loginRegistLanguageValueForKey:language_login_domainPlacement];
        }
        else if(i==3)
        {
            loginAccountTF = tf;
            tf.placeholder = [LoginRegistStringValueContentManager loginRegistLanguageValueForKey:language_login_accountPlacement];
        }
        else
        {
            loginPassTF = tf;
            tf.placeholder = [LoginRegistStringValueContentManager loginRegistLanguageValueForKey:language_login_passwordPlacement];
        }
    }
    
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"denglu" forState:UIControlStateNormal];
    [self.backScrollView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginPassTF.mas_bottom).with.offset(pading*5);
        make.centerX.mas_equalTo(btn.superview);
        make.height.mas_equalTo(heitght*2);
//        make.bottom.mas_equalTo(btn.superview.mas_bottom);
        make.left.mas_equalTo(pading);
        make.right.mas_equalTo(pading);
    }];
    
    [self.backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
        
        // 让scrollview的contentSize随着内容的增多而变化
        make.bottom.mas_equalTo(btn.mas_bottom).offset(20);
    }];
//    [ipAddressTF mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.and.top.mas_equalTo(@(20));
//        make.height.mas_equalTo(@(44));
//    }];
//    
//    [portTF mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.mas_equalTo(ipAddressTF);
//        make.top.mas_equalTo()
//        make.height.mas_equalTo(@(44));
//    }];
    
    
//    ipAddressTF = [[UITextField alloc]init];
//    portTF = [[UITextField alloc]init];
//    donmainTF = [[UITextField alloc]init];
//    loginAccountTF = [[UITextField alloc]init];
//    loginPassTF = [[UITextField alloc]init];
//
//    [self.view addSubview:ipAddressTF];
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
