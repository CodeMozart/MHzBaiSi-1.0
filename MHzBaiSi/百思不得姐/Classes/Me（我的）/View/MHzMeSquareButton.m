//
//  MHzMeSquareButton.m
//  百思不得姐
//
//  Created by Minghe on 10/12/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzMeSquareButton.h"
#import <UIButton+WebCache.h>

@implementation MHzMeSquareButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 这个背景图片是带边框的，所以设置了之后，按钮都带了分割线
        [self setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.width = self.width * 0.5;
    self.imageView.height = self.imageView.width;
    self.imageView.centerX = self.width * 0.5;
    self.imageView.y = MHzMargin;
    
    self.titleLabel.y = self.imageView.y + self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
    self.titleLabel.centerX = self.width * 0.5;

}

- (void)setSquare:(MHzSquare *)square
{
    _square = square;
    
    [self setTitle:square.name forState:UIControlStateNormal];
    [self sd_setImageWithURL:[NSURL URLWithString:square.icon] forState:UIControlStateNormal placeholderImage:[UIImage circleImageNamed:@"defaultUserIcon"]];
}

@end
