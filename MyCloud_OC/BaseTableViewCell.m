//
//  BaseTableViewCell.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/6.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BaseTableViewCell()
{
    UIView *bottomLine;
    UIView *topLine;
}

@end

@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _indicatorImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrowright"]];
        
        _mainTextLabel = [[UILabel alloc]init];
        _secondTextLabel = [[UILabel alloc]init];
         _secondTextLabel.textColor = SecondaryTextColor;
        [self.contentView addSubview:_mainTextLabel];
        [self.contentView addSubview:_secondTextLabel];
        bottomLine = [[UIView alloc]init];
        bottomLine.backgroundColor = SeparatrixColor;
        
        
        [self.contentView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(0);
            make.height.mas_equalTo(CELL_SPERITX_HEIGHT);
            make.left.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView).offset(0);
        }];
        topLine = [[UIView alloc]init];
        topLine.backgroundColor = SeparatrixColor;
        
        
    }
    return self;
}
-(void)configMainTableViewCellStyleWithText:(NSString*)mainText andDetailText:(NSString*)detailText cellSize:(CGSize)cellSize disclosureIndicator:(BOOL)disclosureIndicator selectHighlight:(BOOL)selectedHighlight;
{
    [_indicatorImgV removeFromSuperview];
    _mainTextLabel.text = mainText;
    [_mainTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([MRJSizeManager mrjHorizonPaddding]);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    _secondTextLabel.text = detailText;
   
    
    if (detailText.length>0) {
        [_secondTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_secondTextLabel.superview).offset(-[MRJSizeManager mrjHorizonPaddding]-LEFT_PADDING/2);
            make.centerY.mas_equalTo(_secondTextLabel.superview.mas_centerY);
        }];
    }
    
    if (selectedHighlight) {
        //自定义cell选中时的颜色
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [MRJColorManager mrj_separatrixColor];
    }else{
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (disclosureIndicator) {
        [self.contentView addSubview:_indicatorImgV];
        [_indicatorImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_indicatorImgV.superview.mas_centerY);
            make.right.mas_equalTo(_indicatorImgV.superview).offset(-LEFT_PADDING/2);
        }];
        
    }
     
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [topLine removeFromSuperview];
    
    if (_isNeedTopSeprator) {
        [self.contentView addSubview:topLine];
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.height.mas_equalTo(CELL_SPERITX_HEIGHT);
            make.left.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView).offset(0);
        }];
    }
}
@end
