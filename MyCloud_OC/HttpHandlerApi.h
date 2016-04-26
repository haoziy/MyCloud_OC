//
//  HttpHandlerApi.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/6.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef __cplusplus
#define API_EXTERN  extern
#else
#define API_EXTERN FOUNDATION_EXPORT
#endif

typedef NSString* const ApiNameMap;
/**
 *
 //接口名;
 //全代码不能出现硬编码;同时,为了能做成SDK,接口文件细节不宜暴露,应该写在m文件里;需要的时候打包成frame文件隐藏接口细节;
 //接口细节以key->value方式获取,每个命名都尽可能的方便查找以及编码时候的代码提示;又为了与项目中的其他的key区分开来,需要加前缀或者后缀区分;推荐key的命名方式为 api(前缀)_moduleName(所在功能模块名)_apiName(api功能名);
 //如一个接口多次使用,项目需求又常常变更,为了降低维护成本,可以适当出现copy而非复用,copy一份,例如 api_module1_xxx1 的内容跟 api_module2_xxx2一样
 //每一个接口需要的参数需要暴露给外部使用,所以推荐使用请求模型来处理;看到请求模型就明白参数需求了
 */


/**
 *  @param
 *  @discription 登录接口
 *
 */
extern ApiNameMap api_loginRegist_login;//登录接口,需要的参数细节可以暴露
@interface HttpHandlerApi : NSObject







@end

