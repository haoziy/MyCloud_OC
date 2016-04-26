//
//  ChoicePrivateModelView.h
//  EachPlan
//
//  Created by ZEROLEE on 15/10/20.
//  Copyright (c) 2015年 XiaoZhou. All rights reserved.
//


@class ChoicePrivateModelView;
@protocol ChoicePrivateModelViewDelegate <NSObject>
-(void)cancelOperation:(ChoicePrivateModelView*)view;
-(void)operationCompleted:(ChoicePrivateModelView*)view withResult:(NSData*)data;
@end

@interface ChoicePrivateModelView : UIView
@property(nonatomic,copy)NSString *myCloudIP;//私有云的ip
@property(nonatomic,strong)MRJTextField *serviceAddressTF;
@property(nonatomic,weak)id<ChoicePrivateModelViewDelegate> delegate;
@property(nonatomic,copy)NSString *myCloudPort;//私有云端口

@end
