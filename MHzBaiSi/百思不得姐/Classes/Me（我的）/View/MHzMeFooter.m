//
//  MHzMeFooter.m
//  百思不得姐
//
//  Created by Minghe on 10/11/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzMeFooter.h"
#import "MHzHTTPSessionManager.h"
#import <MJExtension.h>
#import "MHzSquare.h"
#import "MHzMeSquareButton.h"
#import <UIButton+WebCache.h>
#import "MHzWebViewController.h"

@interface MHzMeFooter()

@property (strong, nonatomic) NSArray *squares;/**< 方块模型数组 */
@end

@implementation MHzMeFooter

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 加载数据
        
        // request params
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
        
        __weak typeof(self) weakSelf = self;
        // send request
        [[MHzHTTPSessionManager manager] GET:MHzRequestURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            /* "square_list"
             {
             android = "";
             icon = "http://img.spriteapp.cn/ugc/2015/05/20/150532_5078.png";
             id = 28;
             ipad = "";
             iphone = "";
             name = "\U5ba1\U8d34";
             url = "mod://BDJ_To_Check";
             },
            */
            
            // dictionary array -> model array
            NSArray *squareArray = [MHzSquare objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
            
            // create square acorrding to suqaremodel data
            [weakSelf createSquares:squareArray];
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            
            NSLog(@"加载失败----%@",error);
        }];
        
    }
    
    return self;
}

/**
 *  根据模型数据创建方块
 *
 *  @param array 服务器返回的字典数组转成的模型数组
 */
- (void)createSquares:(NSArray *)squares
{
//    _squares = squares;
    
    // total columns
    int columnCount = 4;
    
    NSUInteger count = squares.count;
    
    CGFloat buttonW = self.width / columnCount;
    CGFloat buttonH = buttonW;
    
    for (int i = 0; i < count; i++) {
        MHzMeSquareButton *button = [MHzMeSquareButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        // set frame
        button.x = buttonW * (i % columnCount);
        button.y = buttonH * (i / columnCount);
        button.width = buttonW ;
        button.height = buttonH ;
        
        [self addSubview:button];
        
        // set data
        button.square = squares[i];
        
//        button.tag = i;
    }
    
    
    // 一个计算总行数的公式：总行数 == (总个数 + 每行的最大个数 - 1) / 每行的最大个数;
    // 计算整个footerView的高度,如果不设置footer的高度，页面拖到底部之后会回弹
    // one method:
//    self.height = (count + columnCount - 1) / columnCount * buttonH ;
    
    // another method:
    self.height = self.subviews.lastObject.y + buttonH;
    // 拿到footer父控件的tableView,然后设置footer为tableView的tableFooterView
    // 这样才能成功修改高度
    UITableView *tableView = (UITableView *)self.superview;
    tableView.tableFooterView = self;
    
    // 另外一种去除回弹的方法
//    tableView.contentSize = CGSizeMake(0, self.height+self.y);
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // set footer's frame
}

- (void)buttonClick:(MHzMeSquareButton *)button
{
    // 取出button对应的square模型
    // 1.use tag
//    MHzSquare *suqare = self.squares[button.tag];
    // 2.根据button在父控件中的索引
//    NSUInteger index = [self.subviews indexOfObject:button];
//    MHzSquare *square = self.squares[index];
    
    // 3.use model
    // 链接：
    NSString *url = button.square.url;
    
    // 分情况处理：
    if ([url hasPrefix:@"mod://"]) { // special handle
        
        
        if ([url hasPrefix:@"BDJ_To_Check"]) {
            MHzLog(@"跳转到check控制器");
        } else if ([url hasPrefix:@"App_To_SearchUser"]){
            MHzLog(@"跳转到SearchUser控制器");
        }
        
    } else if ([url hasPrefix:@"http://"]){ // use webView show website
        
        // get current nav
        UITabBarController *root = (UITabBarController *)self.window.rootViewController;
        UINavigationController *nav = root.selectedViewController;
        
        // push
        MHzWebViewController *web = [[MHzWebViewController alloc] init];
        web.url = url;
        web.navigationItem.title = button.square.name;
        [nav pushViewController:web animated:YES];
        
        /*
         web.tabBarItem.title : 底部tabBarButton的标题文字
         web.navigationItem.title : 顶部导航栏的标题文字
         web.title等价于web.tabBarItem.title和web.navigationItem.title
         */
        
        
    } else {
        MHzLog(@"其他");
    }
    
}


@end
