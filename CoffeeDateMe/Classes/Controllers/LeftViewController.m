//
//  LeftViewController.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/1/29.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "LeftViewController.h"
#import "AvatarView.h"
#import "LeftCell.h"
#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UserCenterVC.h"
#import "DateSquareVC.h"
#import "InviteViewController.h"
#import "SetViewController.h"
#import "NeborCoffeeVenuesViewController.h"
#import "InviteViewController.h"
#import "InviteDateVC.h"
#import "MyCollectVC.h"
#import "AppDelegate.h"
#import "PostLeaveWordViewController.h"
#import "ContactsViewController.h"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate,WTURLImageViewDelegate>
{
    NSArray * titleArray; ///////////
    NSArray * iconArray;  /////////

    UILabel * noInviteReadLabel;
    UIImageView * inviteBg;
    
    UILabel * noMessageLabel;
    UIImageView * messageBg;

}
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    titleArray = @[@"首页",@"好友",@"消息",@"邀请函",@"我的活动",@"我的咖啡厅"/*@"隐身",@"设置"*/];
    iconArray =  @[@"left_homepage",@"friend",@"left_message",@"left_invite",@"make_friActi",@"left_like"/*,@"left_hide_body",@"left_set"*/];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNoReadInvitation) name:K_GET_NO_READ_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateViews) name:K_UPDATE_VIEWS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasSign) name:K_HAS_SIGNIN_NOTIFICATION object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSNumber * currentMemberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    if (currentMemberID) {
        
        [self updateViews];
        
        [self getNoReadInvitation];
    }

    [self.tableView reloadData];
}

- (void)getInviteNoRead {
    
    [self getNoReadInvitation];
    
}

#pragma mark - loginin

