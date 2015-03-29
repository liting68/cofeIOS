//
//  EvaluateCofeViewController.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-9-30.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "EvaluateCofeViewController.h"

@interface EvaluateCofeViewController ()<UITextViewDelegate>

@end

@implementation EvaluateCofeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavView];
    [self forNavBeNoTransparent];
    [self initBackButton];
    
    if (self.cateTitle || self.eventID) {
        
        [self initTitleViewWithTitleString:self.cateTitle];
    
    }else {
        
        [self initTitleViewWithTitleString:@"用户反馈"];
        self.placeHolderLabel.text = @"请输入反馈,谢谢!";
        [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
        
        ///发表按钮换一个
        ///////
    }
    
    self.textView.delegate = self;
}

#pragma mark - Action

- (IBAction)submitAction:(id)sender {
    
    
    if ([self.textView.text isEqualToString:@""]) {
        
        [AppUtil HUDWithStr:@"说点什么吧" View:self.view];
        
        return;
    }
    ///发起请请求
    
    [self.textView resignFirstResponder];
    
    NSNumber * userID =  [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    if (!userID) {
        
        [self gotoLogin];
        
    }else {
        
        if (self.cafeID) {
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"shop",@"c",@"leaveMsg",@"act", userID,@"userid",self.cafeID,@"shopid",self.textView.text,@"content",nil];
            
            [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                Response * response = [self parseJSONValueWithJSONString:responseObject];
                
                if (response.err == 1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:k_CAFE_LEAVE_NOTIFICATION object:nil];
                    
                    [AppUtil HUDWithStr:@"留言发表成功" View:self.view];
                    
                    [self  popController];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];

        }else if(self.eventID){
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"userEvent",@"c",@"leaveMsg",@"act", userID,@"userid",self.eventID,@"eventid",self.textView.text,@"content",nil];
            
            [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                Response * response = [self parseJSONValueWithJSONString:responseObject];
                
                if (response.err == 1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:K_PERSON_LEAVE_NOTIFICATION object:nil];
                    
                    [AppUtil HUDWithStr:@"留言发表成功" View:self.view];
                    
                    [self  popController];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];

        }else {  ///用户反馈
            
            NSNumber * memberID = [[NSUserDefaults standardUserDefaults]currentMemberID];
            
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"feedback",@"c",@"sendFeedback",@"act", memberID,@"loginid",self.textView.text,@"content",nil];
            
            [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                Response * response = [self parseJSONValueWithJSONString:responseObject];
                
                if (response.err == 1) {
                
                    
                    [AppUtil HUDWithStr:@"反馈成功" View:self.view];
                    
                    [self  popController];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];

        }
        
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([textView.text isEqualToString:@""]) {
        
        [self.placeHolderLabel setHidden:NO];
    
    }else {
        
        [self.placeHolderLabel setHidden:YES];
    }
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - Momory Manage

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
