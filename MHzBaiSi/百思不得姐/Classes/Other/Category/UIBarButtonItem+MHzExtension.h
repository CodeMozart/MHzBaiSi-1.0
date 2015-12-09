//
//  UIBarButtonItem+MHzExtension.h
//  百思不得姐
//
//  Created by Minghe on 9/29/15.
//  Copyright © 2015 project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (MHzExtension)

/**
 *  这个分类的方法是设置UIBarButtonItem中左侧按钮的图片和addTarget
 *
 *  @param image          普通状态下的图片
 *  @param highlightImage 点击状态下的图片
 *  @param target         监听的目标
 *  @param action         监听到之后实现的方法
 *
 *  @return 返回一个UIBarButtonItem
 */
+ (instancetype)itemWithImage:(NSString *)image highlightImage:(NSString *)highlightImage target:(id)target action:(SEL)action;
@end
