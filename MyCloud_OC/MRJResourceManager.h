//
//  MRJResourceManager.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/8.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MRJResourceManager : NSObject

+(UIImage*)imageForKey:(NSString*)key;

//根据颜色得到图片
+(UIImage *)buttonImageFromColor:(UIColor *)color andSize:(CGSize)size;
@end
