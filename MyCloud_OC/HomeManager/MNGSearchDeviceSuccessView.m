//
//  MNGSearchDeviceSuccessView.m
//  EachPlan
//
//  Created by ZEROLEE on 15/9/16.
//  Copyright (c) 2015年 XiaoZhou. All rights reserved.
//

#import "MNGSearchDeviceSuccessView.h"
#import "UIView+Frame.h"
#import "HomeResourceManager.h"
#import "HomeStringKeyContentValueManager.h"

@implementation MNGSearchDeviceSuccessView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame andDeviceSnNumber:(NSString*)snNumber deviceAlias:(NSString*)alias deviceMacAddress:(NSString*)macAddress;
{
    self = [self initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = self.width/2;
        _deviceSnNumber = snNumber;
        _deviceAlias = alias;
        _deviceMacAddress = macAddress;
        
        
        self.backgroundColor = [MRJColorManager mrj_separatrixColor];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((self.width-self.width/4)/2, (self.height/2-self.width/4)/2, self.width/4, self.width/4)];
        [btn setImage:[HomeResourceManager home_searchDeviceLogo] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        UILabel *snNumberLablel = [[UILabel alloc]init];
        snNumberLablel.text =[NSString stringWithFormat:@"%@:%@",[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceSnNumber],_deviceSnNumber];
        [snNumberLablel sizeToFit];
        snNumberLablel.textColor = [MRJColorManager mrj_mainTextColor];
        snNumberLablel.x = self.width/8;
        snNumberLablel.y = self.height/2;
        snNumberLablel.font  = [MRJSizeManager mrjMiddleTextFont];
        [self addSubview:snNumberLablel];
        
        UILabel *aliasLabel = [[UILabel alloc]init];
        aliasLabel.text =[NSString stringWithFormat:@"%@:%@",[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceAliaName],_deviceAlias];
        [aliasLabel sizeToFit];
        aliasLabel.textColor = [MRJColorManager mrj_mainTextColor];
        aliasLabel.x = self.width/8;
        aliasLabel.y = self.height/2+snNumberLablel.height+2;
        aliasLabel.font  = [MRJSizeManager mrjMiddleTextFont];
        [self addSubview:aliasLabel];
        
        UILabel *macLabel = [[UILabel alloc]init];
        macLabel.text =[NSString stringWithFormat:@"%@:%@",[HomeStringKeyContentValueManager languageValueForKey:language_homeDeviceManagerDeviceWIFIMacAddress],_deviceMacAddress];
        [macLabel sizeToFit];
        macLabel.textColor = [MRJColorManager mrj_mainTextColor];
        macLabel.x = self.width/8;
        macLabel.y = self.height/2+snNumberLablel.height+aliasLabel.height+4;
        macLabel.font  = [MRJSizeManager mrjMiddleTextFont];
    }
    return self;
}
-(void)btnPressed:(UIButton*)btn
{
    if([_delegate respondsToSelector:@selector(searchSuccessForNextOperation:)])
    {
        [_delegate searchSuccessForNextOperation:self];
    }
}
@end
