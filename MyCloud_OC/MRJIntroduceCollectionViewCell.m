//
//  MRJIntroduceCollectionViewCell.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/8.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "MRJIntroduceCollectionViewCell.h"
#import "Masonry.h"

@implementation MRJIntroduceCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCustomerSubViews];
    }
    return self;
}



-(instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setupCustomerSubViews];
    }
    return self;
}
-(void)setupCustomerSubViews
{
    _mainLabel = [[UILabel alloc]init];
    _imageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_mainLabel];
    [self.contentView addSubview:_imageView];
//    _imageView.bounds = self.bounds;
    
//    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self.contentView.center);
//        make.size.mas_equalTo(self.contentView);
//    }];
    
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
}
@end
