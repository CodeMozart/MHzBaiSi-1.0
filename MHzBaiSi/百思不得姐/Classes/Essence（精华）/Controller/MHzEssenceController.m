//
//  MHzEssenceController.m
//  百思不得姐
//
//  Created by Minghe on 9/28/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzEssenceController.h"
#import "MHzTextController.h"
#import "MHzImageController.h"
#import "MHzSoundController.h"
#import "MHzVideoController.h"
#import "MHzAllController.h"

#import "UIBarButtonItem+MHzExtension.h"
#import "MHzRecommendTagController.h"
#import "MHzTitleButton.h"

@interface MHzEssenceController ()<UIScrollViewDelegate>
@property (weak, nonatomic) UIButton *selectedButton;/**< 选中的按钮 */
@property (weak, nonatomic) UIView *titleIndicatorView;/**< 标题指示器 */
@property (weak, nonatomic) UIScrollView *scrollView;/**< 存放子控制器的scrollView */
@property (strong, nonatomic) NSMutableArray *titleButtons;/**< 装标题按钮的数组 */
@end

@implementation MHzEssenceController

- (NSMutableArray *)titleButtons
{
    if (_titleButtons == nil) {
        NSMutableArray *titleButtons = [NSMutableArray array];
        _titleButtons = titleButtons;
    }
    return _titleButtons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupChildControllers];
    [self setupNav];
    [self setupScrollView];
    [self setupTitleView];
    
    // 根据scrollView的偏移量添加子控制器
    [self getChildVcView];
    
    
}

/***********************************************************************************************************/
#pragma mark -  <页面布局设置>
/**
 *  设置子控制器
 *
 */
- (void)setupChildControllers
{
    MHzAllController *allVc = [[MHzAllController alloc] init];
    allVc.title = @"全部";
    [self addChildViewController:allVc];
    
    MHzVideoController *videoVc = [[MHzVideoController alloc] init];
    videoVc.title = @"视频";
    [self addChildViewController:videoVc];
    
    MHzTextController *textVc = [[MHzTextController alloc] init];
    textVc.title = @"段子";
    [self addChildViewController:textVc];
    
    MHzSoundController *soundVc = [[MHzSoundController alloc] init];
    soundVc.title = @"声音";
    [self addChildViewController:soundVc];
    
    MHzImageController *imageVc = [[MHzImageController alloc] init];
    imageVc.title = @"图片";
    [self addChildViewController:imageVc];
}

/**
 添加scrollView
 */
- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    // 禁止掉（自己设置scrollView的那边距）
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView = scrollView;
    // 容控制器成为scrollView的代理
    scrollView.delegate = self;
    
    
    // 设置scrollView的内容大小
    scrollView.contentSize = CGSizeMake(scrollView.width * self.childViewControllers.count, 0);
    
    // 设置分页
    scrollView.pagingEnabled = YES;
    
    /*
    for (int i = 0 ; i < self.childViewControllers.count; i ++) {
        UITableViewController *topicVc = self.childViewControllers[i];
       
        topicVc.tableView.x = i * scrollView.width;
        topicVc.tableView.y = 0;
        topicVc.tableView.width = scrollView.width;
        topicVc.tableView.height = scrollView.height;
        topicVc.tableView.backgroundColor = MHzRandomColor;
        
        // 设置contentInset，避免navigationBar 和 tabBar 挡住内容
        topicVc.tableView.contentInset = UIEdgeInsetsMake(MHzNavBarBottom + MHzTitlesViewH, 0, 44, 0);
        // 设置scrollIndicatorInsets，避免navigationBar 和 tabBar 挡住指示器
        topicVc.tableView.scrollIndicatorInsets = topicVc.tableView.contentInset;
        
        [scrollView addSubview:topicVc.view];
    }
     */   // 一次性加载全部控制器
    
}

/**
 添加标题栏
 */
