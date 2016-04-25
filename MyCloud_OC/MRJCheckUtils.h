//
//  AppUtils.h
//  MeiRenJi
//
//  Created by 申巧 on 14/11/10.
//  Copyright (c) 2014年 XiaoQiQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRJCheckUtils : NSObject



//获取MD5加密后字符串
+ (NSString *)md5FromString:(NSString *)str;

/******* UITableView & UINavigationController Utils *******/
//返回View覆盖多余的tableview cell线条
+ (UIView *)tableViewsFooterView;

//获取没有文字的导航栏返回按钮
+ (UIBarButtonItem *)navigationBackButtonWithNoTitle;

/********************* SVProgressHUD **********************/
//弹出操作错误信息提示框
+ (void)showErrorMessage:(NSString *)message;

//弹出操作成功信息提示框
+ (void)showSuccessMessage:(NSString *)message;

//弹出加载提示框
+ (void)showProgressMessage:(NSString *) message;

//弹出加载提示框,此时屏幕不响应用户点击事件
+ (void)showProgressMessageWithNotAllowTouch:(NSString *)message;

//弹出信息提示框
+ (void)showInfoMessage:(NSString *)message;

//取消弹出框
+ (void)dismissHUD;

/********************** NSDate Utils ***********************/
//根据指定格式将NSDate转换为NSString
+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter;

//根据指定格式将NSString转换为NSDate
+ (NSDate *)dateFromString:(NSString *)dateString formatter:(NSString *)formatter;

//将服务器返回的10位格式时间戳转换成字符串的时间格式(不带 时分秒)
+(NSString *)changeTimeFormatToDate:(NSString *)date;

//将服务器返回的10位格式时间戳转换成字符串的时间格式(带 时分秒)
+(NSString *)changeTimeFormatToTime:(NSString *)date;

//计算某个时间与当前时间的差值(精确计算)
+(NSString *)compareWithCurrentTimeByAccurate:(NSString *)time;

//计算某个时间与当前时间的差值(不精确计算)
+(NSString *)compareWithCurrentTime:(NSString *)time;

//获取当前月份
+(NSString*)getNowMonthString:(NSString*)month;

//对double型数组进行升序排序
+(NSMutableArray *)sortDoubleArrayWithAscend:(NSMutableArray *)array;

//对数组进行排序
+(NSMutableArray *)sortArrayWithArray:(NSMutableArray *)array descend:(BOOL)descend;

/********************* Category Utils **********************/
//根据颜色码取得颜色对象
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

//根据颜色码和透明度,取得颜色对象
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert andAlpha:(float)alpha;

//根据颜色对象和size,取得一张image
+(UIImage *)buttonImageFromColor:(UIColor *)color andSize:(CGSize)size;

/********************* Verification Utils **********************/
//验证手机号码合法性（正则）yes: 合法 no: 非法
+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber;
//正则表达式验证邮箱是否合法
+(BOOL)isValidateEmail:(NSString *)email;
//验证字符串是否为纯数字 yes:全为数字
+ (BOOL)checkNumber:(NSString *)string;

//验证字符串是否全为空格 yes:全为空格
+ (BOOL)checkIsAllSpace:(NSString *)string;

//检查字符串是否包含空格 yes:包含 no:不包含
+ (BOOL)checkContainSpace:(NSString *)string;

//根据字符串以及字体大小,返回size
+(CGSize)getSizeWithText:(NSString *)text font:(UIFont *)font;

//根据字符串以及字体大小,最大size,返回实际size
+(CGSize)getSizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

//根据输入的字符判断是不是合法的ipv4地址
+(BOOL)isValidatIP:(NSString*)ipAddress;
//设备摄像头是否可用 yes:可用
+(BOOL)cameraIsAvailable;

//返回当前网络状态
+(NSString *)returnNetworkState;

@end
