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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
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
    RACSignal *textfSignal = [[[UITextField alloc]init] rac_textSignal];
    [textfSignal subscribeNext:^(id x) {
        
    }];
    
    RACSignal *signal = [RACSignal combineLatest:@[_introduceImages.rac_sequence] reduce:^id{
        return nil;
    }];
//
    RGCardViewLayout *layout = [[RGCardViewLayout alloc]init];
    layout.itemSize = CGSizeMake(375 , 667);
    
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
    return self.introduceImages.count;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    MRJIntroduceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionIndetifier forIndexPath:indexPath];
    [self configureCell:cell withIndexPath:indexPath];
    [cell.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(cell.contentView);
        make.size.mas_equalTo(cell.contentView);
    }];
    return cell;
}
- (void)configureCell:(MRJIntroduceCollectionViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
//    UIView  *subview = [cell.contentView viewWithTag:1];
//    [subview removeFromSuperview];
    
    switch (indexPath.row) {
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
    cell.imageView.image =  self.introduceImages[indexPath.row];
}
#pragma mark -- optional delegate Method
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
//{
//    return <#expression#>
//}
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return  self.introduceImages.count;
//}
// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
//{
//    return nil;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
