//
//  MHzLoginRegisterController.m
//  百思不得姐
//
//  Created by Minghe on 10/4/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzLoginRegisterController.h"

@interface MHzLoginRegisterController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingMargin;

@end

@implementation MHzLoginRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
}

/***********************************************************************************************************/


- (IBAction)registerButton:(UIButton *)button {
    
    // 修改按钮的选中状态
    button.selected = !button.isSelected;
    
    // 修改约束
    if (self.leadingMargin.constant) {
        self.leadingMargin.constant = 0;
    }
    else{
        
    self.leadingMargin.constant = -[UIScreen mainScreen].bounds.size.width;
        
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
            }];
    
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
