//
//  MRJBaseResponseModel.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/21.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef  NS_ENUM(NSInteger,MRJRequestResultCode)
{
    MRJRequestResultUnknown = 1<<0,//未知结果
    MRJRequestResultSuccess,//成功
    MRJRequestResultFailed//失败
};


@interface MRJBaseResponseModel : NSObject
@property(nonatomic,assign)MRJRequestResultCode requestStatus;//状态
@property(nonatomic,strong)NSDictionary *responseData;//返回内容
@end
