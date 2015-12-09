//
//  UITextField+MHzExtension.m
//  百思不得姐
//
//  Created by Minghe on 10/5/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "UITextField+MHzExtension.h"

@implementation UITextField (MHzExtension)


/**
 *  这个方法用来设置UITextFiled中占位文字的颜色
 *
 *  @param placeholderColor UIColor参数
 */
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    if (placeholderColor == nil) { // 清空占位文字颜色，恢复默认的占位文字颜色
        [self setValue:MHzGrayColor(255 * 0.6) forKeyPath:MHzPlaceholderColorKey];
    } else {
        
        // 保存之前的占位文字
        NSString *placeholder = self.placeholder;
        
        // 保证placeholder被创建了
        self.placeholder = @" ";
        
        [self setValue:placeholderColor forKeyPath:MHzPlaceholderColorKey];
        
        // 恢复之前的占位文字
        self.placeholder = placeholder;
    }
}


- (UIColor *)placeholderColor
{
    return [self valueForKeyPath:MHzPlaceholderColorKey];
}

@end
