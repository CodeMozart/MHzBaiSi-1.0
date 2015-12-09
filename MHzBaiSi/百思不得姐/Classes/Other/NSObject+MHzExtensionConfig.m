//
//  NSObject+MHzExtensionConfig.m
//  百思不得姐
//
//  Created by Minghe on 10/18/15.
//  Copyright © 2015 project. All rights reserved.
//

/**
 为MJExtension字典转模型做一些配置
 */

#import "NSObject+MHzExtensionConfig.h"
#import <MJExtension.h>
#import "MHzComment.h"
#import "MHzTopic.h"

@implementation NSObject (MHzExtensionConfig)

+ (void)load
{
    // 在这个方法里可以用指定的属性名称来替换服务器传来数据的字典里的key，这样就不要求模型里面的属性名称和字典里面完全一致，而是可以
    // 按照自己的喜好来进行配置。更多内容可以看10.18上午的视频弄明白MJExtension
    
    [MHzTopic setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"top_cmt" : @"top_cmt[0]", // 这里用［top_cmt］替换了［top_cmt[0]］
                 @"small_image" : @"image0",
                 @"middle_image" : @"image2",
                 @"large_image" : @"image1"
                 
                 };
    }];
}

@end
