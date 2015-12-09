//
//  MHzMeCell.m
//  百思不得姐
//
//  Created by Minghe on 10/11/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzMeCell.h"

@implementation MHzMeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
        
        self.textLabel.textColor = [UIColor darkGrayColor];
    }

    return self;
}


/**
 *  重写这个方法的主要目的是让cell里的图片可以在合适的位置居中显示，label的位置也调整正确
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imageView.image == nil) return;

    self.imageView.height = self.contentView.height - MHzMargin;
    self.imageView.width = self.imageView.height;
    self.imageView.centerY = self.contentView.height * 0.5;
    
    self.textLabel.x = CGRectGetMaxX(self.imageView.frame) + MHzMargin;
    
    
    
}

// 另一种让cell距离顶部距离减少的方案
//- (void)setFrame:(CGRect)frame
//{
//    frame.origin.y -= 25;
//    [super setFrame:frame];
//}

@end
