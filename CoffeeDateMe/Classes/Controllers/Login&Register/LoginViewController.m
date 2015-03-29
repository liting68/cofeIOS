//
//  LoginViewController.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-9-30.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "LoginViewController.h"
#import "EaseMob.h"
#import "FindBackPwdVC.h"
#import "NSUserDefaults+Additions.h"
#import "UserCenterVC.h"
#import "UMessage.h"

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

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

    [self initTitleViewWithTitleString:@"登录"];
    [self forNavBeNoTransparent];
    [self.navigationController.navigationBar setHidden:YES];
    
    [self.headerView setConers];
    
    NSString * avatarString = [[NSUserDefaults standardUserDefaults] valueForKey:@"avatar"];
    
    if (avatarString) {
    
        [self.headerView setURL:avatarString defaultImage:nil type:1];
        
    }else {
        
        self.headerView.image = TTImage(@"chatListCellHead");
    }
    
    _passwordField.delegate = self;
    _phoneNumber.delegate = self;
    
    NSString * lastName = [[NSUserDefaults standardUserDefaults] valueForKey:@"lastName"];
    
    if ([AppUtil isNotNull:lastName]) {
        
        self.phoneNumber.text = lastName;
    }
    
    NSString * password = [[NSUserDefaults standardUserDefaults] valueForKey:@"lastPassword"];
    
    if ([AppUtil isNotNull:password]) {
        
        self.passwordField.text = password;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
   [self hideTabBar];
    
    [self.navigationController.navigationBar setHidden:YES
     ];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self.navigationController.navigationBar setHidden:YES];
}

- (IBAction)forgetPwdAction:(id)sender {
    
    FindBackPwdVC *findBackPwdVC = (FindBackPwdVC *)[self getStoryBoardControllerWithControllerID:@"FindBackPwdVC" storyBoardName:@"Other"];
    
    [self.navigationController pushViewController:findBackPwdVC animated:YES];

}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [UIView animateWithDuration:0.3 animations:^{
       
        self.view.top = -150.0f;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.top = 0.0f;
    }];
    
    [textField resignFirstResponder];

    return YES;
    
}

#pragma mark - Action

