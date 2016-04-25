//
//  MRJTextField.h
//  EachPlan
//
//  Created by 申巧 on 15/6/5.
//  Copyright (c) 2015年 XiaoZhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRJTextFieldDelegate.h"
typedef enum
{
    MRJTextFieldValueTypeOfAnyOne = 0,//任意类型，表示不做限制
    MRJTextFieldValueTypeOfValidMoney = 1,//货币,两位小数,
    MRJTextFieldValueTypeOfTelephoneNumber = 2,//电话号码。13x xxxx xxxx/自动填充空格型
    MRJTextFieldValueTypeOfIdentiFierNumber = 3,//身份证号码。18 或者19位。最后一位可以为x
    MRJTextFieldValueTypeOfBankCardNumber = 4,//银行卡号.6224 xxxx xxxx xxxx xxxx 型
    MRJTextFieldValueTypeOfEmail = 5,//邮箱类型
    MRJTextFieldValueTypeOfAnyInteger=6,//任意类型整数
    MRJTextFieldValueTypeOfBigLength=7//长度很长的字符类型;
    
}MRJTextFieldValueType;

@interface MRJTextField : UITextField<UITextFieldDelegate>
@property(nonatomic,assign)MRJTextFieldValueType textType;

@property (nonatomic,copy) NSString *inputCategory;

/**
 *  yes: 弹出警告
 */
@property (nonatomic,assign) BOOL warningEnable;

/**
 *  yes: 只允许输入数字
 */
@property (nonatomic,assign) BOOL onlyNumber;

/**
 *  yes: 限制输入长度
 */
@property (nonatomic,assign) BOOL limitLength;

/**
 *  yes: 不允许输入空格
 */
@property (nonatomic,assign) BOOL limitSpace;

/**
 *  yes: 输入结束时,输入内容不允许为空
 */
@property (nonatomic,assign) BOOL limitEmpty;

/**
 *  输入光标的起始位置.默认为7
 */
@property (nonatomic,assign) CGFloat startLocation;

@property(nonatomic,strong)UIView *buttonNotilineV;
@end
