//
//  MHzCommentViewController.m
//  百思不得姐
//
//  Created by Minghe on 10/24/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzCommentViewController.h"
#import "MHzHTTPSessionManager.h"
#import "MHzTopic.h"
#import "MHzComment.h"
#import "MHzCommentCell.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "MHzCommentHeaderView.h"
#import "MHzTopicCell.h"

@interface MHzCommentViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) MHzHTTPSessionManager *manager;/**< 请求管理者 */
@property (strong, nonatomic) NSArray<MHzComment *> *hotestComments;/**< 最热评论 */
@property (strong, nonatomic) NSMutableArray<MHzComment *> *latestComments;/**< 最新评论 */
@property (strong, nonatomic) id top_cmt;/**< 保存最热评论 */
@end

@implementation MHzCommentViewController

static NSString * const MHzCommentCellID = @"comment";
static NSString * const MHzCommentHeaderViewID = @"header";
/***********************************************************************************************************/
#pragma mark -  <lazy>
- (MHzHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [MHzHTTPSessionManager manager];
    }
    return _manager;
}

/***********************************************************************************************************/

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评论";
    
    // 利用通知来监听键盘的弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    [self setupTable];
    [self setupTableHeader];
    
    // 加载数据
    [self loadNewComments];
    
}

- (void)setupTable
{
    self.tableView.backgroundColor = MHzCommonBgColor;
    self.tableView.sectionHeaderHeight = [UIFont systemFontOfSize:16].lineHeight;
    
    // 让cell的高度自动计算
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MHzCommentCell class]) bundle:nil] forCellReuseIdentifier:MHzCommentCellID];
    [self.tableView registerClass:[MHzCommentHeaderView class] forHeaderFooterViewReuseIdentifier:MHzCommentHeaderViewID];
    
    // 刷新控件
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    [self.tableView.header beginRefreshing];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];

}

- (void)setupTableHeader
{
    // 处理模型数据
    if (self.topic.top_cmt) {
        self.top_cmt = self.topic.top_cmt;
        self.topic.top_cmt = nil;
        self.topic.cellHeight = 0;
    }
    
    // 设置tableview头部控件
    UIView *headerView = [[UIView alloc] init];
    
    // 添加cell到headerView中
    MHzTopicCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MHzTopicCell class]) owner:nil options:nil].lastObject;
    
    // cell的frame和模型数据
    cell.topic = self.topic;
    cell.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.topic.cellHeight);
    [headerView addSubview:cell];
    
    headerView.height = cell.height + 2 * MHzMargin;
    self.tableView.tableHeaderView = headerView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
#warning 这里不是很明白……
    if (self.top_cmt) { // 如果有最热评论，就重新赋值评论，重新计算cell
        self.topic.top_cmt = self.top_cmt;
        self.topic.cellHeight = 0;
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // NSLog(@"%@",note);
    // 这个note的打印结果是:
    /*
    NSConcreteNotification 0x7ffef327a4c0 
     {
     name = UIKeyboardWillChangeFrameNotification; 
     userInfo = 
     {
     UIKeyboardAnimationCurveUserInfoKey = 7;
     UIKeyboardAnimationDurationUserInfoKey = "0.25";
     UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {375, 258}}";
     UIKeyboardCenterBeginUserInfoKey = "NSPoint: {187.5, 559}";
     UIKeyboardCenterEndUserInfoKey = "NSPoint: {187.5, 538}";
     UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 451}, {375, 216}}";
     UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 409}, {375, 258}}";
     UIKeyboardIsLocalUserInfoKey = 1;
     }
     }
     */
    // 设置约束值
    CGRect keyboradFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]; // 根据通知字典取出键盘frame
    self.bottomSpace.constant = [UIScreen mainScreen].bounds.size.height - keyboradFrame.origin.y;
    
    // 动画
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
    
}
/***********************************************************************************************************/
#pragma mark -  <获取数据>

/**
 *  获取数据
 */
- (void)loadNewComments
{
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"datalist";
    params[@"hot"] = @"1";
    params[@"c"] = @"comment";
    // 在present这个控制器之前，就已经给self.topic赋过值了
    params[@"data_id"] = self.topic.id;
    
    __weak typeof(self) weakSelf = self;
    [self.manager GET:MHzRequestURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        // 当没有评论数据的时候，responseObject是一个数组，不是一个字典，所以这里要判断一下
        if ([responseObject isKindOfClass:[NSArray class]]) {
            // 结束刷新
            [weakSelf.tableView.header endRefreshing];
            return ;
        }
        
        weakSelf.hotestComments = [MHzComment objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        weakSelf.latestComments = [MHzComment objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [weakSelf.tableView reloadData];
        
        [weakSelf.tableView.header endRefreshing];
        
        NSInteger total = [responseObject[@"total"] integerValue];
        if (weakSelf.latestComments.count == total) {
            weakSelf.tableView.footer.hidden = YES;
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.tableView.header endRefreshing];
    }];
}

/**
 *  加载新数据
 */
 - (void)loadMoreComments
{
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"datalist";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.id;
    params[@"lastcid"] = self.latestComments.lastObject.id;
    
    __weak typeof(self) weakSelf = self;
    [self.manager GET:MHzRequestURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [weakSelf.tableView.footer endRefreshing];
            return ;
        }
        
        NSArray *moreComments = [MHzComment objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [weakSelf.latestComments addObjectsFromArray:moreComments];
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.footer endRefreshing];
        
        NSInteger total = [responseObject[@"total"] integerValue];
        if (weakSelf.latestComments.count == total) {
            weakSelf.tableView.footer.hidden = YES;
        } else {
            [weakSelf.tableView.footer endRefreshing];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [weakSelf.tableView.footer endRefreshing];
    }];
}
/***********************************************************************************************************/
#pragma mark -  <代理方法>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
/***********************************************************************************************************/
#pragma mark -  <数据源>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.hotestComments.count && section == 0) {
        return self.hotestComments.count;
    }
    return self.latestComments.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.hotestComments.count) return 2;
    if (self.latestComments.count) return 1;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHzCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:MHzCommentCellID];
    
    if (self.hotestComments.count && indexPath.section == 0) {
        cell.comment = self.hotestComments[indexPath.row];
    } else {
        cell.comment = self.latestComments[indexPath.row];
    }
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (self.hotestComments.count && section == 0) {
//        return @"最热评论";
//    }
//    return @"最新评论";
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 这里有两种方式，1.可以代码手动创建view,然后返回；2.自定义一个view,像cell那样循环利用
    MHzCommentHeaderView *headerView = [[MHzCommentHeaderView alloc] initWithReuseIdentifier:MHzCommentHeaderViewID];
    
    if (self.hotestComments.count && section == 0) {
        headerView.text = @"最热评论";
    } else {
        headerView.text = @"最新评论";
    }
    
    return headerView;
    
}

@end
