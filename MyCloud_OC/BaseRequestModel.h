//
//  BaseRequestModel.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/6.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseRequestModel : NSObject

@property(nonatomic)NSString *apiName;//每个请求需要的api名字
@property(nonatomic)NSDictionary *paramsList;//参数列表
//@property(assign,nonatomic) 

//初始化工厂方法;
+(instancetype)initWithApiName:(NSString*)apiName paramsList:(NSString*)paramsListJson;


@end
