//
//  MHzRecommendTagCell.m
//  百思不得姐
//
//  Created by Minghe on 10/9/15.
//  Copyright © 2015 project. All rights reserved.
//


#import "MHzRecommendTagCell.h"
#import <UIImageView+WebCache.h>

@interface MHzRecommendTagCell()

@property (weak, nonatomic) IBOutlet UIImageView *image_listView;
@property (weak, nonatomic) IBOutlet UILabel *sub_numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *theme_nameLabel;

@end

@implementation MHzRecommendTagCell

/**
 *  给cell上的控件设置数据
 */
- (void)setRecommendTag:(MHzRecommendTag *)recommendTag
{
    
    _recommendTag = recommendTag;
    
    // 设置头像
    [self.image_listView setHeaderWithURL:recommendTag.image_list];

    // 设置名称
    self.theme_nameLabel.text = recommendTag.theme_name;
    
    
    // 设置订阅数
    if (recommendTag.sub_number > 10000) {
        self.sub_numberLabel.text = [NSString stringWithFormat:@"%.1f万人订阅",recommendTag.sub_number / 10000.0];
    }
    else{
    self.sub_numberLabel.text = [NSString stringWithFormat:@"%zd人订阅",recommendTag.sub_number];
    }
}
/***********************************************************************************************************/
/**
 *  重写setFrame：监听设置cell的frame的过程
 */
- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 1;
    [super setFrame:frame];
}




/***********************************************************************************************************/

@end
