//
//  MRJLoginViewController.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/8.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "MRJLoginViewController.h"
#import "LoginRegistStringValueContentManager.h"

@interface MRJLoginViewController ()

@end

@implementation MRJLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [LoginRegistStringValueContentManager loginRegistLanguageValueForKey:language_login_title];
    UITextField *accountTF = [[UITextField alloc]init];
    [self.view addSubview:accountTF];
    
    
    
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
