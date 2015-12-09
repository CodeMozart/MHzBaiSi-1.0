//
//  MHzHTTPSessionManager.m
//  百思不得姐
//
//  Created by Minghe on 10/11/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzHTTPSessionManager.h"

@implementation MHzHTTPSessionManager


/**
 *  自定义一个manager对象，以后可以根据需求修改manager的一些属性
 *
 *  @return <#return value description#>
 */
+ (instancetype)manager
{
    // text/json
    // text/xml
    // text/plain
    // text/html
    MHzHTTPSessionManager *mgr = [super manager];
    
//    mgr.responseSerializer = ;
//    mar.requestSerializer = ;
    
    return mgr;
}

@end