- (void)setupTitleView
{
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(0, 64, self.view.width, 40);
    titleView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [self.view addSubview:titleView];
    
    NSArray *titleName = @[@"全部",@"视频",@"段子",@"声音",@"图片"];
    CGFloat buttonW = self.view.width / 5.0 ;
    CGFloat buttonH = titleView.height;
    for (int i = 0; i < 5; i++) {
        
        MHzTitleButton *titleButton = [[MHzTitleButton alloc] init];
        [self.titleButtons addObject:titleButton];
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        titleButton.frame = CGRectMake(i * buttonW, 0, buttonW, buttonH);
        [titleButton setTitle:titleName[i] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [titleView addSubview:titleButton];
        
    }
    
    // 创建选中按钮下面的指示器
    // 1.
    MHzTitleButton *firstButton = titleView.subviews.firstObject; // 取出第一个按钮
    self.selectedButton = firstButton;
    self.selectedButton.selected = YES;
    // 让title的size和里面的文字大小一样,这里一定要提前计算，否则默认选中的按钮的titleLabe.size为空
    [firstButton.titleLabel sizeToFit];
    
    // 2.
    UIView *indicatorView = [[UIView alloc] init];
    [titleView addSubview:indicatorView];
    indicatorView.backgroundColor = [firstButton titleColorForState:UIControlStateSelected];
    indicatorView.height = 1;
    indicatorView.y = titleView.height - indicatorView.height;
    indicatorView.width = firstButton.titleLabel.width;
    indicatorView.centerX = firstButton.centerX;
    self.titleIndicatorView = indicatorView;
    
}

/**
 设置导航栏
 */
- (void)setupNav
{
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highlightImage:@"MainTagSubIconClick" target:self action:@selector(mainTagSubIcon)];
    
    self.view.backgroundColor = MHzCommonBgColor;
}


/***********************************************************************************************************/
#pragma mark -  <代理方法>
/**
 用于监听页面的滑动和按钮的点击
 */

/**
 *  scrollView停止滚动的时候会调用1次(人为拖拽导致的停止滚动才会触发这个方法)
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger index = self.scrollView.contentOffset.x / self.scrollView.width;
    [self titleButtonClick:self.titleButtons[index]];
    /* 
     这里虽然点击了一次按钮，在按钮方法中有"setContentOffset：animated:"，但是仍然不
     用“scrollViewDidEndScrollingAnimation”方法，因为self.scrollView.contentOffset和offset相同，
     所以不会发生动画，代理方法也就不会调用
     */
    
    [self getChildVcView];
}

/**
 * 如果通过setContentOffset:animated:让scrollView[进行了滚动动画], 那么最后会在停止滚动时调用这个方法
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self getChildVcView];
}


/***********************************************************************************************************/
#pragma mark -  <点击方法>
/**
 
 */
- (void)mainTagSubIcon
{
    MHzRecommendTagController *tagVC = [[MHzRecommendTagController alloc] init];
    [self.navigationController pushViewController:tagVC animated:YES];
}

- (void)titleButtonClick:(MHzTitleButton *)titleButton
{
    self.selectedButton.selected = NO;
    titleButton.selected = YES;
    self.selectedButton = titleButton;
    
    [UIView animateWithDuration:.25 animations:^{

        self.titleIndicatorView.width = self.selectedButton.titleLabel.width;
        self.titleIndicatorView.centerX = self.selectedButton.centerX;
    }];
    
    NSUInteger index = [self.titleButtons indexOfObject:titleButton];
    
    
    // 滚动scrollView
    CGPoint offset = self.scrollView.contentOffset;
    
    offset.x = index * self.scrollView.width;
    [self.scrollView setContentOffset:offset animated:YES]; // 会调用代理方法
}


/**
 *  根据scrollView的偏移量的添加子控制器的view
 */
- (void)getChildVcView
{

    NSInteger index = self.scrollView.contentOffset.x / self.scrollView.width;
    UIViewController *willShowVc = self.childViewControllers[index];
    // 如果已经加载了，就返回，不用再设置一次frame
    if (willShowVc.isViewLoaded) return;
    [self.scrollView addSubview:willShowVc.view];
    // 设置子控制器的frame 
    willShowVc.view.frame = self.scrollView.bounds;
    
}


@end
