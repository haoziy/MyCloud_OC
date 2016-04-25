//
//  LoginRegistResourceManager.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/8.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "MRJResourceManager.h"

@interface LoginRegistResourceManager : MRJResourceManager

/**
 *  获取启动介绍界面图片
 *
 *  @param squeue 序号
 *
 *  @return 图片
 */
+(UIImage*)introduceImageWithSqueue:(NSInteger)squeue;

/**
 *  登录账号icon
 *
 *  @return 返回对应图片
 */
+(UIImage*)accountIconImage;

/**
 *  登录密码icon
 *
 *  @return 返回图片
 */
+(UIImage*)passwordIconImage;
@end
