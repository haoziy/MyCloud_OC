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

@end
