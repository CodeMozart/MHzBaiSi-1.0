//
//  NSDate+MHzExtension.m
//  百思不得姐
//
//  Created by Minghe on 10/17/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "NSDate+MHzExtension.h"

@implementation NSDate (MHzExtension)

/**
 *  是否为今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return selfYear == nowYear;
}

/**
 *  是否为今天
 */
- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *selfComs = [calendar components:unit fromDate:self];
    NSDateComponents *nowComs = [calendar components:unit fromDate:[NSDate date]];
    
    return selfComs.year == nowComs.year && selfComs.month == nowComs.month && selfComs.day == nowComs.day;
}

/**
 *  是否为昨天
 */
- (BOOL)isYesterday
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *selfString = [fmt stringFromDate:self];
    NSDate *selfDate = [fmt dateFromString:selfString];
    
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSDate *nowDate = [fmt dateFromString:nowString];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    // 这里计算的是差值
    // 比如，formDate = 2012-01-18 ; toDate = 2015-10-17 -> coms.year = 3;coms.month = 8 ; coms.day = 29
    // 又如，formDate = 2015-09-30 ; toDate = 2015-10-01 -> coms.year = 0;coms.month = 0 ; coms.day = 1
    NSDateComponents *coms = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    
    return coms.year == 0 && coms.month == 0 && coms.day == 1;
}

/**
 *  是否为明天
 */
- (BOOL)isTomorrow
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *selfString = [fmt stringFromDate:self];
    NSDate *selfDate = [fmt dateFromString:selfString];
    
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSDate *nowDate = [fmt dateFromString:nowString];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *coms = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    
    return coms.year == 0 && coms.month == 0 && coms.day == -1;
}



@end
