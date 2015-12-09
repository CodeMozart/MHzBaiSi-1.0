//
//  MHzRecommendUserCell.m
//  百思不得姐
//
//  Created by Minghe on 10/24/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzRecommendUserCell.h"
#import "MHzRecommendUser.h"

@interface MHzRecommendUserCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followsLabel;
@end
@implementation MHzRecommendUserCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRecommendUser:(MHzRecommendUser *)recommendUser
{
    _recommendUser = recommendUser;
    self.nameLabel.text = recommendUser.screen_name;
    [self.iconView setHeaderWithURL:recommendUser.header];
    if (recommendUser.fans_count > 10000) {
        self.followsLabel.text = [NSString stringWithFormat:@"%.1f万人订阅",recommendUser.fans_count / 10000.0];
    } else {
    self.followsLabel.text = [NSString stringWithFormat:@"%zd人订阅",recommendUser.fans_count];
    }
}

@end
