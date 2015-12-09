//
//  MHzCommentHeaderView.m
//  
//
//  Created by Minghe on 10/26/15.
//
//

#import "MHzCommentHeaderView.h"

@interface MHzCommentHeaderView()
@property (weak, nonatomic) UILabel *label;/**< label */
@end

@implementation MHzCommentHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = MHzCommonBgColor;
        
        //
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        
        //
        label.x = 10;
        label.width = 100;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor redColor];
        self.label = label;
    }
    
    return self;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.label.text = text;
}

@end
