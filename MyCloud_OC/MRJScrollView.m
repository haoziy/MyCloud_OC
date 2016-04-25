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
//    _contentView.constraints.
    self.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addSubview:_contentView];
//    NSDictionary *views = NSDictionaryOfVariableBindings(_contentView);
//    
//    NSString *vFVL = [NSString stringWithFormat:@"V:|-0-[_contentView(%f)]-0-|",SCREEN_WIDTH];
//    NSString *hFVL = [NSString stringWithFormat:@"H:|-0-[_contentView(%f)]-0-|",SCREEN_HEIGHT];
//    NSLayoutFormatOptions ops = NSLayoutFormatAlignAllLeft|NSLayoutFormatAlignAllTop;
//    NSArray *vConsttraint = [NSLayoutConstraint constraintsWithVisualFormat:vFVL options:ops metrics:nil views:views];
//    NSArray *hConsttraint = [NSLayoutConstraint constraintsWithVisualFormat:hFVL options:ops metrics:nil views:views];
//    [self addConstraints:vConsttraint];
//    [self addConstraints:hConsttraint];
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
