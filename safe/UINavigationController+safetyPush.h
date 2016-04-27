//
//  UINavigationController+safetyPush.h
//  EachPlan
//
//  Created by ZEROLEE on 15/9/2.
//  Copyright (c) 2015年 XiaoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (safetyPush)

- (void)safetyPushViewController:(UIViewController *)viewController animated:(BOOL)animated;
@end
