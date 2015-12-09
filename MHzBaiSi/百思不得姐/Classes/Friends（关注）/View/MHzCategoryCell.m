//
//  MHzRecommendCategoryCell.m
//  百思不得姐
//
//  Created by Minghe on 10/24/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzRecommendCategoryCell.h"
#import "MHzRecommendCategory.h"

@interface MHzRecommendCategoryCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *indicatorView;
@end

@implementation MHzRecommendCategoryCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.indicatorView.hidden = NO;
        self.nameLabel.textColor = [UIColor redColor];
    } else {
        self.indicatorView.hidden = YES;
        self.nameLabel.textColor = [UIColor blackColor];
    }
}

- (void)setCategory:(MHzRecommendCategory *)category
{
    _category = category;
    self.nameLabel.text = category.name;
}

@end
