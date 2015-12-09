//
//  MHzAllController.m
//  百思不得姐
//
//  Created by Minghe on 10/15/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzTopicController.h"
#import "MHzNewController.h"
#import "MHzCommentViewController.h"
#import "MHzHTTPSessionManager.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "MHzTopic.h"
#import "MHzTopicCell.h"

@interface MHzTopicController ()
@property (weak, nonatomic) MHzHTTPSessionManager *manager;/**< 请求管理者 */
@property (strong, nonatomic) NSMutableArray<MHzTopic *> *topics;/**< 帖子数据 */
@property (copy, nonatomic) NSString *maxtime;/**< 用来加载下一页数据的参数 */
@end

@implementation MHzTopicController
/***********************************************************************************************************/
#pragma mark -  <manager属性的懒加载>
- (MHzHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [MHzHTTPSessionManager manager];
    }
    return _manager;
}

/***********************************************************************************************************/
#pragma mark -  <初始化>

- (void)viewDidLoad {
    [super viewDidLoad];
    MHzLogFunc;
    [self setupTable];
    
    [self setupRefresh];
    
}

- (MHztopicType)type {return 0;}

/***********************************************************************************************************/
#pragma mark -  <设置页面上的控件>

- (void)setupRefresh
{
    // 添加刷新控件 (MJRefresh)
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    MJRefreshFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
    // 自动调整透明度
    header.automaticallyChangeAlpha = YES;
    // 进入刷新状态(可以一进入页面的时候就刷新)
    [header beginRefreshing];
    self.tableView.header = header;
    self.tableView.footer = footer;
}

- (void)setupTable
{
    // 内边距：
    // 设置contentInset，避免navigationBar 和 tabBar 挡住内容
    self.tableView.contentInset = UIEdgeInsetsMake(MHzNavBarBottom + MHzTitlesViewH, 0, MHzTabBarH, 0);
    // 设置scrollIndicatorInsets，避免navigationBar 和 tabBar 挡住指示器
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    //    // 设置行高
    //    self.tableView.rowHeight = 1000;
    // 分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 背景
    self.tableView.backgroundColor = MHzCommonBgColor;
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MHzTopicCell class]) bundle:nil] forCellReuseIdentifier:@"topicCell"];
    
}

/***********************************************************************************************************/
#pragma mark -  <从服务器上请求数据>

/** 参数a */
- (NSString *)paramA
{
    // isKindOfClass:判断是否为[这种类型]或者是[这种类型的子类型]
    //
    if ([self.parentViewController isKindOfClass:[MHzNewController class]]) {
        // 如果parentViewController是MHzNewController
        return @"newlist";
    }
    
    // 如果parentViewController是MHzEssenceController
    return @"list";
    
    /*
     因为MHzNewController继承MHzEssenceController,所以如果判断isKindOfClass:[MHzEssenceController class],MHzNewController也会通过。
     */
}

- (void)loadNewTopics
{
    // 请求
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.paramA;
    params[@"type"] = @(self.type);
    // params[@"type"] = @1;
    params[@"c"] = @"data";
    
    // 发送请求
    __weak typeof(self) weakSelf = self;
    [self.manager GET:MHzRequestURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        // dictionary array -> model array
        weakSelf.topics = [MHzTopic objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 存储maxtime (这步一定不能少，否则会重复加载数据)
        weakSelf.maxtime = responseObject[@"info"][@"maxtime"];
        
        // refresh
        [weakSelf.tableView reloadData];
        
        // 刷新控件停止
        [weakSelf.tableView.header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        // 刷新控件停止
        [weakSelf.tableView.header endRefreshing];
    }];
    
}

- (void)loadMoreTopics
{
    // 请求
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.paramA;
    params[@"type"] = @(self.type);
    params[@"c"] = @"data";
    params[@"maxtime"] = self.maxtime;
    
    // 发送请求
    __weak typeof(self) weakSelf = self;
    [self.manager GET:MHzRequestURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        
        // 加载数据需要传入maxtime这个参数
        weakSelf.maxtime = responseObject[@"info"][@"maxtime"];
        // dictionary array -> model array
        // 加载的新数据
        NSArray *moreTopics = [MHzTopic objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 增加到以前数组的后面
        [weakSelf.topics addObjectsFromArray:moreTopics];
        
        // refresh
        [weakSelf.tableView reloadData];
        
        // 刷新控件停止
        [weakSelf.tableView.footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        // 刷新控件停止
        [weakSelf.tableView.footer endRefreshing];
    }];
}

/***********************************************************************************************************/
#pragma mark - <数据源>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.topics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MHzTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topicCell"];
    
    
    cell.topic = self.topics[indexPath.row];
    
    return cell;
}

#pragma mark - <代理方法>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // topics的属性定义里面已定要加上泛型
    return self.topics[indexPath.row].cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHzCommentViewController *commentVc = [[MHzCommentViewController alloc] init];
    commentVc.topic = self.topics[indexPath.row];
    [self.navigationController pushViewController:commentVc animated:YES];
}


@end
