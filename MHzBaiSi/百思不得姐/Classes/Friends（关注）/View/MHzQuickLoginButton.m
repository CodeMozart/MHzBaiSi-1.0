//
//  MHzQuickLoginButton.m
//  百思不得姐
//
//  Created by Minghe on 10/4/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzQuickLoginButton.h"

@implementation MHzQuickLoginButton


- (void)awakeFromNib
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}

- (void)layoutSubviews
{

    [super layoutSubviews];
    self.imageView.centerX = self.width * 0.5 ;
    self.imageView.y = 0 ;
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.imageView.height;
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    
    
    
}

@end
