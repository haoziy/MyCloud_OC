//
//  MRJScrollView.m
//  EachPlan
//
//  Created by ZEROLEE on 16/1/7.
//  Copyright © 2016年 XiaoZhou. All rights reserved.
//

#import "MRJScrollView.h"

@implementation MRJScrollView
-(id)init
{
    self = [super init];
    if (self) {
        self.delaysContentTouches = NO;
    }
    [self setup];
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delaysContentTouches = NO;
    }
    [self setup];
    return self;
}
-(void)setup
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    _contentView = [[MRJContainerView alloc]init];
//    _contentView.height = SCREEN_HEIGHT;
//    _contentView.width = SCREEN_WIDTH;
    [self addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    if ([view isKindOfClass:[UIButton class]]) {
        NSLog(@"should cancel");
        return NO;
    }else
    {
        return YES;
    }
}
@end
