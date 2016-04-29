//
//  BaseViewController.h
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/6.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const indentifier_cellIdentifier;

@interface BaseViewController : UIViewController
@property(nonatomic,strong)MRJScrollView *backScrollView;

-(void)returnFront:(id)sender;
@end
