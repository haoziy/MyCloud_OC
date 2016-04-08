//
//  AboutMeHttpHandler.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/7.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "BaseHttpHandler.h"

@interface AboutMeHttpHandler : BaseHttpHandler

+(void)checkUpdateWithApiName:(ApiNameMap)apiName successBlock:(MRJSuccessBlock) success failedBlock:(MRJFailedBlock)failed;


@end
