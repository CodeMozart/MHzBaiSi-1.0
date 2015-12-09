//
//  MHzTopic.h
//  百思不得姐
//
//  Created by Minghe on 10/16/15.
//  Copyright © 2015 project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHzComment.h"

typedef enum {
    /** 图片 */
    MHzTopicTypeImage = 10,
    /** 文字 */
    MHzTopicTypeText = 29,
    /** 声音 */
    MHzTopicTypeSound = 31,
    /** 视频 */
    MHzTopicTypeVideo = 41,
    /** 全部 */
    MHzTopicTypeAll = 1
    
} MHztopicType;

@interface MHzTopic : NSObject

// 字典转来的属性－－－－－－－－－－－－－－－－－－－－－－－－－－－－
/** 用户的名字 */
@property (nonatomic, copy) NSString *name;
/** 用户的头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 帖子的文字内容 */
@property (nonatomic, copy) NSString *text;
/** 帖子审核通过的时间 */
@property (nonatomic, copy) NSString *created_at;
/** 顶数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发\分享数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论数量 */
@property (nonatomic, assign) NSInteger comment;
/** 帖子类型 */
@property (assign, nonatomic) MHztopicType type;
@property (strong, nonatomic) MHzComment *top_cmt;/**< 最热评论模型 */
@property (assign, nonatomic) CGFloat width;/**< 图片的宽度 */
@property (assign, nonatomic) CGFloat height;/**< 图片的高度 */
@property (copy, nonatomic) NSString *small_image;/**< 小图 */
@property (copy, nonatomic) NSString *middle_image;/**< 中图 */
@property (copy, nonatomic) NSString *large_image;/**< 大图 */
@property (assign, nonatomic) BOOL is_gif;/**< 是否为动图 */
@property (assign, nonatomic, getter=isBigPicture) BOOL bigPicture;/**< 是否为大图 */
@property (assign, nonatomic) NSInteger playcount;/**< 播放次数 */
@property (assign, nonatomic) NSInteger videotime;/**< 视频时间 */
@property (assign, nonatomic) NSInteger voicetime;/**< 声音时间 */

@property (copy, nonatomic) NSString *id;/**< id 获取评论的参数之一 */
@property (copy, nonatomic) NSString *tag;/**< mid 获取评论的参数之一 */

// 自己设置的辅助属性－－－－－－－－－－－－－－－－－－－－－－－－－－－－
@property (assign, nonatomic) CGRect centerViewFrame;/**< 中间控件的frame */
@property (assign, nonatomic) CGFloat cellHeight;/**< cell的高度 */

@end
