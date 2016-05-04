//
//  NSString+Safe.m
//  JDBClient
//
//  Created by You Tu on 15/1/6.
//  Copyright (c) 2015年 JDB. All rights reserved.
//

#import "NSString+Safe.h"

@implementation NSString (Safe)

- (unichar)safeCharacterAtIndex:(NSUInteger)index
{
    if (index >= self.length) {
        return '\0';
    }
    return [self characterAtIndex:index];
}

- (NSString *)safeSubstringToIndex:(NSUInteger)index
{
    if(index >= self.length) {
        return nil;
    }
    return [self substringToIndex:index];
}

- (NSString *)safeSubstringFromIndex:(NSUInteger)index
{
    if(index >= self.length) {
        return nil;
    }
    return [self substringFromIndex:index];
}
+(NSString *)countNumAndChangeformat:(NSString *)num
{
    NSRange range = [num rangeOfString:@"."];//先查看是否含有小数点;
    NSString *inteerPart;//去掉小数点后的;
    NSString *decimalPart;//小数部分
    if(range.location!=NSNotFound)
    {
        inteerPart = [num safeSubstringToIndex:range.location];
        decimalPart = [num safeSubstringFromIndex:range.location];
    }else
    {
        inteerPart = num;
    }
    
    int count = 0;
    long long int a = inteerPart.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:inteerPart];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    if (decimalPart) {
        [newstring appendString:decimalPart];
    }
    return newstring;
}
+(NSString*)mrj_sigal_encode:(NSString *)originStr
{
    NSInteger result = 0;
    const char *encrypt = "meirenji";
    const char *data = [originStr UTF8String];
    for (int i = 0,j = 0; i < strlen(data); i++,j++) {
        if (j ==  strlen(encrypt)) {
            j = 0;
        }
        result += data[i]^encrypt[j];
    }
    return [NSString stringWithFormat:@"%ld",(long)result];
}
+(NSString*)mrj_sigal_encodeWithData:(id)data;
{
    if ([NSJSONSerialization isValidJSONObject:data]) {
        return [MRJCheckUtils md5FromString:[self mrj_sigal_encode:[self dataToJSONString:data]]];
    }else
    {
        return nil;
    }
}

+ (NSString *)dataToJSONString:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return  [[NSString alloc] initWithData:jsonData
                                                  encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }
}


@end
