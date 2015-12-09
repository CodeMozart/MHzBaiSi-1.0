//
//  UIImageView+MHzExtension.h
//  百思不得姐
//
//  Created by Minghe on 10/9/15.
//  Copyright © 2015 project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (MHzExtension)

/**
*  根据一个图片的地址，给对应UIImageView设置头像图片
*
*  @param url 需要设置为头像的图片的地址
*/
- (void)setHeaderWithURL:(NSString *)url;

/**
 *  根据一个图片的地址，给对应UIImageView设置圆形头像图片
 *
 *  @param url 需要设置为头像的图片的地址
 */
- (void)setCircleHeaderWithURL:(NSString *)url;

/**
 *  根据一个图片的地址，给对应UIImageView设置方形头像图片
 *
 *  @param url 需要设置为头像的图片的地址
 */
- (void)setRectHeaderWithURL:(NSString *)url;

@end