- (IBAction)backA:(id)sender {
    
    if (self.isRoot) {
        
        [self.slideMenuController closeMenuBehindContentViewController:self.slideMenuController.rootViewController animated:YES completion:^(BOOL finished) {
            
        }];
        
    }else if (self.isPresent) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }else {
        
         [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)registerAction:(id)sender {
 
    [_phoneNumber resignFirstResponder];
    [_passwordField resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.top = 0.0f;
    }];
    
    NSString * password = _passwordField.text;

    NSString * pName = _phoneNumber.text;
    
 /*   if (![AppUtil isValidateAccount:pName]) {
        
        [AppUtil HUDWithStr:@"请输入有效的账号" View:self.view];
        
        return;
        
    }*/
    
    if(![AppUtil isValidatePassword:password]){
        
        [AppUtil HUDWithStr:@"请输入有效的密码" View:self.view];
        
        return;
        
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"user",@"c",@"login",@"act",pName,@"user_name",password,@"user_password", nil];
    
    [AppUtil showHudInView:self.view tag:10000];
    
    [manager POST:hostUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
     
        [AppUtil hideHudInView:self.view mtag:10000];
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
    
            NSNumber * userID =  [NSNumber numberWithInt:[[response.result valueForKey:@"userid"] intValue]];
            
            [[NSUserDefaults standardUserDefaults] setCurrentMemberID:userID];//用户ID
            
            NSMutableDictionary * uiDic = [[NSMutableDictionary alloc] initWithCapacity:0];
            [uiDic setValue:[response.result valueForKey:@"userid"] forKey:@"userid"];
            
            NSString * coffeeName = [response.result valueForKey:@"user_name"];///取出咖啡号
            
            [uiDic setValue:[response.result valueForKey:@"user_name"] forKey:@"user_name"];
            [uiDic setValue:[response.result valueForKey:@"sex"] forKey:@"sex"];
            [uiDic setValue:[response.result valueForKey:@"mobile"] forKey:@"mobile"];
            [uiDic setValue:[response.result valueForKey:@"email"] forKey:@"email"];
            [uiDic setValue:[response.result valueForKey:@"head_photo"] forKey:@"head_photo"];
            [uiDic setValue:[response.result valueForKey:@"allow_find"] forKey:@"allow_find"];
            [uiDic setValue:[response.result valueForKey:@"allow_flow"] forKey:@"allow_flow"];
            
            ////////////
            [[NSUserDefaults standardUserDefaults]setValue:[response.result valueForKey:@"mobile"] forKey:@"mobile"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            /////////
            
            [[NSUserDefaults standardUserDefaults] setCurrentUserEmail:coffeeName];//将用户名密码存起来
            [[NSUserDefaults standardUserDefaults] setCurrentUserPsw:password];//密码
            
            [[NSUserDefaults standardUserDefaults] setUserInfo:uiDic];//用户信息
            
            ////////////////////登陆IM
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[response.result valueForKey:@"mobile"]
                                                                password:[AppUtil md5HexDigest:password]
                                                              completion:
             ^(NSDictionary *loginInfo, EMError *error) {
                 
                 NSLog(@"%u",error.errorCode);
                 
                 if (!error) {
                    
                     [self performSelectorOnMainThread:@selector(loginFeedback:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
                     
                 }else {
                     
                         [self performSelectorOnMainThread:@selector(loginFeedback:) withObject:[NSNumber numberWithBool:NO] waitUntilDone:NO];
                     
                 }
             } onQueue:nil];
         
            /////////////////////////////////
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
         [AppUtil hideHudInView:self.view mtag:10000];
          NSLog(@"Error: %@", error);
    }];
}


- (void)loginFeedback:(NSNumber *)success {
    
    BOOL isSuccess = [success boolValue];
    
    if (isSuccess) {
        
        [AppUtil HUDWithStr:@"登录成功" View:self.view];
        
        //////////添加别名/////////
        NSNumber * memberID = [[NSUserDefaults standardUserDefaults]currentMemberID];
        
        if ([AppUtil isNotNull:memberID]) {
            
            NSString * myMemberID = [NSString stringWithFormat:@"%@",memberID];
            
            [UMessage addAlias:myMemberID type:@"invitation" response:^(id responseObject, NSError *error) {
                
            }];
        }
        ///////

        
        NSString * password = _passwordField.text;
        
        NSString * pName = _phoneNumber.text;
        
        
        ////////最后一次登录用户和密码///////
        [[NSUserDefaults standardUserDefaults]setValue:pName forKey:@"lastName"];
        [[NSUserDefaults standardUserDefaults]setValue:password forKey:@"lastPassword"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        /////////
        
        //////登陆成功
        [[NSNotificationCenter defaultCenter] postNotificationName:K_LOGIN_NOTIFICATION object:nil userInfo:nil];

        NSDictionary * userInfo = [[NSUserDefaults standardUserDefaults] userInfo];
        
        NSString * userName = [userInfo valueForKey:@"user_name"];

        if ([AppUtil isNull:userName]) {
            
           //  [AppUtil HUDWithStr:@"请先个人完善信息" View:self.view];
          
              [self fillAction];
        //    [self performSelector:@selector(fillAction) withObject:nil afterDelay:1.0];

        }else {
            
            [self goBackAcion];
        }
        
    }else {
        
        [AppUtil HUDWithStr:@"登录失败" View:self.view];
        
        [[NSUserDefaults standardUserDefaults] clearCurrentMemberID];
        [[NSUserDefaults standardUserDefaults] clearUserInfo];
        [[NSUserDefaults standardUserDefaults] clearUserEmail];
        [[NSUserDefaults standardUserDefaults] clearPwd];
    
    }
}

- (void)fillAction {
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    UserCenterVC * userCenter = [self getStoryBoardControllerWithControllerID:@"UserCenterVC" storyBoardName:@"Other"];
    userCenter.otherID =  [NSString stringWithFormat:@"%@",memberID];
    userCenter.nickName = nil;
    userCenter.isFromLogin = YES;
    userCenter.isMySelf = YES;
    userCenter.loginVC = self;
    [self.navigationController pushViewController:userCenter animated:YES];
}

- (void)goBackAcion {
    
    if (self.isRoot) {
        
        [self.slideMenuController closeMenuBehindContentViewController:self.slideMenuController.rootViewController animated:YES completion:^(BOOL finished) {
            
        }];
    }else if (self.isPresent){
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    }else {
        
        [self popController];
    }
    
}

#pragma mark -

- (IBAction)gotoRister:(id)sender {
    
    FindBackPwdVC *findBackPwdVC = (FindBackPwdVC *)[self getStoryBoardControllerWithControllerID:@"FindBackPwdVC" storyBoardName:@"Other"];
    
    findBackPwdVC.isRegister = YES;
    
    [self.navigationController pushViewController:findBackPwdVC animated:YES];
    
  //  RegisterViewController *registerViewController = (RegisterViewController *)[self getStoryBoardControllerWithControllerID:@"RegisterViewController"];
    //[self.navigationController pushViewController:registerViewController animated:YES];

}


#pragma mark - Memory Manage

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
       
        self.view.top = 0;
        
    }];
}

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
