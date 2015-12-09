//
//  UIImage+MHzExtension.m
//  百思不得姐
//
//  Created by Minghe on 10/9/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "UIImage+MHzExtension.h"

@implementation UIImage (MHzExtension)

- (instancetype)circleImage
{
    // 开启图形上下文
    UIGraphicsBeginImageContext(self.size);
    
    // 获得图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 在上下文上绘制一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(context, rect);
    
    // 裁剪
    CGContextClip(context);
    
    // 绘制图片到上下文中
    [self drawInRect:rect];
    
    // 从上下文中获得最终的图片
    UIImage *circleImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    
    return circleImage;
    
}

+ (UIImage *)circleImageNamed:(NSString *)name
{
    return [[self imageNamed:name] circleImage];
}

+ (instancetype)myImageNamed:(NSString *)name
{
    return [UIImage imageNamed:name];
}


@end
