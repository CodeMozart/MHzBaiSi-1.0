//
//  MHzCommentCell.m
//  百思不得姐
//
//  Created by Minghe on 10/26/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzCommentCell.h"
#import "MHzComment.h"
#import "MHzUser.h"

@interface MHzCommentCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@end

@implementation MHzCommentCell

- (void)awakeFromNib {
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

- (void)setComment:(MHzComment *)comment
{
    _comment = comment;
    
    [self.profileImageView setHeaderWithURL:comment.user.profile_image];
    self.nameLabel.text = comment.user.username;
    self.contentLabel.text = comment.content;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd",comment.like_count];
    // 设置性别图片
    NSString *sexImageName = [comment.user.sex isEqualToString:@"m"] ? @"Profile_manIcon" : @"Profile_womanIcon" ;
    self.sexView.image = [UIImage imageNamed:sexImageName];
}

@end
