//
//  MRJTextField.m
//  EachPlan
//
//  Created by 申巧 on 15/6/5.
//  Copyright (c) 2015年 XiaoZhou. All rights reserved.
//

#import "MRJTextField.h"
#import "UIView+Frame.h"
@class LoginViewController;
@interface MRJTextField ()
{
    MRJTextFieldDelegate *mrjDeletage;
}

@end

@implementation MRJTextField
-(id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){
        [self setup];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    return self;
}

-(void)setup{
    mrjDeletage = [[MRJTextFieldDelegate alloc]init];
    self.delegate = mrjDeletage;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldValueChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldBegin:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEnd:) name:UITextFieldTextDidEndEditingNotification object:nil];
    self.textColor = [MRJColorManager mrj_mainTextColor];
    self.font = [MRJSizeManager mrjMainTextFont];
    self.borderStyle = UITextBorderStyleNone;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _warningEnable = YES;
    _limitEmpty = YES;
    _limitSpace = YES;
    _buttonNotilineV = [[UIView alloc]init];
    _buttonNotilineV.backgroundColor = [MRJColorManager mrj_secondaryTextColor];
    [self addSubview:_buttonNotilineV];
    
    [_buttonNotilineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@0.5);
        make.width.mas_equalTo(self.mas_width);
        make.centerX.mas_equalTo(self.centerX);
        make.bottom.equalTo(self.mas_bottom).with.offset(-0.5);
    }];
}
-(void)setTextType:(MRJTextFieldValueType)textType
{
    _textType = textType;
    if (textType==MRJTextFieldValueTypeOfAnyOne) {
        return;
    }else if (textType==MRJTextFieldValueTypeOfTelephoneNumber)//电话号码
    {
        self.keyboardType = UIKeyboardTypeNumberPad;
    }else if(textType==MRJTextFieldValueTypeOfBankCardNumber)//银行卡
    {
        self.keyboardType = UIKeyboardTypeNumberPad;
    }else if (textType==MRJTextFieldValueTypeOfValidMoney)//两位小数货币
    {
        self.keyboardType = UIKeyboardTypeDecimalPad;
    }else if (textType==MRJTextFieldValueTypeOfAnyInteger)
    {
        self.keyboardType = UIKeyboardTypeNumberPad;
        
    }else if(textType==MRJTextFieldValueTypeOfEmail)
    {
        self.keyboardType = UIKeyboardTypeASCIICapable;
    }
}
-(void)setWarningEnable:(BOOL)warningEnable{
    _warningEnable = warningEnable;
    if (warningEnable == YES) {
        self.delegate = mrjDeletage;
    }else{
        self.delegate = nil;
    }
}

-(void)setLeftView:(UIView *)leftView
{
    [super setLeftView:leftView];
    _startLocation = leftView.width;
}
-(void)setLimitEmpty:(BOOL)limitEmpty{
    _limitEmpty = limitEmpty;
}

-(void)setOnlyNumber:(BOOL)onlyNumber{
    self.keyboardType = UIKeyboardTypeNumberPad;
    _onlyNumber = onlyNumber;
}

-(void)setLimitLength:(BOOL)limitLength{
    _limitLength = limitLength;
}

-(void)setLimitSpace:(BOOL)limitSpace{
    _limitSpace = limitSpace;
}

-(void)setStartLocation:(CGFloat)startLocation{
    _startLocation = startLocation;
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, startLocation+[MRJSizeManager mrjHorizonPaddding], self.height)];
    self.leftViewMode = UITextFieldViewModeAlways;
    [self setNeedsDisplay];
}
//////控制编辑文本的位置
//-(CGRect)editingRectForBounds:(CGRect)bounds{
//    CGRect frame = CGRectMake(_startLocation, bounds.origin.y, bounds.size.width-_startLocation, bounds.size.height);
//    return frame;
//}
//控制placeHolder的颜色,字体,位置
-(void)drawPlaceholderInRect:(CGRect)rect{
    
    CGSize size = [MRJSizeManager getSizeWithText:self.placeholder font:[MRJSizeManager mrjMiddleTextFont]];
    CGRect frame = CGRectMake(0, (self.height-size.height)/2, size.width, size.height);
    [[self placeholder] drawInRect:frame withAttributes:@{NSFontAttributeName:[MRJSizeManager mrjMiddleTextFont],NSForegroundColorAttributeName:[MRJColorManager mrj_secondaryTextColor]}];
}
-(void)textFieldValueChange:(NSNotification *)note
{
    
    
}
-(void)textFieldBegin:(NSNotification*)note
{
    if ([note.object isKindOfClass:[self class]]) {
        MRJTextField *text = note.object;
        text.buttonNotilineV.y = text.height-1;
        text.buttonNotilineV.height = 1;
        text.buttonNotilineV.backgroundColor = [MRJColorManager mrj_plainColor];
    }
}
-(void)textFieldEnd:(NSNotification*)note
{
    if ([note.object isKindOfClass:[self class]]) {
        MRJTextField *text = note.object;
        text.buttonNotilineV.height = 0.5;
        text.buttonNotilineV.y = text.height-0.5;
        text.buttonNotilineV.backgroundColor = [MRJColorManager mrj_secondaryTextColor];
        if (text.textType==MRJTextFieldValueTypeOfEmail) {
            
        }else if (text.textType==MRJTextFieldValueTypeOfBigLength)
        {
            
        }
        else
        {
            if (text.text.length>14) {
//                text.text = [text.text safeSubstringToIndex:14];
            }
        }
        text.text = [text.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
