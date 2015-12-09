//
//  MHzRecommendTag.h
//  百思不得姐
//
//  Created by Minghe on 10/9/15.
//  Copyright © 2015 project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHzRecommendTag : NSObject

@property (copy, nonatomic) NSString *image_list;/**< 图片 */

@property (copy, nonatomic) NSString *theme_name;/**< 名称 */

@property (assign, nonatomic) NSInteger sub_number;/**< 订阅数 */

@end
