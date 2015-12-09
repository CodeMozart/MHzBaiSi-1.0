//
//  MHzRecommendFollowController.m
//  百思不得姐
//
//  Created by Minghe on 10/24/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzRecommendFollowController.h"
#import "MHzHTTPSessionManager.h"
#import "MHzRecommendCategory.h"
#import "MHzRecommendCategoryCell.h"
#import "MHzRecommendUser.h"
#import "MHzRecommendUserCell.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import <SVProgressHUD.h>

@interface MHzRecommendFollowController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *userTable;
@property (weak, nonatomic) IBOutlet UITableView *categoryTable;
@property (strong, nonatomic) NSArray<MHzRecommendCategory *> *categories;/**< 所有推荐类别数据 */
//@property (strong, nonatomic) NSArray<MHzRecommendUser *> *users;/**< 所有推荐用户数据 */
@property (weak, nonatomic) MHzHTTPSessionManager *manager;/**< 网络请求管理者 */
@end

@implementation MHzRecommendFollowController
/***********************************************************************************************************/
#pragma mark -  <cell的重用标识>
static NSString * const MHzRecommendCategoryCellID = @"category";
static NSString * const MHzUserCellID = @"user";

/***********************************************************************************************************/
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MHzCommonBgColor;
    [self setTable];
    [self loaCategories];
    
}
/***********************************************************************************************************/
- (MHzHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [MHzHTTPSessionManager manager];
    }
    return _manager;
}
/***********************************************************************************************************/
#pragma mark -  <UI设置>
/**
 *  设置表格（内边距等）
 */
- (void)setTable
{
    UIEdgeInsets inset = UIEdgeInsetsMake(MHzNavBarBottom, 0, 0, 0);
    self.categoryTable.contentInset = inset;
    self.categoryTable.scrollIndicatorInsets = inset;
    self.userTable.contentInset = inset;
    self.userTable.scrollIndicatorInsets = inset;
    
    // 增加header,用来进行下来刷新
    self.userTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewRecommendUsers)];
    // 增加footer，用来上拉加载更多数据
    self.userTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreRecommendUsers)];
}
/***********************************************************************************************************/
#pragma mark -  <请求数据>
/**
 *  加载推荐关注类别的数据
 */
- (void)loaCategories
{
    // 设置一个蒙板，这样网速不佳的情况下可以看到数据正在加载
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";
    // 发送请求
    __weak typeof(self) weakSelf = self;
    [self.manager GET:MHzRequestURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // 字典数组 －> 模型数组
        weakSelf.categories = [MHzRecommendCategory objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 刷新表格
        [weakSelf.categoryTable reloadData];
        
#warning 这个方法应该记住
        // 默认选中第0行
        [weakSelf.categoryTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        // 对应的用户表格的头部自动刷新
        [weakSelf.userTable.header beginRefreshing];
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
}

/**
 *  首次加载用户数据（下拉刷新）
 */
- (void)loadNewRecommendUsers
{
    // 取消之前的请求，避免用户点击过快，不清楚应该返回哪一个数据
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 当前选中的类别模型
    MHzRecommendCategory *category = self.categories[self.categoryTable.indexPathForSelectedRow.row];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = category.id;
    
    // 发送请求
    __weak typeof(self) weakSelf = self;
    [self.manager GET:MHzRequestURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // 赋值新页码
        category.page = 1;
        // 字典数组——>模型数组
        category.users = [MHzRecommendUser objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 记录总数
        category.total = [responseObject[@"total"] integerValue];
        // 刷新表格
        [weakSelf.userTable reloadData];
        // 下拉刷新停止
        [weakSelf.userTable.header endRefreshing];
        //
        if (category.users.count == category.total) {
            weakSelf.userTable.footer.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [weakSelf.userTable.header endRefreshing];
    }];
}

/**
 *  加载更多用户数据（上拉刷新）
 */
- (void)loadMoreRecommendUsers
{
    // 取消之前的请求，避免用户点击过快，不清楚应该返回哪一个数据
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 当前选中的类别模型
    MHzRecommendCategory *category = self.categories[self.categoryTable.indexPathForSelectedRow.row];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = category.id;
    NSInteger page = category.page + 1;
    params[@"page"] = @(page);
    
    // 发送请求
    __weak typeof(self) weakSelf = self;
    [self.manager GET:MHzRequestURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // 赋值新页码
        category.page = page;
        // 字典数组——>模型数组
        NSArray *moreUsers = [MHzRecommendUser objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [category.users addObjectsFromArray:moreUsers];
        // 记录总数
        category.total = [responseObject[@"total"] integerValue];
        // 刷新表格
        [weakSelf.userTable reloadData];
        
        // 结束刷新
        if (category.users.count == category.total) { // 用户数据全部加载完毕－提醒用户加载完全
            weakSelf.userTable.footer.hidden = YES;
        } else { // 用户数据还未完全加载－仅结束本次刷新
            [weakSelf.userTable.footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [weakSelf.userTable.header endRefreshing];
    }];
}

/***********************************************************************************************************/
#pragma mark -  <Table View Datasource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.categoryTable) { // 类别表格
        return self.categories.count;
    } else { // 用户表格
        return self.categories[self.categoryTable.indexPathForSelectedRow.row].users.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.categoryTable) {
        MHzRecommendCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:MHzRecommendCategoryCellID];
        
        if (!cell) {
            cell = [[MHzRecommendCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MHzRecommendCategoryCellID];
        }
        
        cell.category = self.categories[indexPath.row];
        
        return cell;
    }
    
    else {
        MHzRecommendUserCell *cell = [tableView dequeueReusableCellWithIdentifier:MHzUserCellID];
        
        if (!cell) {
            cell = [[MHzRecommendUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MHzUserCellID];
        }
        
        cell.recommendUser = self.categories[self.categoryTable.indexPathForSelectedRow.row].users[indexPath.row];
        
        return cell;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.categoryTable) {
        MHzRecommendCategory *category = self.categories[indexPath.row];
        
        // 如果这个被选中的类别没有任何用户数据
        if (category.users.count == 0) {
            // 让用户表格进入下拉刷新状态
            [self.userTable.header beginRefreshing];
        }
        
        // 刷新右侧表格
        [self.userTable reloadData];
        
        // 控制footer需要显示还是隐藏，如果这里不设置，则需要footer刷新一次才能判断，因为另外一个判断的节点在loadMore...方法里
        if (category.users.count == category.total) {
            self.userTable.footer.hidden = YES;
        }
        
    } else {
        
        
    }
}


@end
