//
//  AppDelegate+utils.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/6.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "AppDelegate.h"
extern NSString *const login_first_install_key;

@interface AppDelegate (utils)
-(BOOL)checkFirstInstall;

-(void)app_hudSetting;
@end
