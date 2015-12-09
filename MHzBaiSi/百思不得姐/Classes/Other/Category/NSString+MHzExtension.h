//
//  NSString+MHz.h
//  08-多图片下载
//
//  Created by Minghe on 9/5/15.
//  Copyright (c) 2015 多线程. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MHzExtension)

/** 用于生成文件在caches目录中的路径 */
- (instancetype)cachePath;

/** 用于生成文件在document目录中的路径 */
- (instancetype)documentPath;

/** 用于生成文件在tmp目录中的路径 */
- (instancetype)tmpPath;

/** 获得当前文件大小 */
- (unsigned long long)fileSize;

@end
