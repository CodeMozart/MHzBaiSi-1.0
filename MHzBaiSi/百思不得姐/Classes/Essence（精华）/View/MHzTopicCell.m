//
//  MHzTopicCell.m
//  百思不得姐
//
//  Created by Minghe on 10/16/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzTopicCell.h"
#import "MHzUser.h"
#import "MHzTopicPictureView.h"
#import "MHzTopicVoiceView.h"
#import "MHzTopicVideoView.h"

@interface MHzTopicCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

/** 最热评论-整体 */
@property (weak, nonatomic) IBOutlet UIView *topCommentView;
/** 最热评论－内容*/
@property (weak, nonatomic) IBOutlet UILabel *topCommentContent;

// 中间控件
/** 图片 */
@property (weak, nonatomic) MHzTopicPictureView *pictureView;
@property (weak, nonatomic) MHzTopicVoiceView *voiceView;/**< 声音 */
@property (weak, nonatomic) MHzTopicVideoView *videoView;/**< 视频 */

@end

/***********************************************************************************************************/
@implementation MHzTopicCell
#pragma mark -  <懒加载>
/**
 图片控件
 */
- (MHzTopicPictureView *)pictureView
{
    if (!_pictureView) {
        MHzTopicPictureView *pictureView = [MHzTopicPictureView centerView];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    
    return _pictureView;
}

/**
 声音控件
 */
- (MHzTopicVoiceView *)voiceView
{
    if (!_voiceView) {
        MHzTopicVoiceView *voiceView = [MHzTopicVoiceView centerView];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}

/**
 视频控件
 */
- (MHzTopicVideoView *)videoView
{
    if (!_videoView) {
        MHzTopicVideoView *videoView = [MHzTopicVideoView centerView];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

/***********************************************************************************************************/
- (void)awakeFromNib {
//    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

- (void)setTopic:(MHzTopic *)topic
{
    _topic = topic;
    
    // 根据帖子的类型进行不同的设置
    if (topic.type == MHzTopicTypeImage) { // 图片
        self.pictureView.hidden = NO;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
        
        // 往中间添加图片控件
        self.pictureView.frame = topic.centerViewFrame;
        // 数据
        self.pictureView.topic = topic;
        
    } else if (topic.type == MHzTopicTypeSound) { // 声音
        self.pictureView.hidden = YES;
        self.voiceView.hidden = NO;
        self.videoView.hidden = YES;
        
        self.voiceView.frame = topic.centerViewFrame;
        self.voiceView.topic = topic;
        
    } else if (topic.type == MHzTopicTypeVideo) { // 视频
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = NO;
        
        self.videoView.frame = topic.centerViewFrame;
        self.videoView.topic = topic;
        
    } else { // 段子
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    }
    
    
    
    
    self.dateLable.text = topic.created_at;
    self.nameLabel.text = topic.name;
    self.contentLabel.text = topic.text;
    [self.iconView setHeaderWithURL:topic.profile_image];
    // 设置底部按钮
    [self setupButton:self.dingButton number:topic.ding title:@"顶"];
    [self setupButton:self.caiButton number:topic.cai title:@"踩"];
    [self setupButton:self.shareButton number:topic.repost title:@"转发"];
    [self setupButton:self.commentButton number:topic.comment title:@"评论"];
    
    // 最热评论
    if (topic.top_cmt) { // 存在最热评论
        self.topCommentView.hidden = NO;
        // 内容
        NSString *content = topic.top_cmt.content;
        // 用户名
        NSString *username = topic.top_cmt.user.username;
        self.topCommentContent.text = [NSString stringWithFormat:@"%@ : %@",username,content];
        
    } else { // 不存在最热评论
        self.topCommentView.hidden = YES;
    }
}

/**
 *  设置按钮的数字
 *
 *  @param button 按钮
 *  @param number 数字
 *  @param title  数字为0时显示的文字
 */
- (void)setupButton:(UIButton *)button number:(NSInteger)number title:(NSString *)title
{
    if (number >= 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f万",number/10000.0] forState:UIControlStateNormal];
    } else if (number == 0) {
        [button setTitle:title forState:UIControlStateNormal];
    } else {
        [button setTitle:[NSString stringWithFormat:@"%zd",number] forState:UIControlStateNormal];
    }
}

- (void)setFrame:(CGRect)frame
{
    // 让cell和navbar中间有个间隔
    frame.origin.y += MHzMargin;
    frame.size.height -= MHzMargin;
    [super setFrame:frame];
}
- (IBAction)moreButton:(id)sender {
    // iOS8之前
    // UIAlertView
    // UIActionSheet;
    
    // iOS8开始
    // UIAlertController == UIAlertView + UIActionSheet
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 添加按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MHzLog(@"点击了［收藏］");
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        MHzLog(@"点击了［举报］");
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        MHzLog(@"点击了［取消］");
    }]];
    
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
