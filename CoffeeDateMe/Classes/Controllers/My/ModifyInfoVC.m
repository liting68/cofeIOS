//
//  ModifyInfoVC.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/3/2.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "ModifyInfoVC.h"

@interface ModifyInfoVC ()

@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@end

@implementation ModifyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavView];
    [self initBackButton];
    [self forNavBeNoTransparent];
    [self initTitleViewWithTitleString:self.keyName];
    
    [self initWithRightButtonWithImageName:nil title:@"完成" action:@selector(doneSuccess)];
    
    if ([self.keyValue isEqualToString:@"user_name"]) {
        
        [self.hintLabel setHidden:NO];
        
        
    }else {
        
        
        [self.hintLabel setHidden:YES];
    }
        
        if ([self.keyValue isEqualToString:@"signature"]) {
            
            [self.textView setHidden:NO];
            [self.textField setHidden:YES];
            [self.textView becomeFirstResponder];
            
        }else {
            
            [self.textView setHidden:YES];
            [self.textField setHidden:NO];
            [self.textField becomeFirstResponder];
            
        }
    
    if (self.beizhuTitle) {
        
        self.textField.text = self.beizhuTitle;
    }
}


#pragma mark - Actions

- (void)doneSuccess {
    
    NSString * newValue =  nil;
    
    if ([self.keyValue isEqualToString:@"signature"]) {
        
        newValue = self.textView.text;
        
    }else {
        
        newValue = self.textField.text;
    }
    
    if ([AppUtil isNull:newValue]) {
        
        [AppUtil HUDWithStr:@"请输入信息" View:self.view];
        
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(modifyInfoVC:didModifySuccessWithTitle:)]) {
        
        [self.delegate modifyInfoVC:self didModifySuccessWithTitle:newValue];
    }
    
    [self popController];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Memory Manage

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
