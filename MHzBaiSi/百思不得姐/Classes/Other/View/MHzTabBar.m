//
//  MHzTabBar.m
//  百思不得姐
//
//  Created by Minghe on 9/28/15.
//  Copyright © 2015 project. All rights reserved.
//


/*
 自定义一个tabBar，调整上面item的位置，让添加的按钮可以显示在合适的位置
 */

#import "MHzTabBar.h"

@interface MHzTabBar()

@property (weak, nonatomic) UIButton *publishButton;/**< 发布按钮 */

@end

@implementation MHzTabBar

/**
 一个控件显示不出来的可能原因:
 1.hidden = YES
 2.alpha <= 0.01
 3.没有被添加到屏幕上
 4.没有尺寸
 5.位置不对
 6.可能被其他控件挡住了
 7.文字颜色\背景色跟父控件背景色一致
 8.父控件有1\2\3\6行为
 */

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 设置tabBar的背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
        
        // 添加按钮
        UIButton *publishButton = [[UIButton alloc] init];
        [publishButton setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [publishButton sizeToFit];
        [self addSubview:publishButton];
        self.publishButton = publishButton;
        
    }
    
    return self;
}

// 布局子控件
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    // tabBar的尺寸
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    /**** 发布按钮 ****/
    self.publishButton.center = CGPointMake(w * 0.5, h * 0.5);
    
    /**** 选项卡按钮 ****/
    CGFloat buttonW = w * 1 / 5.0;
    CGFloat buttonH = h;
    CGFloat buttonY = 0;
    
    // 选项卡按钮索引
    int index = 0;
    
    for (UIView *tabBarButton in self.subviews) {
        
        //        NSString *className = NSStringFromClass(tabBarButton.class);
        //
        //        if (![className isEqualToString:@"UITabBarButton"]) continue;
        
        Class clazz = NSClassFromString(@"UITabBarButton");
        if (tabBarButton.class == clazz) {
            
            // tabBarButton的位置
            CGFloat buttonX = index * buttonW;
            
            if (index >= 2) { // 右边两个按钮
                buttonX = (index + 1) * buttonW;
            }
            
            tabBarButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
            
            index++;
        }
    }
    
    
}

@end
