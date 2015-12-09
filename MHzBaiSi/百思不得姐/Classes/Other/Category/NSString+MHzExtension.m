//
//  NSString+MHz.m
//  08-多图片下载
//
//  Created by Minghe on 9/5/15.
//  Copyright (c) 2015 多线程. All rights reserved.
//

#import "NSString+MHzExtension.h"

@implementation NSString (MHzExtension)


// 用于生成文件在caches目录中的路径
- (instancetype)cachePath
{
    // 1.获取caches目录
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    // 2.生成绝对路径
    return [path stringByAppendingPathComponent:[self lastPathComponent]];
}

// 用于生成文件在document目录中的路径
- (instancetype)documentPath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject];
    return [path stringByAppendingPathComponent:[self lastPathComponent]];
}

// 用于生成文件在tmp目录中的路径
- (instancetype)tmpPath
{
    NSString *path = NSTemporaryDirectory();
    return [path stringByAppendingPathComponent:[self lastPathComponent]];
}

// 获得当前文件大小
- (unsigned long long)fileSize
{
    // get filemanager
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // is Directory? (directory or file)
    BOOL isDirectory = NO;
    
    // judge the directory path is correct
    BOOL exsits = [mgr fileExistsAtPath:self isDirectory:&isDirectory];
    
    // if the path is false
    if (!exsits)  return 0;
    
    // is Directory
    if (isDirectory) {
        // var totalSize
        unsigned long long fileSize = 0;
        
        // for in all files in directory
        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:self];
        
        /* 这个enumerator会把传入的文件夹里面的所有路径返回回来
         例如：
         Programming
         Programming/.DS_Store
         Programming/[Python技术手册(第2版)].（美）马特利.扫描版(ED2000.COM).pdf
         Programming/[搬书匠][Python In A Nutshell 2nd Edition].2006.英文版.pdf
         */
        
        for (NSString *subpath in enumerator) {
            // full subpath
            NSString *fullSubpath = [self stringByAppendingPathComponent:subpath];
            
            /* attributesOfItemAtPath:error: 方法返回的字典：
            {
                NSFileCreationDate = "2015-09-03 12:17:28 +0000";
                NSFileExtensionHidden = 0;
                NSFileGroupOwnerAccountID = 20;
                NSFileGroupOwnerAccountName = staff;
                NSFileModificationDate = "2015-09-23 11:40:52 +0000";
                NSFileOwnerAccountID = 501;
                NSFilePosixPermissions = 493;
                NSFileReferenceCount = 12;
                NSFileSize = 408;
                NSFileSystemFileNumber = 7117682;
                NSFileSystemNumber = 16777220;
                NSFileType = NSFileTypeDirectory;
            }
            */
            
            // filesize的作用：Returns the value for the key NSFileSize.
            fileSize += [mgr attributesOfItemAtPath:fullSubpath error:nil].fileSize;
        }
        
        return fileSize;
        
    }
    
    // is file
    return [mgr attributesOfItemAtPath:self error:nil].fileSize;
    
}


@end
