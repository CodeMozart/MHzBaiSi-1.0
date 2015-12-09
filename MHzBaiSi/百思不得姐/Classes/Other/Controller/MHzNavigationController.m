//
//  MHzNavigationController.m
//  百思不得姐
//
//  Created by Minghe on 10/1/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzNavigationController.h"

@interface MHzNavigationController()<UIGestureRecognizerDelegate>

@end

@implementation MHzNavigationController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置手势代理，因为自定义了pushViewController的方法后，侧拉返回的手势功能会丧失掉
    self.interactivePopGestureRecognizer.delegate = self;
    
}



/* 重写push方法，拦截整个push过程，拿到push得到的控制器
 viewController 当前push进来的子控制器
 在这里统一设置，让push进来的控制器左上角都是要求样式的返回按钮
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 需要做一个判断，只让非栈底控制器加上左上角的返回按钮。最开始push进来的四个栈底控制器并不需要
    if (self.childViewControllers.count > 0) {
        
        // push的时候，隐藏底部条
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIButton *backButton = [[UIButton alloc] init];
        // 设置按钮上的文字
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        backButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        // 设置按钮上的图片
        [backButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        [backButton sizeToFit];
        // 让按钮向左边移动一定距离
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        // 监听按钮点击
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        // 这里设置的是push进来的子控制器的左上角
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
    }
    
    
    [super pushViewController:viewController animated:YES];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}


#pragma mark -  <手势代理>
/**
 这个代理方法的作用：决定pop手势是否有有效
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.viewControllers.count > 1;
}





























@end


