//
//  MHzTopic.m
//  百思不得姐
//
//  Created by Minghe on 10/16/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzTopic.h"
#import "MHzUser.h"

@implementation MHzTopic

/*
 1.今年
 1> 今天
 1) 时间间隔 >= 1个小时 -> 5小时前
 2) 1个小时 > 时间间隔 >= 1分钟 -> 25分钟前
 3) 时间间隔 < 1分钟 -> 刚刚
 
 2> 昨天 -> 昨天 17:56:34
 
 3> 其他 -> 07-06 19:47:57
 
 2.非今年 -> 2014-08-06 19:47:57
 */

- (NSString *)created_at
{
    // 服务器返回的日期
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *createdAtDate = [fmt dateFromString:_created_at];
    
    if (createdAtDate.isThisYear) { // is this year
        if (createdAtDate.isToday) { // is today
            
            NSDate *nowDate = [NSDate date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *coms = [calendar components:unit fromDate:createdAtDate toDate:nowDate options:0];
            
            if (coms.hour >= 1) { // & more than 1 hour
                return [NSString stringWithFormat:@"%zd小时前",coms.hour];
            } else if (coms.minute >= 1) { // & less than 1 hour but more than 1minute
                return [NSString stringWithFormat:@"%zd分钟前",coms.minute];
            } else { // less than 1 minute
                return @"刚刚";
            }
        } else if (createdAtDate.isYesterday) { // is yesterday
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:createdAtDate];
        }
        else { // this year's other days
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:createdAtDate];
        }
    } else { // is an other year
        return _created_at;
    }
    

    
}

/*
- (CGRect)centerViewFrame
{
    // 中间控件的x值
    CGFloat centerViewX = MHzMargin;
    
    // 文字的y值
    CGFloat textY = 60;
    CGFloat textMaxW = [UIScreen mainScreen].bounds.size.width - 2 * MHzMargin;
    // 文字的高度
    CGFloat textH = [self.text boundingRectWithSize:CGSizeMake(textMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
    
    // 中间控件的y值
    CGFloat centerViewY = textY + textH + MHzMargin;
    
    // 中间控件d的宽度
    CGFloat centerViewW = textMaxW;
    
    // 中间控件d的高度
    CGFloat centerViewH = centerViewW / self.width * self.height;
    
    if (centerViewH >= [UIScreen mainScreen].bounds.size.height) { // 判断是否为大图
        centerViewH = 200;
        self.bigPicture = YES;
    }
    
    return CGRectMake(centerViewX, centerViewY, centerViewW, centerViewH);
}
*/

/**
 *  在这个方法中计算了cellHeight和centerViewFrame （程序会先调用heightForRow方法，后调用cellForRow方法，所以centerViewFrame不用担心没有值）
 */
- (CGFloat)cellHeight
{
    // 如果已经计算过cellHeight，就直接返回以前的值
    if (_cellHeight) return _cellHeight;

    // 文字的y值
    CGFloat textY = 60;
    CGFloat textMaxW = [UIScreen mainScreen].bounds.size.width - 2 * MHzMargin;
    // 文字的高度
    CGFloat textH = [self.text boundingRectWithSize:CGSizeMake(textMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
    _cellHeight = textY + textH + MHzMargin;
    
    if (self.type != MHzTopicTypeText) { // 有中间内容
        
            // 中间控件的x值
            CGFloat centerViewX = MHzMargin;
            // 中间控件的y值
            CGFloat centerViewY = textY + textH + MHzMargin;
            // 中间控件d的宽度
            CGFloat centerViewW = textMaxW;
            // 中间控件d的高度
            CGFloat centerViewH = centerViewW / self.width * self.height;
            
            if (centerViewH >= [UIScreen mainScreen].bounds.size.height) { // 判断是否为大图
                centerViewH = 200;
                self.bigPicture = YES;
            }
            // 计算中间控件的frame
            _centerViewFrame = CGRectMake(centerViewX, centerViewY, centerViewW, centerViewH);
        
        _cellHeight += self.centerViewFrame.size.height + MHzMargin;
    }
    
    if (self.top_cmt) { // 有最热评论
        CGFloat topCommentTitleH = 18;
        NSString *topCommentText = [NSString stringWithFormat:@"%@ : %@",self.top_cmt.user.username, self.top_cmt.content];
        CGFloat topCommentTextH = [topCommentText boundingRectWithSize:CGSizeMake(textMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
        
        _cellHeight += topCommentTitleH + topCommentTextH + MHzMargin;
    }
    
    // 底部工具条
    CGFloat toolBarH = 30;
    _cellHeight += toolBarH + MHzMargin;
    
    return _cellHeight;
}



























@end
