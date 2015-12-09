//
//  MHzSquare.h
//  百思不得姐
//
//  Created by Minghe on 10/12/15.
//  Copyright © 2015 project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHzSquare : NSObject
/* "square_list"
 {
 android = "";
 icon = "http://img.spriteapp.cn/ugc/2015/05/20/150532_5078.png";
 id = 28;
 ipad = "";
 iphone = "";
 name = "\U5ba1\U8d34";
 url = "mod://BDJ_To_Check";
 },
 */

@property (copy, nonatomic) NSString *icon;/**< icon */
@property (copy, nonatomic) NSString *name;/**< name */
@property (copy, nonatomic) NSString *url;/**< url */

@end
