//
//  MHzTopicCenterView.h
//  百思不得姐
//
//  Created by Minghe on 10/23/15.
//  Copyright © 2015 project. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHzTopic;

@interface MHzTopicCenterView : UIView
{
    __weak UIImageView *_imageView;
}

+ (instancetype)centerView;
@property (strong, nonatomic) MHzTopic *topic;/**< 帖子数据模型 */

@end
