//
//  AppUtils.m
//  MeiRenJi
//
//  Created by 申巧 on 14/11/10.
//  Copyright (c) 2014年 XiaoQiQi. All rights reserved.
//

#import "MRJCheckUtils.h"
//#import "Reachability.h"
#import <CommonCrypto/CommonDigest.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <AVFoundation/AVFoundation.h>

#define DEFAULT_VOID_COLOR [UIColor whiteColor]

@implementation MRJCheckUtils

/********************* System Utils **********************/
+ (void)showAlertMessage:(NSString *)msg{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

+ (void)closeKeyboard{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

+ (NSString *)md5FromString:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/******* UITableView & UINavigationController Utils *******/
+ (UIView *)tableViewsFooterView{
    UIView * coverView = [UIView new];
    coverView.backgroundColor = [UIColor clearColor];
    return coverView;
}

+ (UIBarButtonItem *)navigationBackButtonWithNoTitle{
    return [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

/********************* SVProgressHUD **********************/
+ (void)showSuccessMessage:(NSString *)message
{
    [SVProgressHUD showSuccessWithStatus:message];
}

+ (void)showErrorMessage:(NSString *)message
{
    [SVProgressHUD showErrorWithStatus:message];
}

+ (void)showProgressMessage:(NSString *) message
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:message];
}

+ (void)showProgressMessageWithNotAllowTouch:(NSString *)message
{
//    [SVProgressHUD showWithStatus:message maskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD showWithStatus:message];
}

+ (void)showInfoMessage:(NSString *)message
{
    [SVProgressHUD showInfoWithStatus:message];
}

+ (void)dismissHUD
{
    [SVProgressHUD dismiss];
}


/********************** NSDate Utils ***********************/
+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)dateString formatter:(NSString *)formatter;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:dateString];
}

//将服务器返回的10位格式时间戳转换成字符串的时间格式(不带 时分秒)
+(NSString *)changeTimeFormatToDate:(NSString *)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd"];
    
    NSDate * dateStr = [NSDate dateWithTimeIntervalSince1970:[date doubleValue]];
    if (date.length == 13) {
        NSTimeInterval interval = [date doubleValue]/1000.0;
        dateStr = [NSDate dateWithTimeIntervalSince1970:interval];
    }
    
    NSString * dateString = [formatter stringFromDate:dateStr];
    formatter = nil;
    
    return dateString;
}

//将服务器返回的10位格式时间戳转换成字符串的时间格式(带 时分秒)
+(NSString *)changeTimeFormatToTime:(NSString *)date
{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * dateStr = [NSDate dateWithTimeIntervalSince1970:[date doubleValue]];
    if (date.length == 13) {
        NSTimeInterval interval = [date doubleValue]/1000.0;
        dateStr = [NSDate dateWithTimeIntervalSince1970:interval];
    }
    
    NSString * dateString = [formatter stringFromDate:dateStr];
    formatter = nil;
    
    return dateString;
}

// 计算某个时间与当前时间的差值(精确计算)
+(NSString *)compareWithCurrentTimeByAccurate:(NSString *)time
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * date = [NSDate date];
    NSDate * compareDate = [formatter dateFromString:time];
    
    //时区问题
    NSTimeZone * zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    
    NSDate * localDate = [date dateByAddingTimeInterval:interval];
    compareDate = [compareDate dateByAddingTimeInterval:interval];
    
    formatter = nil;
    
    NSTimeInterval compareInterval = [compareDate timeIntervalSince1970]*1;
    NSTimeInterval nowInterval = [localDate timeIntervalSince1970]*1;
    NSTimeInterval cha = nowInterval - compareInterval;
    
    NSString * result;
    
    if (cha/3600 < 1) {
        result = [NSString stringWithFormat:@"%f",cha/60];
        //去掉小数点后的长度
        result = [result substringToIndex:result.length-7];
        result = [NSString stringWithFormat:@"%@分钟前",result];
    }
    if (cha/60 < 1) {
        result = @"刚刚";
    }
    if (cha/3600 > 1 && cha/86400 < 1) {
        result = [NSString stringWithFormat:@"%f",cha/3600];
        result = [result substringToIndex:result.length - 7];
        result = [NSString stringWithFormat:@"%@小时前",result];
    }
    if (cha/86400 > 1) {
        result = [NSString stringWithFormat:@"%f",cha/86400];
        result = [result substringToIndex:result.length - 7];
        result = [NSString stringWithFormat:@"%@天前",result];
    }
    if (cha/(86400*30)>1) {
        result = [time substringToIndex:10];
    }
    
    return result;
}

