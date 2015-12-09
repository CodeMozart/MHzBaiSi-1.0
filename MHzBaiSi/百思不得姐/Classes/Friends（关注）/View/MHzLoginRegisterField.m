//
//  MHzLoginRegisterField.m
//  百思不得姐
//
//  Created by Minghe on 10/5/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzLoginRegisterField.h"

@implementation MHzLoginRegisterField

- (void)awakeFromNib
{
    // 输入框里面光标的颜色
    self.tintColor = [UIColor whiteColor];
    self.textColor = [UIColor whiteColor];
    [self setValue:[UIColor grayColor] forKeyPath:@"placeholderLabel.textColor"];

    
#pragma mark -  <第一种修改占位文字颜色的方法>
    // 富文本的组成 : NSString(文本) + NSDictionary(丰富多彩属性) + 图片
    
    // NSAttributedString : 不可变的属性字符串
    // NSMutableAttributedString : 可变的属性字符串
    // 修改占位文字的颜色
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];
    
    
#pragma mark -  <第三种修改占位文字颜色的方法>
//    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel.textColor"];
//    placeholderLabel.textColor = [UIColor yellowColor];
    
#pragma mark -  <1.addTarget切换占位文字颜色>
    // 通过这种方式切换占位文字的颜色
//    [self addTarget:self action:@selector(editingDidBegin) forControlEvents:UIControlEventEditingDidBegin];
//    [self addTarget:self action:@selector(editingDidEnd) forControlEvents:UIControlEventEditingDidEnd];
    
    
#pragma mark -  <2.利用通知切换占位文字颜色>
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:self];
     */
    
    
}

#pragma mark -  <3.重写内部方法切换占位文字颜色>
- (BOOL)becomeFirstResponder
{
    self.placeholderColor = [UIColor whiteColor];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    self.placeholderColor = [UIColor grayColor];
    return [super resignFirstResponder];
}

#pragma mark -  <2.1通知方法>
/*
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textDidBeginEditing:(NSNotification *)note
{
    [self setValue:[UIColor whiteColor] forKeyPath:MHzPlaceholderColorKey];
}

- (void)textDidEndEditing:(NSNotification *)note
{
    [self setValue:[UIColor grayColor] forKeyPath:@"placeholderLabel.textColor"];
}
*/

#pragma mark -  <1.1addTarget方法>
/*
- (void)editingDidBegin
{
    [self setValue:[UIColor whiteColor] forKeyPath:@"placeholderLabel.textColor"];
}

- (void)editingDidEnd
{
    [self setValue:[UIColor grayColor] forKeyPath:@"placeholderLabel.textColor"];
    
}
*/

#pragma mark -  <第二种修改占位文字颜色的方法>
/*
- (void)drawPlaceholderInRect:(CGRect)rect
{
    // 文字属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attrs[NSFontAttributeName] = self.font;
    
//    // drawInRect 画矩形框
//    CGRect placeholderRect ;
//    placeholderRect.size.width = rect.size.width;
//    placeholderRect.size.height = self.font.lineHeight;
//    placeholderRect.origin.x = 0;
//    placeholderRect.origin.y = 0.5 * (rect.size.height - placeholderRect.size.height);
//
//    // 画占位文字
//    [self.placeholder drawInRect:placeholderRect withAttributes:attrs];
    
    
    // drawAtPoint 画文字的起点
    CGPoint point;
    point.x = 0;
    point.y = (rect.size.height - self.font.lineHeight) * 0.5;
    
    [self.placeholder drawAtPoint:point withAttributes:attrs];
    
}
*/
@end
