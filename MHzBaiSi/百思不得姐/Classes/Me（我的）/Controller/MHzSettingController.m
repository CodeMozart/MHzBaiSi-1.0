//
//  MHzSettingController.m
//  百思不得姐
//
//  Created by Minghe on 10/13/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzSettingController.h"

#import "MHzClearCacheCell.h"
#import "MHzOtherCell.h"
#import "MHzSettingCell.h"

@interface MHzSettingController ()

@end

static NSString * const MHzClearCacheCellID = @"clearCache";
static NSString * const MHzSettingCellID = @"setting";
static NSString * const MHzOtherCellID = @"other";


@implementation MHzSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    
    [self.tableView registerClass:[MHzClearCacheCell class] forCellReuseIdentifier:MHzClearCacheCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"MHzOtherCell" bundle:nil] forCellReuseIdentifier:MHzOtherCellID];
    [self.tableView registerClass:[MHzSettingCell class] forCellReuseIdentifier:MHzSettingCellID];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 15;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) { // 第一组
        
        if (indexPath.row == 0) { // 第一行
            return [tableView dequeueReusableCellWithIdentifier:MHzClearCacheCellID];
        }
        else {  // 其他行
            MHzSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:MHzSettingCellID];
            if (indexPath.row == 1) {
                cell.textLabel.text = @"检查更新";
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"给我打分";
            } else if (indexPath.row == 3) {
                cell.textLabel.text = @"推送设置";
            } else if (indexPath.row == 4) {
                cell.textLabel.text = @"关于我们";
            }
            return cell;
        }
    }
    else {
        return [tableView dequeueReusableCellWithIdentifier:MHzOtherCellID];
    }
    
   
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
