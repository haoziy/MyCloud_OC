//
//  HomeHttpHandler.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/26.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "BaseHttpHandler.h"

extern ApiNameMap api_home_get_device_list;//获取设备列表

@interface HomeHttpHandler : BaseHttpHandler


+(void)getDeviceListParams:(NSDictionary*)parm preExecute:(MRJPrepareExcute)preExecute success:(MRJSuccessBlock)succes failed:(MRJFailedBlock)failed;
@end
