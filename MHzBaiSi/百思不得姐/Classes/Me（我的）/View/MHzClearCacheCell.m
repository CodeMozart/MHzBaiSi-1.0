//
//  MHzClearCacheCell.m
//  百思不得姐
//
//  Created by Minghe on 10/13/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzClearCacheCell.h"
#import <SVProgressHUD.h>
#import <SDImageCache.h>

/** 缓存路径 */
#define MHzCacheFilePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"default"]

@implementation MHzClearCacheCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 初始化文字
        self.textLabel.text = @"清除缓存";
        
        // 禁止点击 （方法二）
        self.userInteractionEnabled = NO;
        
        // 右边显示圈圈
        
        //!!!: loadingView滚动出界面之后，动画会自动停止
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingView startAnimating];
        self.accessoryView = loadingView;
        
        // 在子线程计算缓存大小
        [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
           
            // 单位
            double unit = 1000.0;
            // 缓存大小
            unsigned long long fileSize = MHzCacheFilePath.fileSize;
            
//            unsigned long long fileSize = @"/Users/minghe/Desktop".fileSize;
            
            // 标签文字
            NSString *fileSizeText = nil;
            if (fileSize >= pow(unit, 3)) {
                fileSizeText = [NSString stringWithFormat:@"%.2fGB",fileSize / pow(unit, 3)];
            } else if (fileSize >= pow(unit, 2)){
                fileSizeText = [NSString stringWithFormat:@"%.2fMB",fileSize / pow(unit, 2)];
            } else if (fileSize >= unit) {
                fileSizeText = [NSString stringWithFormat:@"%.2fKB",fileSize / unit];
            } else { // < 1KB
                fileSizeText = [NSString stringWithFormat:@"%zdB",fileSize];
            }
            NSString *text = [NSString stringWithFormat:@"清除缓存（%@）",fileSizeText];
            
            // 回到主线程
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                // 设置标签文字
                self.textLabel.text = text;
                // 去掉圈圈
                self.accessoryView = nil;
                self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                // 恢复点击
                self.userInteractionEnabled = YES;
                
            }];
            
        }];
        
        // 给cell添加一个tap手势
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearMyCache)]];
        
    }
    
    
    return self;
}

/** 清除缓存 */
- (void)clearMyCache
{
    // 在计算的时候点击无效 (方法一)
//    if (self.accessoryView) return;
    
    // 弹框
    [SVProgressHUD showWithStatus:@"正在清除缓存..." maskType:SVProgressHUDMaskTypeBlack];
    
    // 在子线程进行删除操作
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 删除缓存文件夹
        [[NSFileManager defaultManager] removeItemAtPath:MHzCacheFilePath error:nil];
        
        // 在主线程里执行其他操作
        dispatch_async(dispatch_get_main_queue(), ^{
            // 隐藏弹框
            [SVProgressHUD dismiss];
            // 修改文字
            self.textLabel.text = @"清除缓存（0B）";
            
        });
        
    });
    
    MHzLog(@"清除成功……");
    
    // 利用SDWebImage的方法清除图片缓存
//    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
//        
//    }];
    
}

/**
 *  1.当控件显示到屏幕上的时候会调用一次layoutSubviews
    2.当控件的尺寸发生改变时会调用一次layoutSubviews
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 当cell离开屏幕时, UIActivityIndicatorView的动画就会被自动停止
    
    // 当cell重新显示到屏幕上时, 应该重新开始UIActivityIndicatorView的动画
    UIActivityIndicatorView *loadingView = (UIActivityIndicatorView *)self.accessoryView;
    [loadingView startAnimating];
    
}

@end
