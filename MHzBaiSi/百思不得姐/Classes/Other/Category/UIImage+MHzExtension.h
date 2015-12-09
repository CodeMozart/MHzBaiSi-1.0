//
//  UIImage+MHzExtension.h
//  百思不得姐
//
//  Created by Minghe on 10/9/15.
//  Copyright © 2015 project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MHzExtension)


+ (UIImage *)circleImageNamed:(NSString *)name;

/**
 *  类方法，根据一个图片的名字生成一张对应的圆形图片
 *
 *  @param name 图片名称
 *
 *  @return 圆形图片
 */

/**
 *  将一张图片绘制成圆形图片
 *
 *  @return Image
 */
- (instancetype)circleImage;

+ (instancetype)myImageNamed:(NSString *)name;

@end
