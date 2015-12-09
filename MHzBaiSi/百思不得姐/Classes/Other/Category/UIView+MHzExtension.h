//
//  UIView+MHzExtension.h
//  百思不得姐
//
//  Created by Minghe on 10/4/15.
//  Copyright © 2015 project. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  这个方法可以方便的修改和返回frame的各个属性
 */

@interface UIView (MHzExtension)

@property (assign, nonatomic) CGFloat x;/**< <#注释#> */
@property (assign, nonatomic) CGFloat y;/**< <#注释#> */
@property (assign, nonatomic) CGFloat centerX;/**< <#注释#> */
@property (assign, nonatomic) CGFloat centerY;/**< <#注释#> */
@property (assign, nonatomic) CGFloat width;/**< <#注释#> */
@property (assign, nonatomic) CGFloat height;/**< <#注释#> */

@end
