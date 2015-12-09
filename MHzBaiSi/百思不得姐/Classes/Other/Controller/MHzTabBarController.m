//
//  MHzTabBarController.m
//  百思不得姐
//
//  Created by Minghe on 9/28/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzTabBarController.h"

#import "MHzEssenceController.h"
#import "MHzNewController.h"
#import "MHzMeController.h"
#import "MHzFriendsController.h"
#import "MHzNavigationController.h"
#import "NSString+MHzExtension.h"

#import "MHzTabBar.h"

@interface MHzTabBarController ()

@end

@implementation MHzTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabBar];
    
    [self setupItemTextArrts];
    
    [self setupChildVCs];
 
}


// 处理tabBar
- (void)setupTabBar{
    
//    self.tabBar = [[MHzTabBar alloc] init];
    [self setValue:[[MHzTabBar alloc] init] forKeyPath:@"tabBar"];
    
}


// 设置字体属性
- (void)setupItemTextArrts
{
    // 普通状态下文字的属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    
    // 选中状态下文字的属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    // 方法或者属性后面有个UI_APPEARANCE_SELECTOR宏,才可以通过appearance对象统一设置
    // 统一设置所有UITabBarItem的文字属性
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
 
}

// 添加所有控制器
- (void)setupChildVCs
{
    // 精华
    MHzEssenceController *essence = [[MHzEssenceController alloc] init];
    [self setupOneChildVC:[[MHzNavigationController alloc] initWithRootViewController:essence] title:@"精华" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    
    // 最新
    MHzNewController *new = [[MHzNewController alloc] init];
    [self setupOneChildVC:[[MHzNavigationController alloc] initWithRootViewController:new] title:@"最新" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];

    // 关注
    MHzFriendsController *friends = [UIStoryboard storyboardWithName:NSStringFromClass([MHzFriendsController class]) bundle:nil].instantiateInitialViewController;
    [self setupOneChildVC:[[MHzNavigationController alloc] initWithRootViewController:friends] title:@"关注" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    
    // 我的
    //!!!: 这里把控制器的样式设置为grouped
    MHzMeController *me = [[MHzMeController alloc] initWithStyle:UITableViewStyleGrouped];
    [self setupOneChildVC:[[MHzNavigationController alloc] initWithRootViewController:me] title:@"我的" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
    

}

// 添加一个控制器
- (void)setupOneChildVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    
    vc.tabBarItem.title = title;
    [vc.tabBarItem setImage:[UIImage imageNamed:image]];
    [vc.tabBarItem setSelectedImage:[UIImage imageNamed:selectedImage]];
//    vc.view.backgroundColor = MHzRandomColor;
    [self addChildViewController:vc];
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
