//
//  MRJBaseTableview.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/28.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRJBaseTableview : UITableView

@property(nonatomic,copy)NSString* noDataSetString;//没有数据集时显示的内容
@property(nonatomic,strong)UIView *noDataSetView;//没有数据集暂时的view;
@end
