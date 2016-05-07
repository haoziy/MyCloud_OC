//
//  AppDelegate+utils.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/6.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "AppDelegate+utils.h"
#import "MRJStoreManager.h"
#import "SVProgressHUD.h"

NSString *const login_first_install_key = @"login_first_install_key";
@implementation AppDelegate (utils)

-(BOOL)checkFirstInstall
{
    if ([MRJStoreManager boolValueWithKey:login_first_install_key]) {
        return YES;
    }else
    {
        return NO;
    }
}
-(void)app_hudSetting;
{
    //进度条颜色;//dark是暗色;Light是明亮色,custome是自定义
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//    [SVProgressHUD setForegroundColor:[MRJColorManager mrj_mainThemeColor]];
//    [SVProgressHUD setBackgroundColor:[MRJColorManager mrj_mainTextColor]];
//    [SVProgressHUD setBackgroundLayerColor:[MRJColorManager mrj_mainTextColor]];
    //背景颜色;除了None其他都是不可操作
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    //动画效果;Native的showWithStatus是菊花 其他差别不大
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    //显示时间
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    //各种情况的图片
//    [SVProgressHUD setSuccessImage:[UIImage imageNamed:@"chenggong"]];
//    [SVProgressHUD setErrorImage:[UIImage imageNamed:@"chenggong"]];
//     [SVProgressHUD setInfoImage:[UIImage imageNamed:@"chenggong"]];
}
@end
