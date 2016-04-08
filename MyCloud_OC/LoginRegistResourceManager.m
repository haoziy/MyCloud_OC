//
//  LoginRegistResourceManager.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/8.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "LoginRegistResourceManager.h"
#import "MRJMacros.h"

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

@end