- (void)hasSign {
    
    [self updateViews];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
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
     
     
     [[NSUserDefaults standardUserDefaults] setCurrentUserEmail:coffeeName];//将用户名密码存起来
     [[NSUserDefaults standardUserDefaults] setCurrentUserPsw:password];//密码
     
     [[NSUserDefaults standardUserDefaults] setUserInfo:uiDic];//用户信息

     */
    if (indexPath.section == 0) {
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TopCell"];
        cell.backgroundColor = [UIColor clearColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        AvatarView * avatar = (AvatarView *)[cell viewWithTag:100];
        [avatar setConers];
        avatar.delegate = self;
        avatar.userInteractionEnabled = YES;
      
        NSString * address = [[NSUserDefaults standardUserDefaults] currentCityName];
     
       NSNumber * memberID =[[NSUserDefaults standardUserDefaults]currentMemberID];
     
        if (memberID) {
            
            NSString * avatarString = [[[NSUserDefaults standardUserDefaults]userInfo] valueForKey:@"head_photo"];
            
            [[NSUserDefaults standardUserDefaults ]setValue:avatarString forKey:@"avatar"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString * userName = nil;
            
            if ([AppUtil isNotNull:[[[NSUserDefaults standardUserDefaults]userInfo]valueForKey:@"nick_name"]]) {
                
                userName =  [[[NSUserDefaults standardUserDefaults]userInfo]valueForKey:@"nick_name"];
            }else {
                
                userName =  [[[NSUserDefaults standardUserDefaults]userInfo]valueForKey:@"user_name"];
            }
            
            UILabel * label = (UILabel *)[cell viewWithTag:101];
            label.text = userName;
            
            [avatar setURL:avatarString defaultImage:@"chatListCellHead" type:0];
        
        }else {
            
            UILabel * label = (UILabel *)[cell viewWithTag:101];
            label.text = @"未登录";
            
            [avatar setURL:nil defaultImage:@"chatListCellHead" type:0];
        }
        
        UILabel * addressLabel = (UILabel *)[cell viewWithTag:102];
        addressLabel.text = address;
        [addressLabel sizeToFit];
        
        UIImageView * imageView = (UIImageView *)[cell viewWithTag:103];
        
        int offset = (255 - (imageView.width + addressLabel.width))/2;
        
        imageView.left = offset;
        
        addressLabel.left = imageView.right;
        
        return cell;
    
    }/*else if (indexPath.section == 4) {
       
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"listCell_switch"];
          cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView * imageView = (UIImageView *)[cell viewWithTag:100];
        imageView.image = TTImage(iconArray[indexPath.section - 1]);
        
        UIButton * button = (UIButton *)[cell viewWithTag:103];
        
        [button addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
        
        changeStateButton = button;
        
        [self updateViews];
      
        return cell;
        
    }*/else  {
        
        LeftCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LeftCell"];
          cell.backgroundColor = [UIColor clearColor];
        
        UIImageView * imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, 48)];
        imageView1.image = TTImage(@"left_person_selected");
        cell.selectedBackgroundView = imageView1;
        
        NSString * imageName = iconArray[indexPath.section -1];
        NSString * imageNameSelected = [NSString stringWithFormat:@"%@_hover",imageName];
        
        [cell.iconButton setBackgroundImage:TTImage(imageName) forState:UIControlStateNormal];
          [cell.iconButton setBackgroundImage:TTImage(imageNameSelected) forState:UIControlStateSelected];
    
        
        UIImageView * imageView = (UIImageView *)[cell viewWithTag:100];
        imageView.image = TTImage(iconArray[indexPath.section - 1]);
        
        UIButton * button = (UIButton *)[cell viewWithTag:101];
         [button setTitle:titleArray[indexPath.section - 1] forState:UIControlStateNormal];
        
       // UILabel * noReadLabel = (UILabel *)[cell viewWithTag:102];
      //  noReadLabel.layer.cornerRadius = noReadLabel.frame.size.width/2;
       // noReadLabel.layer.masksToBounds = YES;

        [cell.noReadLabel setHidden:YES];
        [cell.noReadView setHidden:YES];
        
        if (indexPath.section == 4) {////邀请函
            
            noInviteReadLabel = cell.noReadLabel;
            inviteBg = cell.noReadView;
        
            if (self.noReadInviteNumber == 0) {
                
                [cell.noReadLabel setHidden:YES];
                [cell.noReadView setHidden:YES];
                
            }else {
                
                [cell.noReadLabel setHidden:NO];
                [cell.noReadView setHidden:NO];
             cell.noReadLabel.text = [NSString stringWithFormat:@"%d",self.noReadInviteNumber];
            }
            
        }else if(indexPath.section == 3) { //消息未读书
            
            noMessageLabel = cell.noReadLabel;
            
            messageBg = cell.noReadView;
            
            if (self.noReadMessage == 0) {
                
                [noMessageLabel setHidden:YES];
                [messageBg setHidden:YES];
                
            }else {
                
                [noMessageLabel setHidden:NO];
                [messageBg setHidden:NO];
                noMessageLabel.text = [NSString stringWithFormat:@"%d",self.noReadMessage];
            }
        }
        
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 190;
    
    }else {
        
        return 48;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0 ||  indexPath.section == 2 ||  indexPath.section == 3 || indexPath.section == 4 ||indexPath.section == 5 ||indexPath.section == 6) {
        
        NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
        
        if(memberID) {
            
            if (indexPath.section == 0) {
             
                UserCenterVC * userCenterVC = [self getStoryBoardControllerWithControllerID:@"UserCenterVC" storyBoardName:@"Other"];
                userCenterVC.isRoot = YES;
                userCenterVC.isMySelf = YES;
                
                UINavigationController * userCenterNAV = [[UINavigationController alloc] initWithRootViewController:userCenterVC];
                
                [self.slideMenuController closeMenuBehindContentViewController:userCenterNAV animated:YES completion:nil];
                
            }else if(indexPath.section == 2){
                
                LeveyTabBarController * leveyTab = self.slideMenuController.rootViewController;
                
                [leveyTab goAtIndex:3];
                
                [self.slideMenuController closeMenuBehindContentViewController:leveyTab animated:YES completion:nil];
            
            }else if (indexPath.section == 3){//消息
                
            
                LeveyTabBarController * leveyTab = self.slideMenuController.rootViewController;
                
                [leveyTab goAtIndex:1];
                
                [self.slideMenuController closeMenuBehindContentViewController:leveyTab animated:YES completion:nil];
        
                
            }else if (indexPath.section == 4) {//邀请函
                
                InviteDateVC * inviteVC =  [self getStoryBoardControllerWithControllerID:@"InviteDateVC" storyBoardName:@"Other"];
                
                inviteVC.isRoot = YES;
                
                UINavigationController * InviteNAV = [[UINavigationController alloc] initWithRootViewController:inviteVC];
                
                [self.slideMenuController closeMenuBehindContentViewController:InviteNAV animated:YES completion:nil];
                
            }else if(indexPath.section == 5) {
                
                InviteViewController * inviteVC = [self getStoryBoardControllerWithControllerID:@"InviteViewController" storyBoardName:@"Other"];
                
                inviteVC.isRoot = YES;
                
                UINavigationController * dateSquareNAV = [[UINavigationController alloc] initWithRootViewController:inviteVC];
                
                [self.slideMenuController closeMenuBehindContentViewController:dateSquareNAV animated:YES completion:nil];

             
            }else if(indexPath.section == 6){
                
                MyCollectVC * myCollectVC = [self getStoryBoardControllerWithControllerID:@"MyCollectVC" storyBoardName:@"Other"];
                
                 myCollectVC.isRoot = YES;
                 
                 UINavigationController * myCollectNAV = [[UINavigationController alloc] initWithRootViewController:myCollectVC];
                 
                 [self.slideMenuController closeMenuBehindContentViewController:myCollectNAV animated:YES completion:nil];
            }

        }else {
            
            LoginViewController * loginVC =  [self getStoryBoardControllerWithControllerID:@"LoginViewController"];
            
            loginVC.isRoot = YES;
            
            UINavigationController * loginNAV = [[UINavigationController alloc] initWithRootViewController:loginVC];
         
            [self.slideMenuController closeMenuBehindContentViewController:loginNAV animated:YES completion:nil];
        }
        
    }else {
        
        if (indexPath.section == 1) {
            
           LeveyTabBarController * leveyTab = self.slideMenuController.rootViewController;
            
            [leveyTab goAtIndex:0];
            
            [self.slideMenuController closeMenuBehindContentViewController:leveyTab animated:YES completion:nil];
            
        }else if (indexPath.section == 3) {
            
     
            UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
            PostLeaveWordViewController * postLeaveWordViewController = [board instantiateViewControllerWithIdentifier:@"PostLeaveWordViewController"];
                
            postLeaveWordViewController.isRoot = YES;
            
            UINavigationController * postNav = [[UINavigationController alloc] initWithRootViewController:postLeaveWordViewController];
            
            [self.slideMenuController closeMenuBehindContentViewController:postNav animated:YES completion:nil];
            

        }
        
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

#pragma mark - 获取未读邀请书

- (void)getNoReadInvitation {
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults]currentMemberID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"invitation",@"c",@"getNewInvitationCounts",@"act",memberID,@"userid", nil];
    
   // [AppUtil showHudInView:self.view tag:10000];
    
    [manager POST:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject){
        
     //   [AppUtil hideHudInView:self.view mtag:10000];
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            NSLog(@"%@",responseObject);
            
            NSString * countStr = [[responseObject valueForKey:@"result"] valueForKey:@"count"];
        
            if ([AppUtil isNotNull:countStr]) {
                
                int count = [countStr intValue];
                
                [self  setNoReadNumber:count];
            }
            /////////////////////////////////
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [AppUtil hideHudInView:self.view mtag:10000];
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)setNoReadNumber:(int)number {
    
    if (number == 0) {
        
        [noInviteReadLabel setHidden:YES];
        [inviteBg setHidden:YES];
    
    }else {
        
        [noInviteReadLabel setHidden:NO];
        [inviteBg setHidden:NO];
         noInviteReadLabel.text = [NSString stringWithFormat:@"%d",number];
    }
}

- (void)setNoReadMsg:(int)number {
    
    self.noReadMessage = number;
    
    if (number == 0) {
        
        [noMessageLabel setHidden:YES];
        [messageBg setHidden:YES];
        
    }else {
        
        [noMessageLabel setHidden:NO];
        [messageBg setHidden:NO];
        noMessageLabel.text = [NSString stringWithFormat:@"%d",number];
    }
}

#pragma mark - 更新是否获取消息的状态

- (void)updateViews {
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    if (memberID) {///登录状态下
        
        NSDictionary * userInfo = [[NSUserDefaults standardUserDefaults]userInfo];
        /*
         allow_find //找到我1允许2不允许
         allow_flow //关注我 1允许2不允许   left_open
         */
        if ([AppUtil isNotNull:[userInfo valueForKey:@"allow_find"]]) {
            
            int allowFind = [[userInfo valueForKey:@"allow_find"] intValue];
            
            if (allowFind == 1) {
                
                 [self.yinshen setBackgroundImage:TTImage(@"left_close") forState:UIControlStateNormal];
                
            }else if(allowFind == 2){
                
                [self.yinshen setBackgroundImage:TTImage(@"left_open") forState:UIControlStateNormal];
                
            }else {
                
                 [self.yinshen setBackgroundImage:TTImage(@"left_close") forState:UIControlStateNormal];
            }
            
        }else {
            ///空就是 隐身--》可找到
             [self.yinshen setBackgroundImage:TTImage(@"left_close") forState:UIControlStateNormal];
            
        }
        
    }else {//未登录-->默认显示NO
        
        [self.yinshen setBackgroundImage:TTImage(@"left_close") forState:UIControlStateNormal];
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
        
    }else if(type == 1) {//允许找到我
        
        c = @"user";
        act = @"allowFind";
        
    }else if(type == 2){//允许关注我
        
        c = @"user";
        act = @"allowFlow";
    }
    
    NSNumber * memebrID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters;
    
    parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:c,@"c",act,@"act",memebrID,@"userid",[NSNumber numberWithInt:allow],@"allow", nil];
    
    [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            //[AppUtil HUDWithStr:@"修改成功" View:self.view];
            
            NSMutableDictionary * userInfo = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]userInfo]];
            
            if (type == 1) {
                
                [userInfo setValue:[NSString stringWithFormat:@"%d",allow] forKey:@"allow_find"];
                
            }else {
                
                [userInfo setValue:[NSString stringWithFormat:@"%d",allow]  forKey:@"allow_flow"];
                
            }
            [[NSUserDefaults standardUserDefaults] setUserInfo:userInfo];
            
            [self updateViews];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - Actions

