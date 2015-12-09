//
//  MHzStatusBarViewController.m
//  百思不得姐
//
//  Created by Minghe on 10/26/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzStatusBarViewController.h"

@interface MHzStatusBarViewController ()

@end

@implementation MHzStatusBarViewController

#pragma mark -  <window相关处理>
static UIWindow *window_;
+ (void)show
{
    window_ = [[UIWindow alloc] init];
    window_.backgroundColor = [UIColor clearColor];
    window_.frame = [UIApplication sharedApplication].statusBarFrame;
    window_.hidden = NO;
    window_.windowLevel = UIWindowLevelAlert;
    window_.rootViewController = [[MHzStatusBarViewController alloc] init];
}

#pragma mark -  <控制状态栏>
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark -  <初始化>
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 让scrollView滚动到最前面
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self searchScrollViewInView:window];
}

/**
 *  在view中搜索所有的scrollView
 *
 *  这里利用了递归的思想
 */
- (void)searchScrollViewInView:(UIView *)view
{
    // 遍历所有的子控件
    for (UIView *subview in view.subviews) {
        [self searchScrollViewInView:subview];
    }
    
    // 如果是一个scrollView，就进行滚动处理
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        
        // 计算出scrollView 以window左上角为坐标原点时的rect
        CGRect scrollViewRect = [scrollView convertRect:scrollView.bounds toView:nil];
        CGRect windowRect = scrollView.window.bounds;
        
        // 判断scrollView 跟 window 是否重叠
        if (!CGRectIntersectsRect(windowRect, scrollViewRect)) return;
            
        // 滚到最前面
        CGPoint offset = scrollView.contentOffset;
        offset.y = - scrollView.contentInset.top;
        [scrollView setContentOffset:offset animated:YES];
    }
}

@end
