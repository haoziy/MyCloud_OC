//
//  BaseTableViewCell.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/6.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseTableViewCell;
@protocol BaseTableViewCellDelegate <NSObject>

-(void)cell:(BaseTableViewCell*)cell operationWithOperation:(id)data;

@end


@interface BaseTableViewCell : UITableViewCell

@property(nonatomic,weak)id <BaseTableViewCellDelegate> delegate;
@end
