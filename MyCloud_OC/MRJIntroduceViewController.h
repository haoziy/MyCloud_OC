//
//  MRJIntroduceViewController.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/8.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "BaseHiddenTabbarViewController.h"

@interface MRJIntroduceViewController : BaseHiddenTabbarViewController

@property(nonatomic,strong,readonly)NSArray *introduceImages;

-(instancetype)initWithImageArr:(NSArray<UIImage*>*)imagesArr;
@end
