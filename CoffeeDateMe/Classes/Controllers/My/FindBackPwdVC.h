//
//  FindBackPwdVC.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/3.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "BaseViewController.h"

@interface FindBackPwdVC : BaseViewController<UITextFieldDelegate>
{
    NSTimer * timer;
}
@property (nonatomic,assign) BOOL isRegister;

@property (nonatomic, assign) BOOL isMod;

@property (weak, nonatomic) IBOutlet UITextField *phoneField;

@property (weak, nonatomic) IBOutlet UITextField *checkCodeField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UITextField *rePasswordField;

@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@end
