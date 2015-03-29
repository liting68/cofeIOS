//
//  FindBackPwdVC.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/3.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "FindBackPwdVC.h"

@interface FindBackPwdVC ()
{
    int remainTime;
}
@end

@implementation FindBackPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initNavView];
    [self forNavBeNoTransparent];
    [self initBackButton];
    
    if (self.isMod) {
        
        [self initTitleViewWithTitleString:@"修改密码"];
        
    }else if (self.isRegister) {
        
        [self initTitleViewWithTitleString:@"注册"];
        
    }else {
        
         [self initTitleViewWithTitleString:@"找回密码"];
    }
    
    _phoneField.keyboardType = UIKeyboardTypeNumberPad;
    
    _phoneField.delegate = self;
    
    _checkCodeField.delegate = self;
    
    _passwordField.delegate = self;
    _passwordField.secureTextEntry = YES;
    
    _rePasswordField.delegate = self;
    _rePasswordField.secureTextEntry = YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Memory Manage

- (void)dealloc {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (IBAction)doneAction:(id)sender {
    
    if (self.isRegister) {
        
        NSString * phone = _phoneField.text;
        NSString * checkCode = _checkCodeField.text;
        NSString * password = _passwordField.text;
        NSString * rpassword = _rePasswordField.text;
        
        if (![AppUtil isValidateAccount:phone]) {
            
            [AppUtil HUDWithStr:@"请输入有效的账号" View:self.view];
            
            return;
            
        }

        if ([AppUtil isNull:checkCode]) {
            
            [AppUtil HUDWithStr:@"请输入验证码" View:self.view];
            
            return;
        }
        
        if ([password length] < 6) {
            
            [AppUtil HUDWithStr:@"密码至少为六位" View:self.view];
            
            return;
        }
        
        if(![password isEqualToString:rpassword]){
            
            [AppUtil HUDWithStr:@"两次输入的密码不一致" View:self.view];
            
            return;
            
        }

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"user",@"c",@"register",@"act",password,@"user_password",checkCode,@"code", phone,@"mobile", nil];
        
        [manager GET:hostUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            if (response.err == 1) {
                     //  NSNumber * userID =  [NSNumber numberWithInt:[[response.result valueForKey:@"userid"] intValue]];

                           // [[NSUserDefaults standardUserDefaults] setCurrentMemberID:userID];
                
                [AppUtil HUDWithStr:@"注册成功" View:self.view];
                
                [self popController];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
    }else {
        
        
        NSString * phone = _phoneField.text;
        NSString * checkCode = _checkCodeField.text;
        NSString * password = _passwordField.text;
        NSString * rpassword = _rePasswordField.text;
        
        if (![AppUtil isValidateAccount:phone]) {
            
            [AppUtil HUDWithStr:@"请输入有效的账号" View:self.view];
            
            return;
            
        }
        
        if ([AppUtil isNull:checkCode]) {
            
            [AppUtil HUDWithStr:@"请输入验证码" View:self.view];
            
            return;
        }
        
        if ([password length] < 6) {
            
            [AppUtil HUDWithStr:@"密码至少为六位" View:self.view];
            
            return;
        }
        
        
        if(![password isEqualToString:rpassword]){
            
            [AppUtil HUDWithStr:@"两次输入的密码不一致" View:self.view];
            
            return;
            
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"user",@"c",@"resetPassword",@"act",password,@"user_password",checkCode,@"code", phone,@"mobile", nil];
        
        [manager GET:hostUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            if (response.err == 1) {
                
                [AppUtil HUDWithStr:@"密码重置成功" View:self.view];
                
                [self popController];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}

- (IBAction)getCheckCode:(id)sender {
    

    //if (self.isRegister) {
        
        NSString * phone = _phoneField.text;
        
        if (![AppUtil isValidateAccount:phone]) {
            
            [AppUtil HUDWithStr:@"请输入有效的手机号码" View:self.view];
            
            return;
            
        }
    
    [AppUtil showHudInView:self.view title:@"获取验证码..." tag:10001];
    
    [self.view endEditing:YES];
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"user",@"c",@"getVerificationCode",@"act",phone,@"mobile", nil];
    
    if (self.isRegister) {
        
        [parameters setValue:@"1" forKey:@"type"];
    
    }else {
        
        [parameters setValue:@"2" forKey:@"type"];
    }
    
    
        [manager GET:hostUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            [AppUtil hideHudInView:self.view mtag:10001];
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            if (response.err == 1) {
             
                if (timer) {
                    
                    [timer invalidate];
                    timer = nil;
                }
                
                remainTime = 60;
                timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeValue) userInfo:nil repeats:YES];
              
                self.checkButton.enabled = NO;
                [self.checkButton setBackgroundImage:TTImage(@"findBack") forState:UIControlStateNormal];
                [self.checkButton setTitle:@"60秒后重发" forState:UIControlStateNormal];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
   // }
}

#pragma mark -

- (void)changeValue {
    
    if (remainTime == 0) {
        
        if (timer) {
            
            [timer invalidate];
            timer = nil;
        }
        
        self.checkButton.enabled = YES;
        [self.checkButton setBackgroundImage:TTImage(@"code_selected") forState:UIControlStateNormal];
        [self.checkButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        return;
    }
    
    remainTime = remainTime - 1;
    
    [self.checkButton setTitle:[NSString stringWithFormat:@"%d秒后重发",remainTime] forState:UIControlStateNormal];
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
