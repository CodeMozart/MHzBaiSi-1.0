//
//  MHzTopicVideoView.m
//  百思不得姐
//
//  Created by Minghe on 10/23/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzTopicVideoView.h"
#import "MHzSeeBigController.h"
#import <UIImageView+WebCache.h>

@interface MHzTopicVideoView()
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *playtimeLabel;
@end

@implementation MHzTopicVideoView

- (void)setTopic:(MHzTopic *)topic
{
    [super setTopic:topic];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    self.playcountLabel.text = [NSString stringWithFormat:@"%zd次播放",topic.playcount];
    self.playtimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",topic.videotime / 60 ,topic.videotime % 60];
    
}



@end
