//
//  MHzComment.h
//  百思不得姐
//
//  Created by Minghe on 10/18/15.
//  Copyright © 2015 project. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MHzUser;

@interface MHzComment : NSObject

@property (copy, nonatomic) NSString *content;/**< 评论内容 */
@property (strong, nonatomic) MHzUser *user;/**< 发表评论的用户 */
@property (copy, nonatomic) NSString *id;/**< id */
@property (assign, nonatomic) NSInteger like_count;/**< 点赞数量 */
@end
