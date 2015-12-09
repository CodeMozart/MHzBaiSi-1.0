//
//  UIImageView+MHzExtension.m
//  百思不得姐
//
//  Created by Minghe on 10/9/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "UIImageView+MHzExtension.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (MHzExtension)

- (void)setHeaderWithURL:(NSString *)url
{
    [self setCircleHeaderWithURL:url];
}

- (void)setCircleHeaderWithURL:(NSString *)url
{
    UIImage *placeholderImg = [UIImage circleImageNamed:@"defaultUserIcon"];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholderImg completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 如果下载失败，不做任何处理，让它显示占位图片
        if (image == nil) return;
        self.image = [image circleImage];
        
    }];
}

- (void)setRectHeaderWithURL:(NSString *)url
{
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}

@end