- (IBAction)setAction:(id)sender {
    
     SetViewController * setVC = [self getStoryBoardControllerWithControllerID:@"SetViewController"];
     setVC.isRoot = YES;
     
     UINavigationController * setNAV = [[UINavigationController alloc] initWithRootViewController:setVC];
     
     [self.slideMenuController closeMenuBehindContentViewController:setNAV animated:YES completion:nil];
}

- (IBAction)changeStateAction:(id)sender {
    
    [self changeState];
    
}

- (void)changeState {
    
    int allow_find = [[[[NSUserDefaults standardUserDefaults] userInfo]valueForKey:@"allow_find"] intValue];
    
    if (allow_find == 1) {
        
        [self setWithType:1 allow:2];
        
    }else {
        
        [self setWithType:1 allow:1];
    }
}

#pragma mark - WTUrlImageViewDelegate

- (void) URLImageViewDidClicked : (WTURLImageView*)imageView {
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    if (memberID) {
        
        UserCenterVC * userCenterVC = [self getStoryBoardControllerWithControllerID:@"UserCenterVC" storyBoardName:@"Other"];
        
        userCenterVC.isMySelf = YES;
        userCenterVC.isRoot = YES;
        
        UINavigationController * userCenterNAV = [[UINavigationController alloc] initWithRootViewController:userCenterVC];
        
        [self.slideMenuController closeMenuBehindContentViewController:userCenterNAV animated:YES completion:nil];
        
    }else {
        
        LoginViewController * loginVC =  [self getStoryBoardControllerWithControllerID:@"LoginViewController"];
        
        loginVC.isRoot = YES;
        
        UINavigationController * loginNAV = [[UINavigationController alloc] initWithRootViewController:loginVC];
        
        [self.slideMenuController closeMenuBehindContentViewController:loginNAV animated:YES completion:nil];

        
    }
}

#pragma mark - Memory Manage

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:K_GET_NO_READ_NOTIFICATION object:nil];
    
      [[NSNotificationCenter defaultCenter] removeObserver:self name:K_UPDATE_VIEWS object:nil];

}

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
