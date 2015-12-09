//
//  MHzTopicCenterView.m
//  百思不得姐
//
//  Created by Minghe on 10/23/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzTopicCenterView.h"
#import "MHzSeeBigController.h"

@interface MHzTopicCenterView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation MHzTopicCenterView

+ (instancetype)centerView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib
{
    // 去除默认的autoresizing设置
    self.autoresizingMask = UIViewAutoresizingNone;
    
    
    // 让图片控件允许交互，以便能够识别点击
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)]];
    
}

// 点击图片弹出大图
- (void)imageClick
{
    if (self.imageView.image == nil) return;
    
    MHzSeeBigController *seeBig = [[MHzSeeBigController alloc] initWithNibName:NSStringFromClass([MHzSeeBigController class]) bundle:nil];
    seeBig.topic = self.topic;
    [self.window.rootViewController presentViewController:seeBig animated:YES completion:nil];
}

@end
