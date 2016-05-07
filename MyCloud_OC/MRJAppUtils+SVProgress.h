//
//  MRJAppUtils+SVProgress.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/5/7.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "MRJAppUtils.h"

@interface MRJAppUtils (SVProgress)

/********************* SVProgressHUD **********************/
//弹出操作错误信息提示框
+ (void)showErrorMessage:(NSString *)message;

//弹出操作成功信息提示框
+ (void)showSuccessMessage:(NSString *)message;

//弹出加载提示框
+ (void)showProgressMessage:(NSString *) message;

//弹出加载提示框,此时屏幕不响应用户点击事件
+ (void)showProgressMessageWithNotAllowTouch:(NSString *)message;

//弹出信息提示框
+ (void)showInfoMessage:(NSString *)message;

//取消弹出框
+ (void)dismissHUD;

+ (void)showAlertMessage:(NSString *)msg;
@end
