//
//  MRJUserModel.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/5/5.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRJUserModel : NSObject <NSCoding>

@property(nonatomic,copy)NSString *accountId;//用户id
@property(nonatomic,copy)NSString *userName;//用户名
@property(nonatomic,copy)NSString *mobile;//手机号
@property(nonatomic,copy)NSString *email;//邮箱
@end
