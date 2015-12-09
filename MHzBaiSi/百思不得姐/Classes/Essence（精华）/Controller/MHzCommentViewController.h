//
//  MHzCommentViewController.h
//  百思不得姐
//
//  Created by Minghe on 10/24/15.
//  Copyright © 2015 project. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHzTopic;

@interface MHzCommentViewController : UIViewController

@property (strong, nonatomic) MHzTopic *topic;/**< 帖子数据模型 */

@end
