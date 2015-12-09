//
//  MHzTopicPictureView.m
//  百思不得姐
//
//  Created by Minghe on 10/18/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzTopicPictureView.h"
#import <UIImageView+WebCache.h>
#import "MHzTopic.h"
#import <DALabeledCircularProgressView.h>
#import "MHzSeeBigController.h"

@interface MHzTopicPictureView()
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureBtn;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;

@end


@implementation MHzTopicPictureView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.progressView.roundedCorners = 5;
    self.progressView.progressLabel.textColor = [UIColor whiteColor];
}

- (void)setTopic:(MHzTopic *)topic
{
    [super setTopic:topic];
    
    // 显示图片
    [_imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        if (receivedSize < 0 || expectedSize < 0) return;
        
        // 下载中，显示
        self.placeholderView.hidden = NO;
        self.progressView.hidden = NO;
        
        // 下载进度
        CGFloat progress = 1.0 *receivedSize / expectedSize;
        self.progressView.progress = progress;
        self.progressView.progressLabel.text = [NSString stringWithFormat:@"%.2f%%",progress * 100];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 下载完成,隐藏
        self.placeholderView.hidden = YES;
        self.progressView.hidden = YES;
        
    }];
    
    // 判断是否为gif
    self.gifView.hidden = !topic.is_gif;
    
    // 查看大图
    self.seeBigPictureBtn.hidden = !topic.bigPicture;
    if (topic.isBigPicture) { // 如果是大图的话，就采用这种填充方式
        _imageView.contentMode = UIViewContentModeTop;
        _imageView.clipsToBounds = YES;
    } else {
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.clipsToBounds = NO;
    }
}

@end
