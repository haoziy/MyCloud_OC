//
//  DeviceParameterViewController.h
//  EachPlan
//
//  Created by 申巧 on 15/7/8.
//  Copyright (c) 2015年 XiaoZhou. All rights reserved.
//

#import "BaseHiddenTabbarViewController.h"
#import "WLRangeSlider.h"
@class SelectShopButton;
@class DeviceModel;

@interface DeviceParameterViewController : BaseHiddenTabbarViewController<WLRangeSliderDelegate>
{
    UIButton *resetDefaultBtn;
    
    UIImageView *cameraImage;
    WLRangeSlider *rangeSlider;
    UIImageView *arrowImage;
    UIButton *catchImageBtn;
    
    float leftValue,rightValue,topValue;
    int boxLeft,boxRight,boxTop,boxBottom;
    CGFloat cameraWith;
    CGFloat cameraHeight;
    
    NSArray *heightArray;
    NSString *height;
    
    NSString *snId;
    NSTimer *timer;
}
@property (nonatomic,strong) DeviceModel *deviceModel;

@end
