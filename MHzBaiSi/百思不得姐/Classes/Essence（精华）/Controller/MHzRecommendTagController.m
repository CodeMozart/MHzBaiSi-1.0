//
//  MHzRecommendTagController.m
//  百思不得姐
//
//  Created by Minghe on 9/29/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzRecommendTagController.h"
#import "MHzRecommendTag.h"
#import "MHzRecommendTagCell.h"
#import "MHzHTTPSessionManager.h"

#import <MJExtension.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD.h>



/***********************************************************************************************************/
@interface MHzRecommendTagController()

/**< 所有的标签数据（数组中存放的都是MHzRecommendTag模型） */
@property (strong, nonatomic) NSArray *recommandTags;

@property (strong, nonatomic) MHzHTTPSessionManager *manager;/**< 请求管理者 */

@end

/***********************************************************************************************************/
@implementation MHzRecommendTagController

/**
 *  manager属性的懒加载
 *
 *  @return AFHTTPSessionManager
 */
- (MHzHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [MHzHTTPSessionManager manager];
    }
    return _manager;
}

// cell的重用标识
static NSString * const MHzRecommendTagCellID = @"recommendTag";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"推荐标签";
    
    [self loadNewRecommendTags];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MHzRecommendTagCell class]) bundle:nil] forCellReuseIdentifier:MHzRecommendTagCellID];
    
    self.tableView.rowHeight = 70;
    
    // 去掉自带的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    /**
     *  让Cell之间存在分隔线的方法：
     *  1.在cell里面加一个灰色的UIView控件，放在最下面。但是这种方法的性能比较差
     *  2.在确定了cell位置的情况下，让cell的高度减少1，然后背景设置为灰色 (重写cell中的setFrame方法)
     */
    
    self.view.backgroundColor = MHzCommonBgColor;
}


/***********************************************************************************************************/
#pragma mark -  <加载数据及弹窗提醒>
/**
 *  从服务器获数据,以及弹窗的处理
 */
- (void)loadNewRecommendTags
{
    // 显示弹框
    [SVProgressHUD show];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";
    
    /**
     *  发送get请求
     *
     *  @param GET：url地址
     *  @param parameters：请求参数字典
     *  @param success：请求成功调用的block
     *  @param failure：请求失败调用的block
     *
     */
    
    // @"http://api.budejie.com/api/api_open.php"
    [self.manager GET:MHzRequestURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        // responseObject是服务器返回的字典数组
        /**
         *  利用MJExtension字典数组转模型数组
         */
        self.recommandTags = [MHzRecommendTag objectArrayWithKeyValuesArray:responseObject];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 隐藏弹框
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        // 如果是因为取消任务而来到这个block，直接返回
        if (error.code == NSURLErrorCancelled) return;
        
        [SVProgressHUD dismiss];
        
        // 提示失败信息
        [SVProgressHUD showErrorWithStatus:@"加载推荐标签数据失败"];
        
    }];
}

- (void)dealloc
{
    MHzLogFunc;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    // 隐藏弹框
    [SVProgressHUD dismiss];
    
    // 取消当前所有请求
    
    // 使session无效，并取消任务
    [self.manager invalidateSessionCancelingTasks:YES];
    
    // 取消所有进行中的任务
//    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
}

/***********************************************************************************************************/
#pragma mark -  <Table View Datasource>
/**
 <#Description#>
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recommandTags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHzRecommendTagCell *cell = [tableView dequeueReusableCellWithIdentifier:MHzRecommendTagCellID];
    
    cell.recommendTag = self.recommandTags[indexPath.row];
    
    return cell;
}







































@end
