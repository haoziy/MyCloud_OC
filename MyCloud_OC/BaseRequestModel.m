//
//  BaseRequestModel.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/6.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "BaseRequestModel.h"
#import <YYKit/NSObject+YYModel.h>

@implementation BaseRequestModel
+(instancetype)initWithApiName:(NSString*)apiName paramsList:(NSString*)paramsListJson;
{
    NSAssert(apiName != nil, @"apiName 名字不能为空");
    BaseRequestModel *model = [[BaseRequestModel alloc]init];
    if ([model modelSetWithJSON:paramsListJson]) {
        
    }
    model.apiName = apiName;
//    model.paramsList = paramsList;
    return model;
}

@end
