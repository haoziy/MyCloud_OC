//
//  SelectInstallHeightViewController.m
//  EachPlan
//
//  Created by 申巧 on 15/7/8.
//  Copyright (c) 2015年 XiaoZhou. All rights reserved.
//

#import "SelectInstallHeightViewController.h"

#import "UIView+Frame.h"
#import "UIView+Additions.h"
#import "DeviceModel.h"


@implementation SelectInstallHeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"选择安装高度";
    
    if ([_deviceModel.lens isEqualToString:@"1"]) {
        heightArray = @[@"2.6米以下",@"2.6~2.8米",@"2.8米以上"];
    }else if ([_deviceModel.lens isEqualToString:@"2"]){
        heightArray = @[@"3.2米以下",@"3.2~3.4米",@"3.4米以上"];
    }else if ([_deviceModel.lens isEqualToString:@"3"]){
        heightArray = @[@"3.5米以下",@"3.5~3.8米",@"3.8米以上"];
    }
//    
//    myTableView = [UITableView initTableViewWithFrame:(CGRect){0,TOP_PADDING,SCREEN_WIDTH,ROW_HEIGHT*3} scrollEnable:NO rowHeight:ROW_HEIGHT];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    [_mySccrollView addSubview:myTableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return heightArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *myCell = @"MyCell";
//    ShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"ShopTableViewCell" owner:self options:nil] lastObject];
//    }
//    
//    cell.backgroundColor = NavigationTextColor;
//    cell.width = SCREEN_WIDTH;
//    cell.shopLabel.text = heightArray[indexPath.row];
//    if ([_deviceModel.installHeight isEqualToString:heightArray[indexPath.row]]) {
//        cell.ringImageView.image = [UIImage imageNamed:@"select"];
//    }
//    
//    if (indexPath.row ==0) {
//        [cell.contentView addSubview:[UIView initCellLineViewWithFrame:(CGRect){0,0,SCREEN_WIDTH,CELL_SPERITX_HEIGHT}]];
//    }
//    [cell.contentView addSubview:[UIView initCellLineViewWithFrame:(CGRect){0,ROW_HEIGHT-CELL_SPERITX_HEIGHT,SCREEN_WIDTH,CELL_SPERITX_HEIGHT}]];;
//    return cell;
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    ShopTableViewCell *cell = (ShopTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    cell.ringImageView.image = [UIImage imageNamed:@"select"];
//    
//    if ([_delegate respondsToSelector:@selector(selectedHeightComplete:)]) {
//        NSDictionary *obj = @{@"height":heightArray[indexPath.row],@"value":[NSString stringWithFormat:@"%ld",(long)indexPath.row+2]};
//        [_delegate selectedHeightComplete:obj];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    ShopTableViewCell *cell = (ShopTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    cell.ringImageView.image = [UIImage imageNamed:@"select_white"];
}

@end
