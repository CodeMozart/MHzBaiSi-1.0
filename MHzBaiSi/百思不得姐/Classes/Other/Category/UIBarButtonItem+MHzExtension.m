//
//  UIBarButtonItem+MHzExtension.m
//  百思不得姐
//
//  Created by Minghe on 9/29/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "UIBarButtonItem+MHzExtension.h"

@implementation UIBarButtonItem (MHzExtension)

+ (instancetype)itemWithImage:(NSString *)image highlightImage:(NSString *)highlightImage target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
