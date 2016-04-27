//
//  UINavigationController+safetyPush.m
//  EachPlan
//
//  Created by ZEROLEE on 15/9/2.
//  Copyright (c) 2015年 XiaoZhou. All rights reserved.
//

#import "UINavigationController+safetyPush.h"

@implementation UINavigationController (safetyPush)
- (void)safetyPushViewController:(UIViewController *)viewController animated:(BOOL)animated;

{
    NSMutableArray *viewControllers = [self.viewControllers mutableCopy];
    for (int x=0; x<viewControllers.count; x++) {
        UIViewController *vc = viewControllers[x];
        if ([vc isKindOfClass:[viewController class]]) {
            [viewControllers removeObject:vc];
        }
    }
    self.viewControllers = viewControllers;
    [self pushViewController:viewController animated:animated];
}
@end
