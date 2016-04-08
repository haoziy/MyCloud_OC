//
//  AppDelegate+utils.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/6.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "AppDelegate+utils.h"
#import "MRJStoreManager.h"

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
@end
