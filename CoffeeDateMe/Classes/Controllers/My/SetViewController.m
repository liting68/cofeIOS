//
//  SetViewController.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-10-17.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "SetViewController.h"
#import "JSONKit.h"
#import "EvaluateCofeViewController.h"
#import "AboutViewController.h"
#import "FindBackPwdVC.h"

@interface SetViewController ()

@end

@implementation SetViewController

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
    
    [self forIOS7:self];
    [self initBackButton];
    [self initTitleViewWithTitleString:@"设置"];
    
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.tableView.bounces = NO;
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults]currentMemberID];
    
    if (memberID) {
        
        [self.logoutButton setHidden:NO];
    
    }else {
        
        [self.logoutButton setHidden:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
 
    [self.navigationController.navigationBar setHidden:NO];
    
    [self hideTabBar];
    
    [self updateViews];
}

#pragma mark - actions

- (IBAction)logoutAction:(id)sender {
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退出吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 5;
    alertView.delegate = self;
    [alertView show];
}

- (void)backAction {
    
    if (self.isRoot) {
        
        [self.slideMenuController closeMenuBehindContentViewController:self.slideMenuController.rootViewController animated:YES completion:^(BOOL finished) {
            
        }];
        
    }else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)updateViews {
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    if (memberID) {///登录状态下
        
       NSDictionary * userInfo = [[NSUserDefaults standardUserDefaults]userInfo];
        /*
         allow_find //找到我1允许2不允许
         allow_flow //关注我 1允许2不允许
         */
        if ([AppUtil isNotNull:[userInfo valueForKey:@"allow_find"]]) {
            
            int allowFind = [[userInfo valueForKey:@"allow_find"] intValue];
            
            if (allowFind == 1) {
                
                self.allowFind.on = YES;
            
            }else if(allowFind == 2){
                
                self.allowFind.on = NO;
          
            }else {
                
                self.allowFind.on = YES;
            }
            
            
        }else {
            
            self.allowFind.on = YES;
            
        }
        
        
        if ([AppUtil isNotNull:[userInfo valueForKey:@"allow_flow"]]) {
            
            int allowFlow = [[userInfo valueForKey:@"allow_flow"] intValue];
            
            if (allowFlow == 1) {
                
                self.allowAdd.on = YES;
                
            }else if(allowFlow == 2){
                
                self.allowAdd.on = NO;
            }else {
                
                self.allowAdd.on = YES;
            }
            
            
        }else {
            
            self.allowAdd.on = YES;
            
        }
        
        [self.logoutButton setHidden:NO];
        
    }else {//未登录-->默认显示YES
        
        self.allowAdd.on = YES;
        self.allowFind.on = YES;
        
        [self.logoutButton setHidden:YES];
    }
    
}

- (void)clearSuccess {
    
       [AppUtil HUDWithStr:@"缓存清除完成" View:self.view];
}

#pragma mark - 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {//清理缓存
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachePath = [paths objectAtIndex:0];
        [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
        
        [self performSelector:@selector(clearSuccess) withObject:nil afterDelay:1.5];
   
    }else if (indexPath.section == 3){
        
        FindBackPwdVC *findBackPwdVC = (FindBackPwdVC *)[self getStoryBoardControllerWithControllerID:@"FindBackPwdVC" storyBoardName:@"Other"];
        
        findBackPwdVC.isMod = YES;
        
        [self.navigationController pushViewController:findBackPwdVC animated:YES];
        
    }else if (indexPath.section == 4){//意见反馈
        
        if (indexPath.row == 0) {
            
            AboutViewController * aboutVC = [[AboutViewController alloc] init];
            
            [self.navigationController pushViewController:aboutVC animated:YES];

        }else if (indexPath.row == 1){
    
            EvaluateCofeViewController * evaluateVC = [self getStoryBoardControllerWithControllerID:@"EvaluateCofeViewController"];
            
            [self.navigationController pushViewController:evaluateVC animated:YES];
            
            
           // UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"拨打电话 021-8208820" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            //alertView.tag = 9999;
            
           // [alertView show];
            
        }else if (indexPath.row == 2) {
       
            NSURL * hURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/ka-fei-yue-wo/id947284395?l=zh&ls=1&mt=8"];
            
            [[UIApplication sharedApplication] openURL:hURL];

        
        }else if (indexPath.row == 3) {
            
    
            
        }
        
     }
}
#pragma mark - 检查版本更新

