//
//  MRJIntroduceCollectionViewCell.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/8.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "MRJIntroduceCollectionViewCell.h"

@implementation MRJIntroduceCollectionViewCell

-(instancetype)init
{
    self = [super init];
    if (self) {
        _mainLabel = [[UILabel alloc]init];
        _imageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_mainLabel];
        [self.contentView addSubview:_imageView];
        
    }
    return self;
}
@end