// 计算某个时间与当前时间的差值(不精确计算)
+(NSString *)compareWithCurrentTime:(NSString *)time
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * result;
    
    //时区问题
    NSTimeZone * zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];
    
    NSDate * localDate = [[NSDate date] dateByAddingTimeInterval:interval];
    NSDate * compareDate = [[formatter dateFromString:time] dateByAddingTimeInterval:interval];
    
    NSString * today = [formatter stringFromDate:[NSDate date]];
    NSString * today_date = [NSString stringWithFormat:@"%@ 00:00:00",[today substringToIndex:10]];
    NSDate * date1 = [[formatter dateFromString:today_date] dateByAddingTimeInterval:interval];
    formatter = nil;
    
    NSTimeInterval compareInterval = [compareDate timeIntervalSince1970]*1;
    NSTimeInterval nowInterval = [localDate timeIntervalSince1970]*1;
    
    NSTimeInterval date1Interval = [date1 timeIntervalSince1970]*1;
    
    NSTimeInterval date2Interval = date1Interval - (60*60*24);
    
    NSTimeInterval cha = nowInterval - compareInterval;
    
    if (compareInterval >= date1Interval && compareInterval <= nowInterval) {
        result = @"今天";
    }
    else if (compareInterval >= date2Interval && compareInterval < date1Interval) {
        result = @"昨天";
    }
    else if (cha/86400 > 1) {
        result = [NSString stringWithFormat:@"%f",cha/86400];
        result = [result substringToIndex:result.length - 7];
        result = [NSString stringWithFormat:@"%@天前",result];
    }
    if (cha/(86400*30) > 1) {
        result = [time substringToIndex:10];
    }
    
    return result;
}

+(NSString*)getNowMonthString:(NSString*)month
{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *  locationString = [dateformatter stringFromDate:senddate];
    
    NSLog(@"locationString:%@",locationString);
    
    return locationString;
}

//对数组进行升序排序
+(NSMutableArray *)sortDoubleArrayWithAscend:(NSMutableArray *)array
{
     //该方法只适用于纯字符型数组
     NSComparator finderSort = ^(id str1,id str2){
         if ([str1 doubleValue] > [str2 doubleValue]) {
             return (NSComparisonResult)NSOrderedDescending;
         }
         else if ([str1 doubleValue] < [str2 doubleValue]){
             return (NSComparisonResult)NSOrderedAscending;
         }
         else
         {
             return (NSComparisonResult)NSOrderedSame;
         }
     };
     NSMutableArray * resultArray = (NSMutableArray *)[array sortedArrayUsingComparator:finderSort];
     return resultArray;
}

+(NSMutableArray *)sortArrayWithArray:(NSMutableArray *)array descend:(BOOL)descend
{
    
    NSMutableArray * resultArray;
    if (descend) {
        NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|NSWidthInsensitiveSearch|NSForcedOrderingSearch;
        NSComparator sort = ^(NSString * str1,NSString * str2){
            
            NSRange range = NSMakeRange(0, str1.length>str2.length?str1.length:str2.length);
            return [str2 compare:str1 options:comparisonOptions range:range];
        };
        
        resultArray = (NSMutableArray *)[array sortedArrayUsingComparator:sort];
        
    }
    else{
        NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|NSWidthInsensitiveSearch|NSForcedOrderingSearch;
        NSComparator sort = ^(NSString * str1,NSString * str2){
            NSRange range = NSMakeRange(0, str1.length);
            return [str1 compare:str2 options:comparisonOptions range:range];
        };
        
        resultArray = (NSMutableArray *)[array sortedArrayUsingComparator:sort];
    }
    return resultArray;
}

/********************* Category Utils **********************/
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}



/********************* Verification Utils **********************/