-(void)checkVersionUpdate
{
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/lookup?id=932232572"];//咖啡约我链接
    NSData *data = [NSData dataWithContentsOfURL:url];
   
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSDictionary * dic = [string objectFromJSONString];
    
    if([[dic objectForKey:@"resultCount"] intValue])
    {
        NSDictionary *resultdic = [[dic objectForKey:@"results"] objectAtIndex:0];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        self.resultDic = resultdic;
        
        if([[self.resultDic objectForKey:@"version"] floatValue] > [app_Version floatValue])
        {
            self.updateUrlString = [self.resultDic objectForKey:@"trackViewUrl"];
            NSString *msg = [NSString stringWithFormat:@"咖啡约我%@\n%@",[self.resultDic objectForKey:@"version"],[self.resultDic objectForKey:@"releaseNotes"]];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"版本有更新" message:msg delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"暂不更新", nil];
            alert.tag = 3;
            [alert show];
        }
        else if ([[self.resultDic objectForKey:@"version"] isEqualToString: app_Version] )
        {
            [AppUtil HUDWithStr:@"已是最新版本" View:self.view];
        }
        else
        {
            NSArray *array = [[self.resultDic objectForKey:@"version"] componentsSeparatedByString:@"."];
            NSString *string = [array objectAtIndex:array.count-1];
            NSArray *array2 = [app_Version componentsSeparatedByString:@"."];
            NSString *string2 = @"";
            if(array2.count>2)
            {
                string2 = [array2 objectAtIndex:array2.count-1];
            }
            else
            {
                string2 = @"0";
            }
            if([string floatValue]>[string2 floatValue])
            {
                self.updateUrlString = [self.resultDic objectForKey:@"trackViewUrl"];
                NSString *msg = [NSString stringWithFormat:@"handone%@\n%@",[self.resultDic objectForKey:@"version"],[self.resultDic objectForKey:@"releaseNotes"]];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"版本有更新" message:msg delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"暂不更新", nil];
                alert.tag = 3;
                [alert show];
            }
            else
            {
                 [AppUtil HUDWithStr:@"已是最新版本" View:self.view];
            }
        }
    }
    else
    {
        [AppUtil HUDWithStr:@"已是最新版本" View:self.view];
    }
}

#pragma mark - UIAlertViewDelegaate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 9999) { //拨打电话
        
        if (buttonIndex == 1) {
            
            NSString * tel = [NSString stringWithFormat:@"tel://0218208820"];
            
            NSURL * telURL = [NSURL URLWithString:tel];
            
            [[UIApplication sharedApplication] openURL:telURL];
            
        }
        
    }else if(alertView.tag == 3) //版本更新
    {
        switch (buttonIndex) {
            case 0:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrlString]];
                
                break;
            case 1:
                
                break;
            default:
                break;
        }
    
    }else if(alertView.tag == 5){ ////退出
        
        if (buttonIndex == 1) {
            
            [[NSUserDefaults standardUserDefaults] clearCurrentMemberID];
            
            [[NSUserDefaults standardUserDefaults]clearUserInfo];
        
            [[NSUserDefaults standardUserDefaults] clearUserEmail];
            [[NSUserDefaults standardUserDefaults]clearPwd];
            
            [[EaseMob sharedInstance].chatManager asyncLogoff];
            
            [self.logoutButton setHidden:YES];
            
           // [self.navigationController popViewControllerAnimated:YES];
            
            ////////////////////////////////////
            ///发出通知
            [[NSNotificationCenter defaultCenter] postNotificationName:K_GOTOLOGIN_FROM_SET object:nil];
            
            // [self updateViews];////
        }
    }
}


#pragma mark - 获取数据

//0 允许获取经纬度 1.允许找到我  2.允许关注我

- (void)setWithType:(int)type allow:(int)allow {//1.允许 2.不允许
    
    NSString * c;
    NSString * act;
    
    if (type == 0) {//允许定位
        
        c = @"user";
        act = @"allowLngLat";
        
    }else if(type ==1) {//允许找到我
        
        c = @"user";
        act = @"allowFind";
        
    }else if(type == 2){//允许关注我
        
        c = @"user";
        act = @"allowFlow";
    }
    
    NSNumber * memebrID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters;
    
    parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:c,@"c",act,@"act",memebrID,@"user_id",[NSNumber numberWithInt:allow],@"allow", nil];
    
    [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
           
            [AppUtil HUDWithStr:@"修改成功" View:self.view];
        
            
            NSMutableDictionary * userInfo = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]userInfo]];
            
            if (type == 1) {
         
                [userInfo setValue:[NSString stringWithFormat:@"%d",allow] forKey:@"allow_find"];
                
            }else {
                
                [userInfo setValue:[NSString stringWithFormat:@"%d",allow]  forKey:@"allow_flow"];
               
            }
            
            [[NSUserDefaults standardUserDefaults] setUserInfo:userInfo];

        }else {
            
            ///修改未成功，必须改回复原来的状态
            BOOL on = (allow == 1)?NO:YES;
            
            if (type == 1) {
                
                self.allowFind.on = on;
                
            }else {
                
                self.allowAdd.on = on;
            }

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark -

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
