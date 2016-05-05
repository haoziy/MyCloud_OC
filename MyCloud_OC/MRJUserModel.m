//
//  MRJUserModel.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/5/5.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "MRJUserModel.h"

@implementation MRJUserModel


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self modelEncodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}
@end
