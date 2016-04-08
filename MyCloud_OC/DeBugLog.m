//
//  DeBugLog.m
//  MyCloud_OC
//
//  Created by ZEROLEE on 16/4/6.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import "DeBugLog.h"

@implementation DeBugLog

+(void)debugLog:(NSString*)fileName line:(NSInteger)line otherInfo:(NSString*)others,...;
{
#ifdef DEBUG
    va_list args;
    va_start(args, others);
    NSString *str = [[NSString alloc] initWithFormat:others arguments:args];
    va_end(args);
    NSLog( @"\n<文件%@:%ld行> 调试信息:\n%@",fileName,(long)line, str);
#endif
}
@end
