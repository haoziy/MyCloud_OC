//
//  BaseViewController.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/6.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "BaseViewController.h"
#import "DeBugLog.h"
NSString* const indentifier_cellIdentifier = @"cell";
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(returnFront:)];
    [self.navigationItem setBackBarButtonItem:item];
//    [self.navigationController.navigationBar setBarTintColor:NavigationTextColor];
    [self.navigationController.navigationBar setTintColor:NavigationTextColor];
    self.view.backgroundColor = [MRJColorManager mrj_mainBackgroundColor];
    _backScrollView = [[MRJScrollView alloc]init];
    [self.view addSubview:_backScrollView];
    _backScrollView.showsHorizontalScrollIndicator = NO;
    _backScrollView.showsVerticalScrollIndicator  = NO;
    [_backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)returnFront:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    [DeBugLog debugLog:NSStringFromClass([self class]) line:__LINE__ otherInfo:@"release"];
}
@end