//+(BOOL)checkPhoneNumber:(NSString *)phoneNumber
//{
//    if (phoneNumber.length < 10) {
//        return NO;
//    }
//    NSString *sub = [phoneNumber substringToIndex:2];
//    if ([sub isEqualToString:@"09"] && phoneNumber.length == 10) {
//        BOOL isNumber = [AppUtils checkNumber:phoneNumber];
//        if (isNumber == NO) {
//            return NO;
//        }
//        return YES;
//    }
//    if (phoneNumber.length == 11) {
//        BOOL isNumber = [AppUtils checkNumber:phoneNumber];
//        if (isNumber == NO) {
//            return NO;
//        }
//        return YES;
//    }
//    
//    return NO;
//}
+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+(BOOL)checkPhoneNumber:(NSString *)phoneNumber
{
    NSString *regMobile = @"^((13[0-9])|(14[0-9])|(15[0-9,\\D])|((16[0-9]))|((17[0-9]))|(18[0-9,0-9]))\\d{8}$";
//    /**
//     * 手机号码
//     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     * 联通：130,131,132,152,155,156,185,186
//     * 电信：133,1349,153,180,189
//     */
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0125-9])\\d{8}$";
//    /**
//     10 * 中国移动：China Mobile
//     11 * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     12 */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    /**
//     15 * 中国联通：China Unicom
//     16 * 130,131,132,152,155,156,185,186
//     17 */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /**
//     20 * 中国电信：China Telecom
//     21 * 133,1349,153,180,189
//     22 */
//    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
//    /**
//     25 * 大陆地区固话及小灵通
//     26 * 区号：010,020,021,022,023,024,025,027,028,029
//     27 * 号码：七位或八位
//     28 */
//    //     NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    BOOL res1 = [regextestmobile evaluateWithObject:phoneNumber];
//    BOOL res2 = [regextestcm evaluateWithObject:phoneNumber];
//    BOOL res3 = [regextestcu evaluateWithObject:phoneNumber];
//    BOOL res4 = [regextestct evaluateWithObject:phoneNumber];
//    
//    if (res1 || res2 || res3 || res4)
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regMobile];
    if ([regextestmobile evaluateWithObject:phoneNumber]) {
        return YES;
    }else
    {
        return NO;
    }
}

//验证字符串是否为纯数字 yes:全为数字
+ (BOOL)checkNumber:(NSString *)string{
    NSScanner * scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
+ (BOOL)isValidatIP:(NSString *)ipAddress{
    
    NSString  *urlRegEx =@"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            NSLog(@"%@",result);
            return YES;
        }
    }
    
    return NO;
}
//验证字符串是否全为空格
+ (BOOL)checkIsAllSpace:(NSString *)string{
    NSCharacterSet * set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    // stringByTrimmingCharactersInSet 除去首尾两端的空格
    NSString * resultStr = [string stringByTrimmingCharactersInSet:set];
    if ([resultStr length] == 0) {
        return YES;
    }
    return NO;
}

//检查字符串是否包含空格 yes:包含 no:不包含
+ (BOOL)checkContainSpace:(NSString *)string{
    BOOL containSpace = NO;
    NSString *space = @" ";
    
    for (int i = 0; i < string.length; i++) {
        NSString *text = [string substringWithRange:NSMakeRange(i, 1)];
        if ([text isEqualToString:space]) {
            containSpace = YES;
            break;
        }
    }
    
    return containSpace;
}

+(CGSize)getSizeWithText:(NSString *)text font:(UIFont *)font{
    CGSize size = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:NULL].size;
    return size;
}

+(CGSize)getSizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    CGSize size = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font,} context:NULL].size;
    return size;
}
//相机是否可用. yes:可用
+(BOOL)cameraIsAvailable
{
    @autoreleasepool {
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if (!captureDevice) {
            return NO;
        }
        
        NSError *error;
        AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        
        if (!deviceInput || error) {
            return NO;
        }
        
        return YES;
    }
}

+(NSString *)returnNetworkState{
    NSString *network = @"";
//    Reachability * reach = [Reachability reachabilityWithHostName:@"www.google.com"];
//    switch ([reach currentReachabilityStatus]) {
//        case NotReachable:
//            network = @"无网络";
//            break;
//        case ReachableViaWiFi:
//            network = @"WIFI";
//            break;
//        case ReachableViaWWAN:
//            network = @"WLAN";
//            break;
//        default:
//            break;
//    }
    return network;
}

@end
