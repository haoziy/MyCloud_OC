//
//  MNGSearchDeviceSuccessView.h
//  EachPlan
//
//  Created by ZEROLEE on 15/9/16.
//  Copyright (c) 2015年 XiaoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MNGSearchDeviceSuccessDelegate <NSObject>

-(void)searchSuccessForNextOperation:(UIView*)view;

@end

@interface MNGSearchDeviceSuccessView : UIView
@property(nonatomic,copy)NSString *deviceSnNumber;//设备序列号
@property(nonatomic,copy)NSString *deviceAlias;//设备别名
@property(nonatomic,copy)NSString *deviceMacAddress;//设备mac地址
@property(nonatomic,weak)id<MNGSearchDeviceSuccessDelegate> delegate;

-(id)initWithFrame:(CGRect)frame andDeviceSnNumber:(NSString*)snNumber deviceAlias:(NSString*)alias deviceMacAddress:(NSString*)macAddress;
@end
