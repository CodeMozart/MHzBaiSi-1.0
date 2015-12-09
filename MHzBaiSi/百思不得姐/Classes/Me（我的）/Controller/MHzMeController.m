//
//  MHzMeController.m
//  百思不得姐
//
//  Created by Minghe on 9/28/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzMeController.h"
#import "MHzSettingController.h"

#import "UIBarButtonItem+MHzExtension.h"
#import "MHzMeCell.h"
#import "MHzMeFooter.h"

#define MHzCacheFilePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"default"]

@interface MHzMeController ()

@end

@implementation MHzMeController

static NSString * const MHzMeCellID = @"MeCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [self setupNav];
    
    /* NSDirectoryEnumerator, attributesOfItemAtPath
     
    NSFileManager *mgr = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:@"/Users/minghe/Desktop/reading"];
    for (NSString *subpath in enumerator) {
        MHzLog(@"%@",subpath);
        
    }
    NSDictionary *dic = [mgr attributesOfItemAtPath:@"/Users/minghe/Desktop/reading" error:nil];
    MHzLog(@"%@",dic);
     
    */
}


#pragma mark -  <viewDidLoad中的方法>
/**
 设置导航
 */
- (void)setupNav
{
    self.navigationItem.title = @"我的";
    
    UIBarButtonItem *rightItem0 = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highlightImage:@"mine-moon-icon-click" target:self action:@selector(mineMoonIcon)];
    
    UIBarButtonItem *rightItem1 = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highlightImage:@"mine-setting-icon-click" target:self action:@selector(mineSettingIcon)];
    
    self.navigationItem.rightBarButtonItems = @[rightItem0,rightItem1];
}


/**
 设置表格
 */
- (void)setupTableView
{
    self.tableView.backgroundColor = MHzCommonBgColor;
    [self.tableView registerClass:[MHzMeCell class] forCellReuseIdentifier:MHzMeCellID];
    
    // 默认情况分组样式的section都默认有footer header,因此在视觉上增加了两个cell之间的间距
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = MHzMargin;
    
    // 让cell距离顶部的距离减少
    self.tableView.contentInset = UIEdgeInsetsMake(MHzMargin - MHzGroupFirstCellY, 0, 0, 0);
    
    self.tableView.tableFooterView = [[MHzMeFooter alloc] init];
}

/***********************************************************************************************************/
#pragma mark -  <Table View Datasource>

/**
 *  gourped style default return 1; we need 2 section
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHzMeCell *cell = [tableView dequeueReusableCellWithIdentifier:MHzMeCellID];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"登陆／注册";
        // @"setup-head-default"
        cell.imageView.image = [UIImage imageNamed:@"setup-head-default"];
    } else {
        cell.textLabel.text = @"离线下载";
        cell.imageView.image = nil; // 写上这句会更加严谨
    }
    
    return cell;
}

/***********************************************************************************************************/
- (void)mineMoonIcon
{
    
}


- (void)mineSettingIcon
{
    MHzSettingController *setting = [[MHzSettingController alloc] initWithStyle:UITableViewStyleGrouped];
    
    [self.navigationController pushViewController:setting animated:YES];
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
