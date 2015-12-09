//
//  MHzUser.h
//  百思不得姐
//
//  Created by Minghe on 10/18/15.
//  Copyright © 2015 project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHzUser : NSObject
@property (copy, nonatomic) NSString *username;/**< 用户名 */
@property (copy, nonatomic) NSString *profile_image;/**< 头像 */
@property (copy, nonatomic) NSString *sex;/**< 性别 */
@end
