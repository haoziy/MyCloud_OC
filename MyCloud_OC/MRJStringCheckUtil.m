//
//  MRJStringCheckUtil.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/25.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "MRJStringCheckUtil.h"

@implementation MRJStringCheckUtil


+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+(BOOL)checkPhoneNumber:(NSString *)phoneNumber
{
    NSString *regMobile = @"^((13[0-9])|(14[0-9])|(15[0-9,\\D])|((16[0-9]))|((17[0-9]))|(18[0-9,0-9]))\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regMobile];
    if ([regextestmobile evaluateWithObject:phoneNumber]) {
        return YES;
    }else
    {
        return NO;
    }
}
@end
