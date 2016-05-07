//
//  MRJAppUtils+SVProgress.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/5/7.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "MRJAppUtils+SVProgress.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation MRJAppUtils (SVProgress)


/********************* SVProgressHUD **********************/
+ (void)showSuccessMessage:(NSString *)message
{
    [SVProgressHUD showSuccessWithStatus:message];
}

+ (void)showErrorMessage:(NSString *)message
{
    [SVProgressHUD showErrorWithStatus:message];
}

+ (void)showProgressMessage:(NSString *) message
{
    [SVProgressHUD showWithStatus:message];
}

+ (void)showProgressMessageWithNotAllowTouch:(NSString *)message
{
    [SVProgressHUD showWithStatus:message];
}

+ (void)showInfoMessage:(NSString *)message
{
    [SVProgressHUD showInfoWithStatus:message];
}

+ (void)dismissHUD
{
    [SVProgressHUD dismiss];
}

/********************* System Utils **********************/
+ (void)showAlertMessage:(NSString *)msg{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}
@end
