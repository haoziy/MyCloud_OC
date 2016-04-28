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
@property(nonatomic,assign)BOOL isNeedTopSeprator;//是否需要顶部的分割线;
@property(nonatomic,strong) UIImageView *indicatorImgV;
-(void)configMainTableViewCellStyleWithText:(NSString*)mainText andDetailText:(NSString*)detailText cellSize:(CGSize)cellSize disclosureIndicator:(BOOL)disclosureIndicator selectHighlight:(BOOL)selectedHighlight;

@end
