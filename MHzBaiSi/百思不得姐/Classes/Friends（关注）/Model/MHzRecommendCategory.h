//
//  MHzRecommendCategory.h
//  百思不得姐
//
//  Created by Minghe on 10/24/15.
//  Copyright © 2015 project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHzRecommendCategory : NSObject

@property (copy, nonatomic) NSString *name;/**< 名字 */
@property (copy, nonatomic) NSString *id;/**< id */

@property (strong, nonatomic) NSMutableArray *users;/**< 用户数据 */
@property (assign, nonatomic) NSInteger page;/**< 页码 */
@property (assign, nonatomic) NSInteger total;/**< 总数 */

@end
