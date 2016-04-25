//
//  MRJTextFieldDelegate.m
//  EachPlan
//
//  Created by ZEROLEE on 15/9/2.
//  Copyright (c) 2015年 XiaoZhou. All rights reserved.
//

#import "MRJTextFieldDelegate.h"
#import "MRJTextField.h"

@implementation MRJTextFieldDelegate
//限制输入长度
#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    MRJTextField *mrjTextField = (MRJTextField*)textField;
    if (mrjTextField.textType==MRJTextFieldValueTypeOfAnyOne) {
        return YES;
    }else if(mrjTextField.textType == MRJTextFieldValueTypeOfValidMoney)
    {
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if (textField.text.length==0&&[string isEqualToString:@"."]) {
            return NO;
        }else if ([textField.text rangeOfString:@"."].length==1&&[string isEqualToString:@"."])
        {
            return NO;
        }else if ([textField.text rangeOfString:@"."].location==textField.text.length-3&&![textField.text isEqualToString:@""])
        {
            return NO;
        }else
        {
            if ([textField.text rangeOfString:@"."].length==1&&textField.text.length==11) {
                return NO;
            }
            if ([textField.text rangeOfString:@"."].location==NSNotFound&&textField.text.length==8) {
                return NO;
            }
        }
    }
    else if (mrjTextField.textType ==MRJTextFieldValueTypeOfAnyInteger)
    {
        if ([string isEqualToString:@""]) {
            return YES;
        }else if ([string isEqualToString:@"."])
        {
            return NO;
        }else
        {
            if (textField.text.length==8) {
                return NO;
            }
        }
    }
    return YES;
}
@end
