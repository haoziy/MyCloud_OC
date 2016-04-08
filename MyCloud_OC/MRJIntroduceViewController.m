//
//  MRJIntroduceViewController.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/8.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "MRJIntroduceViewController.h"
#import "MRJIntroduceCollectionViewCell.h"
#import "MRJIntroduceCollecionViewFlowLayout.h"
#import "RGCardViewLayout.h"

NSString *const collectionIndetifier = @"mrj_collectionIndetifier";
@interface MRJIntroduceViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
   UICollectionView* collectView;
}
@end

@implementation MRJIntroduceViewController


-(instancetype)initWithImageArr:(NSArray<UIImage*>*)imagesArr;
{
    self = [super init];
    if (self) {
        _introduceImages = imagesArr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RGCardViewLayout *layout = [[RGCardViewLayout alloc]init];
    layout.itemSize = CGSizeMake(50, 50);
    
    collectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout ];
    collectView.backgroundColor = [UIColor whiteColor];
    [collectView registerClass:[MRJIntroduceCollectionViewCell class] forCellWithReuseIdentifier:collectionIndetifier];
    
    [self.view addSubview:collectView];
    collectView.delegate = self;
    collectView.dataSource  = self;
    [collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- requiredDelgate method
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return 1;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    MRJIntroduceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionIndetifier forIndexPath:indexPath];
    [self configureCell:cell withIndexPath:indexPath];
    return cell;
}
- (void)configureCell:(MRJIntroduceCollectionViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
//    UIView  *subview = [cell.contentView viewWithTag:1];
//    [subview removeFromSuperview];
    
    switch (indexPath.section) {
        case 0:
            
            cell.mainLabel.text = @"Glaciers";
            break;
        case 1:
            cell.mainLabel.text = @"Parrots";
            break;
        case 2:
            cell.mainLabel.text = @"Whales";
            break;
        case 3:
            cell.mainLabel.text = @"Lake View";
            break;
        case 4:
            break;
        default:
            break;
    }
    cell.imageView.image =  self.introduceImages[indexPath.section];
}
#pragma mark -- optional delegate Method
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  4;
}
// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
{
    return nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
