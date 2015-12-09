//
//  MHzRecommendUser.h
//  百思不得姐
//
//  Created by Minghe on 10/24/15.
//  Copyright © 2015 project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHzRecommendUser : NSObject
@property (copy, nonatomic) NSString *screen_name;/**< 昵称 */
@property (assign, nonatomic) NSInteger fans_count;/**< 粉丝数 */
@property (copy, nonatomic) NSString *header;/**< 头像 */

@end
