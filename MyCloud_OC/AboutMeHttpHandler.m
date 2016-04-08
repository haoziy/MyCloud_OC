//
//  AboutMeHttpHandler.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/7.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "AboutMeHttpHandler.h"

@implementation AboutMeHttpHandler

+(void)checkUpdateWithApiName:(ApiNameMap)apiName successBlock:(MRJSuccessBlock) success failedBlock:(MRJFailedBlock)failed;
{
    [self baseRequestAFNetWorkApi:apiName method:HttpRequestPost andHttpHeader:nil parameters:nil prepareExecute:^{
        
    } succeed:^(id obj) {
        success(obj);
    } failed:^(id obj) {
        failed(obj);
    }];;
}
@end
