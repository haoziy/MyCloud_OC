//
//  LoginRegistResourceManager.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/8.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "LoginRegistResourceManager.h"
#import "MRJMacros.h"

NSString *const login_accountImageName = @"login_account";
NSString *const login_passwordImageName = @"login_password";
@implementation LoginRegistResourceManager



+(UIImage*)introduceImageWithSqueue:(NSInteger)squeue;
{
    NSString *str = @"";
    if (IS_IPHONE_4) {
        str = @"640*960";
    }else if (IS_IPHONE_5)
    {
        str = @"640*1136";
    }else if(IS_IPHONE_6)
    {
        str = @"750*1334";
    }else if(IS_IPHONE_6P)
    {
        str = @"1442*2208";
    }else{
        
    }
    str = [NSString stringWithFormat:@"0%ld_%@",squeue,str];
    return [self imageForKey:str];
}
+(UIImage*)accountIconImage;
{
    return [self imageForKey:login_accountImageName];
}
+(UIImage*)passwordIconImage;
{
    return [self imageForKey:login_passwordImageName];
}
@end
