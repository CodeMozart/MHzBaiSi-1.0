//
//  MHzFriendsController.m
//  百思不得姐
//
//  Created by Minghe on 9/28/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzFriendsController.h"
#import "UIBarButtonItem+MHzExtension.h"
#import "MHzRecommendFollowController.h"

@interface MHzFriendsController ()

@end

@implementation MHzFriendsController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = MHzCommonBgColor;
    
    self.navigationItem.title = @"我的关注";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highlightImage:@"friendsRecommentIcon-click" target:self action:@selector(friendsRecommentIcon)];
    
}

/**
 *  左上角推荐关注
 */
- (void)friendsRecommentIcon
{
    [self performSegueWithIdentifier:@"friends2RecommendFollow" sender:nil];
}
/***********************************************************************************************************/

/**
 *  这个方法的作用:用来让其他控制器回到当前控制器
 *  必备格式:1.IBAction 2.有1个UIStoryboardSegue *参数
 */

- (IBAction)backToFriendsController:(UIStoryboardSegue *)segue
{
    MHzLog(@"从%@控制器回来的",segue.sourceViewController);
}


@end
