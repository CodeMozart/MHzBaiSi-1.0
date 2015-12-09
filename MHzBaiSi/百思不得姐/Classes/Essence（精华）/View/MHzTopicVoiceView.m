//
//  MHzTopicVoiceView.m
//  百思不得姐
//
//  Created by Minghe on 10/22/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzTopicVoiceView.h"
#import <UIImageView+WebCache.h>
#import "MHzTopic.h"
#import "MHzSeeBigController.h"

@interface MHzTopicVoiceView()
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voicetimeLabel;

@end

@implementation MHzTopicVoiceView

- (void)setTopic:(MHzTopic *)topic
{
    [super setTopic:topic];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    self.playcountLabel.text = [NSString stringWithFormat:@"%zd次播放",topic.playcount];
    self.voicetimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",topic.voicetime / 60 ,topic.voicetime % 60];

}

@end
