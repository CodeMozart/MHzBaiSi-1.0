//
//  MHzCommentCell.h
//  百思不得姐
//
//  Created by Minghe on 10/26/15.
//  Copyright © 2015 project. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHzComment;
@interface MHzCommentCell : UITableViewCell
@property (strong, nonatomic) MHzComment *comment;/**< 评论模型 */
@end
