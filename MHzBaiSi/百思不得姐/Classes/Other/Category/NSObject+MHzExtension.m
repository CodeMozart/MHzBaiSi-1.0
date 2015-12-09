//
//  NSObject+MHzExtension.m
//  百思不得姐
//
//  Created by Minghe on 10/9/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "NSObject+MHzExtension.h"
#import <objc/runtime.h>

@implementation NSObject (MHzExtension)

+ (void)logAllIvars
{
    Class c = self;
    
    while (c) {
        // 获得所有成员变量
        unsigned int outCount = 0;
        Ivar *ivarList = class_copyIvarList(c, &outCount);
        
        // 遍历所有的成员变量
        for (int i = 0; i < outCount; i++) {
            
            // 获得第i个成员变量
            Ivar ivar = ivarList[i];
            
            // 获得成员变量的名称和类型
            MHzLog(@"%@ -> %s %s",c,ivar_getName(ivar),ivar_getTypeEncoding(ivar));
        }
        
        // 释放资源
        free(ivarList);
        
        // 获得父类
        c = class_getSuperclass(c);
    }
}

@end
