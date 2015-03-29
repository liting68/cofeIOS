//
//  InviteDateVC.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/24.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "InviteDateVC.h"
#import "MyInviteCell.h"
#import "PostDateView.h"
#import "UserCenterVC.h"
#import "WTURLImageView.h"
#import "CafeDetailVC.h"

@interface InviteDateVC ()<PostDateViewDelegate,MyInviteCellDelegate,SWTableViewCellDelegate,WTURLImageViewDelegate>
{
    NSMutableArray * actiArray;
}
@property(nonatomic, strong)PostDateView * postDateView;

@property (nonatomic , assign) int time;

@end

@implementation InviteDateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavView];
    [self forNavBeNoTransparent];
    [self initBackButton];
    [self initSwitchVCForDate];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self initHeaderViewWithTableView:self.tableView];
    [self initFooterViewWithTableView:self.tableView];
    
    page = 1;
    refreshing = YES;
    [self getAboutData];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [self hideTabBar];
    
}

#pragma mark - 切换类别
//////选择///////////0.选择左边  1.选择右边
- (void)selctAtIndex:(int)index {
    
    self.type = index;
    
    page = 1;
    refreshing = YES;
    [self getAboutData];
}

#pragma mark - Super Method

- (void)refreshingAction {
    
    [self getAboutData];
}

- (void)loadingingAction {
    
    [self getAboutData];
}

#pragma mark - UITableViewDelegate & UITbleViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat {
    
    return 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [actiArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyInviteCell * inviteCell = [tableView dequeueReusableCellWithIdentifier:@"MyInviteCell"];
    
    inviteCell.adelegate = self;
    
    NSDictionary * dic = actiArray[indexPath.row];
    
    inviteCell.inviteInfo = dic;
    
    [inviteCell.operButton setHidden:NO];
   // inviteCell.cancelButton.left = 190;
    
    inviteCell.operButton.width = 75;
    inviteCell.operButton.height = 30;
    inviteCell.operButton.right = 307;
    [inviteCell.operButton setBackgroundImage:nil forState:UIControlStateNormal];
    
     if (self.type == 0 ) {
         
         NSString * toNickName = [dic valueForKey:@"to_nick_name"];
         
         inviteCell.titleLabel.text = [NSString stringWithFormat:@"你向\"%@\"发送了约会",toNickName];
         [inviteCell.titleLabel sizeToFit];
         
     }else {
         
         inviteCell.titleLabel.text = @"向你发送了约会";
         [inviteCell.titleLabel sizeToFit];
         
     }
    
    [inviteCell.numberLabel setHidden:YES];
    
    NSString * photo = [dic valueForKey:@"photo"];
    
    [inviteCell initInviteCell];
    
    [inviteCell.avatarView setURL:photo defaultImage:nil type:1];
    
    if (self.type == 0 ) {

        int status = [[dic valueForKey:@"status"] intValue];
        
        if (status == 4) {
            
            [inviteCell.operButton setTitle:@"已取消" forState:UIControlStateNormal];
            [inviteCell.operButton setTitleColor:[UIColor colorWithWhite:0.835 alpha:1.000] forState:UIControlStateNormal];
            
            inviteCell.operButton.enabled = NO;
          [inviteCell.cancelButton setHidden:YES];
            
        }else if (status == 2) {
            
            [inviteCell.operButton setTitle:@"对方已同意" forState:UIControlStateNormal];
            [inviteCell.operButton setTitleColor:[UIColor colorWithRed:0.643 green:0.776 blue:0.616 alpha:1.000] forState:UIControlStateNormal];
          [inviteCell.cancelButton setHidden:YES];
            
            inviteCell.operButton.enabled = NO;
        
        }else if (status == 3) {
            
            [inviteCell.operButton setTitle:@"对方已拒绝" forState:UIControlStateNormal];
            [inviteCell.operButton setTitleColor:[UIColor colorWithWhite:0.835 alpha:1.000] forState:UIControlStateNormal];
            
            inviteCell.operButton.enabled = NO;
              [inviteCell.cancelButton setHidden:YES];
        
        }else if (status == 1) {
            
            int isreaded_to_user = [[dic valueForKey:@"isreaded_to_user"] intValue];
            
            if (isreaded_to_user == 1) {
                
                [inviteCell.operButton setTitle:@"对方已查看" forState:UIControlStateNormal];
                [inviteCell.operButton setTitleColor:[UIColor colorWithWhite:0.835 alpha:1.000] forState:UIControlStateNormal];
                  [inviteCell.cancelButton setHidden:YES];
                inviteCell.operButton.enabled = NO;
                
            }else {
            
                [inviteCell.operButton setHidden:YES];
                
                [inviteCell.cancelButton setHidden:NO];
                
                inviteCell.cancelButton.tag = 200;
                dispatch_async(dispatch_get_main_queue(), ^{
                     inviteCell.cancelButton.right = 307;
                });
            
                [inviteCell.cancelButton setBackgroundImage:TTImage(@"invite_cancel_hover") forState:UIControlStateNormal];
            
            }
      }
        
    }else {
        
          [inviteCell.cancelButton setHidden:YES];
        
        int status = [[dic valueForKey:@"status"] intValue];
        
        if (status == 4) {
            
            [inviteCell.operButton setTitle:@"已取消" forState:UIControlStateNormal];
            [inviteCell.operButton setTitleColor:[UIColor colorWithWhite:0.835 alpha:1.000] forState:UIControlStateNormal];
            
            inviteCell.operButton.enabled = NO;
            
        }else if (status == 2) {
            
            [inviteCell.operButton setTitle:@"已同意" forState:UIControlStateNormal];
            [inviteCell.operButton setTitleColor:[UIColor colorWithRed:0.643 green:0.776 blue:0.616 alpha:1.000] forState:UIControlStateNormal];
            
            inviteCell.operButton.enabled = NO;
            
        }else if (status == 3) {
            
            [inviteCell.operButton setTitle:@"已拒绝" forState:UIControlStateNormal];
            [inviteCell.operButton setTitleColor:[UIColor colorWithWhite:0.835 alpha:1.000] forState:UIControlStateNormal];
            
            inviteCell.operButton.enabled = NO;
            
        }else if (status == 1) {
            
            int isreaded_to_user = [[dic valueForKey:@"isreaded_to_user"] intValue];
            
            if (isreaded_to_user == 1) {
                
                [inviteCell.operButton setTitle:@"已查看" forState:UIControlStateNormal];
                [inviteCell.operButton setTitleColor:[UIColor colorWithWhite:0.835 alpha:1.000] forState:UIControlStateNormal];
                
                inviteCell.operButton.enabled = NO;
                
            }else {

               
                [inviteCell.operButton setHidden:YES];
                
                [inviteCell.cancelButton setBackgroundImage:TTImage(@"invite_look_hover") forState:UIControlStateNormal];
                inviteCell.cancelButton.tag = 100;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    inviteCell.cancelButton.right = 307;
                });
                
                [inviteCell.cancelButton setHidden:NO];
                
            }
        }
    }
    
    inviteCell.section = indexPath.section;
    inviteCell.row = indexPath.row;
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonForDeleteWithColor:[UIColor redColor] title:@"删除"];
    
    inviteCell.delegate = self;
    
    [inviteCell setRightUtilityButtons:rightUtilityButtons WithButtonWidth:60.0f];
   
    return inviteCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
      NSDictionary * actiInfo = actiArray[indexPath.row];
    
      [self openPostDateViewWithInviteInfo:actiInfo];
}

- (void)openPostDateViewWithInviteInfo:(NSDictionary *)actiInfo {

    NSString * invietID =  [actiInfo valueForKey:@"id"];
    
    NSNumber * userID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"invitation",@"c",@"getInvitation",@"act",userID,@"userid", invietID,@"invitationid",nil];
    
    [AppUtil showHudInView:self.view tag:10003];
    
    [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [AppUtil hideHudInView:self.view mtag:10003];
        [header endRefreshing];
        [footer endRefreshing];
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!self.postDateView) {
                    
                    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PostDateView" owner:nil options:nil];
                    _postDateView  = [nibView objectAtIndex:0];
                    _postDateView.frame = CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, K_UIMAINSCREEN_HEIGHT);
                    _postDateView.delegate = self;
                    
                    _postDateView.userInteractionEnabled = YES;
                    [self.view addSubview:_postDateView];
                    [_postDateView setHidden:YES];
                    
                    // [_postDateView.postButton setHidden:YES];
                    
                    [_postDateView.telField setEnabled:NO];
                    
                    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
                    tapGesture.numberOfTapsRequired = 1;
                    [_postDateView addGestureRecognizer:tapGesture];
                    
                }
                
                if (self.type == 0) {//我自己创建的额
                    
                    [self.postDateView.acctptButton setHidden:YES];
                    [self.postDateView.rejectButton setHidden:YES];
                    
                    int status = [[actiInfo valueForKey:@"status"] intValue];
                    
                    if (status == 4) {
                        
                        [self.postDateView.acctptButton setHidden:YES];
                        [self.postDateView.rejectButton setHidden:YES];
                        [self.postDateView.postButton setHidden:YES];
                        [self.postDateView.inviteState setHidden:NO];
                        
                        self.postDateView.inviteState.text = @"已取消";
                        self.postDateView.inviteState.textColor = [UIColor lightGrayColor];
                        self.postDateView.inviteState.left = 100;
                        
                        
                    }else if (status == 2) {
                        
                        [self.postDateView.acctptButton setHidden:YES];
                        [self.postDateView.rejectButton setHidden:YES];
                        [self.postDateView.postButton setHidden:YES];
                        [self.postDateView.inviteState setHidden:NO];
                        
                        self.postDateView.inviteState.text = @"对方已同意";
                        self.postDateView.inviteState.textColor = [UIColor colorWithRed:0.161 green:0.608 blue:0.584 alpha:1.000];
                        self.postDateView.inviteState.left = 100;
                        
                        
                    }else if (status == 3) {
                        
                        [self.postDateView.acctptButton setHidden:YES];
                        [self.postDateView.rejectButton setHidden:YES];
                        [self.postDateView.postButton setHidden:YES];
                        [self.postDateView.inviteState setHidden:NO];
                        
                        self.postDateView.inviteState.text = @"对方已拒绝";
                        self.postDateView.inviteState.textColor = [UIColor lightGrayColor];
                        self.postDateView.inviteState.left = 100;
                        
                        
                    }else if (status == 1) {
                        
                        int isreaded_to_user = [[actiInfo valueForKey:@"isreaded_to_user"] intValue];
                        
                        if (isreaded_to_user == 1) {
                            
                            [self.postDateView.acctptButton setHidden:YES];
                            [self.postDateView.rejectButton setHidden:YES];
                            [self.postDateView.postButton setHidden:NO];
                            [self.postDateView.inviteState setHidden:NO];
                            
                            self.postDateView.inviteState.text = @"对方已查看";
                            
                            [self.postDateView.postButton setTitle:@"取消" forState:UIControlStateNormal];
                            [self.postDateView.postButton setBackgroundImage:TTImage(@"reject_bg") forState:UIControlStateNormal];
                            
                            
                            self.postDateView.postButton.left = 55;
                            self.postDateView.inviteState.left = self.postDateView.postButton.right;
                            
                            [self.postDateView setNeedsDisplay];
                            [self.postDateView setNeedsLayout];
                            
                        }else {
                            
                            [self.postDateView.acctptButton setHidden:YES];
                            [self.postDateView.rejectButton setHidden:YES];
                            [self.postDateView.postButton setHidden:NO];
                            [self.postDateView.inviteState setHidden:YES];
                            
                            [self.postDateView.postButton setTitle:@"取消" forState:UIControlStateNormal];
                            [self.postDateView.postButton setBackgroundImage:TTImage(@"reject_bg") forState:UIControlStateNormal];
                        }
                    }
                    
                }else { //搜邀请的
                    
                    int status = [[actiInfo valueForKey:@"status"] intValue];
                    
                    if (status == 4) {
                        
                        [self.postDateView.acctptButton setHidden:YES];
                        [self.postDateView.rejectButton setHidden:YES];
                        [self.postDateView.postButton setHidden:YES];
                        [self.postDateView.inviteState setHidden:NO];
                        
                        self.postDateView.inviteState.text = @"已取消";
                        self.postDateView.inviteState.textColor = [UIColor lightGrayColor];
                        self.postDateView.inviteState.left = 100;
                        
                        
                    }else if (status == 2) {
                        
                        [self.postDateView.acctptButton setHidden:YES];
                        [self.postDateView.rejectButton setHidden:YES];
                        [self.postDateView.postButton setHidden:YES];
                        [self.postDateView.inviteState setHidden:NO];
                        
                        self.postDateView.inviteState.text = @"已同意";
                        self.postDateView.inviteState.textColor = [UIColor colorWithRed:0.161 green:0.608 blue:0.584 alpha:1.000];
                        self.postDateView.inviteState.left = 100;
                        
                    }else if (status == 3) {
                        
                        [self.postDateView.acctptButton setHidden:YES];
                        [self.postDateView.rejectButton setHidden:YES];
                        [self.postDateView.postButton setHidden:YES];
                        [self.postDateView.inviteState setHidden:NO];
                        
                        self.postDateView.inviteState.text = @"已拒绝";
                        self.postDateView.inviteState.textColor = [UIColor lightGrayColor];
                        self.postDateView.inviteState.left = 100;
                        
                        
                    }else if (status == 1) {
                        
                        [self.postDateView.acctptButton setHidden:NO];
                        [self.postDateView.rejectButton setHidden:NO];
                        [self.postDateView.postButton setHidden:YES];
                        [self.postDateView.inviteState setHidden:YES];
                        
                    }
                }
                
                self.selectDicInfo = [[responseObject valueForKey:@"result"] valueForKey:@"invitation"];
                
                _postDateView.postDateDic = actiInfo;
                
                _postDateView.inviteTitle.text = [actiInfo valueForKey:@"title"];
                
                _postDateView.inviteNickNameLabel.text = [self.selectDicInfo valueForKey:@"to_user_nickname"];
                _postDateView.inviteNickName.text = [  self.selectDicInfo valueForKey:@"to_user_nickname"];
                
                NSString * address = [[[responseObject valueForKey:@"result"] valueForKey:@"invitation"] valueForKey:@"address"];
                NSString * datetime = [[[responseObject valueForKey:@"result"] valueForKey:@"invitation"] valueForKey:@"datetime"];
                NSString * tel = [[[responseObject valueForKey:@"result"] valueForKey:@"invitation"] valueForKey:@"tel"];
                
                [_postDateView.inviteTimeButton setTitle:datetime forState:UIControlStateNormal];
                
                [_postDateView.inviteAddressButton setTitle:address forState:UIControlStateNormal];
                
                _postDateView.telField.text = tel;
                _postDateView.telField.enabled = NO;
                
                
                NSString * avatarStr = [self.selectDicInfo valueForKey:@"to_user_photo"];
                [self.postDateView.inviteAvatar setConers];
                self.postDateView.inviteAvatar.delegate = self;
                
                [self.postDateView.inviteAvatar setURL:avatarStr defaultImage:nil type:1];
                
                
                self.postDateView.beInviteNickName.text = [self.selectDicInfo valueForKey:@"user_nickname"];
                
                NSString* myAvatarString = [self.selectDicInfo valueForKey:@"user_photo"];
                
                [self.postDateView.beInviteAvatar setURL:myAvatarString defaultImage:nil type:1];
                [self.postDateView.beInviteAvatar setConers];
                self.postDateView.beInviteAvatar.delegate = self;
                
                _postDateView.alpha = 0;
                [_postDateView setHidden:NO];
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    _postDateView.alpha = 1;
                    
                } completion:^(BOOL finished) {
                    
                }];
            
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [AppUtil hideHudInView:self.view mtag:10003];
        [header endRefreshing];
        [footer endRefreshing];
        NSLog(@"Error: %@", error);
        
    }];
}

#pragma mark - PostDateViewDeleate

- (void)postDateViewDidCall {
    
    NSLog(@"%@",self.selectDicInfo);
    
    NSString * tel = [self.selectDicInfo valueForKey:@"tel"];
    
    NSString * telStr = [NSString stringWithFormat:@"telprompt://%@",tel];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
   // [[UIApplication sharedApplication]  openURL:[NSURL URLWithString:telStr]];
    
}

- (void)postDateViewDidSelectAddress:(PostDateView *)postDateView {
    
    UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CafeDetailVC * cafeDetailVC  = [board instantiateViewControllerWithIdentifier:@"CafeDetailVC"];
 
    cafeDetailVC.cafeName = [self.selectDicInfo valueForKey:@"shop_title"];
    
    cafeDetailVC.cafeID = [NSString stringWithFormat:@"%@",[self.selectDicInfo valueForKey:@"shop_id"]];
    
    [self.navigationController pushViewController:cafeDetailVC animated:YES];

}

#pragma mark - WTURLImageViewDelegate

- (void) URLImageViewDidClicked : (WTURLImageView*)imageView {
    
    if (imageView == self.postDateView.beInviteAvatar) { ///
        
        if (![self checkLogin]) {
            
            return;
        }
        
        UserCenterVC * userCenterVC = [self getStoryBoardControllerWithControllerID:@"UserCenterVC" storyBoardName:@"Other"];
        
       NSString * to_nick_name = [self.selectDicInfo valueForKey:@"nick_name"];
        
        NSString * to_user_id = [self.selectDicInfo valueForKey:@"user_id"];
        
        userCenterVC.otherID = to_user_id;
        userCenterVC.nickName = to_nick_name;
    
        userCenterVC.isRoot = NO;
        
        [self.navigationController pushViewController:userCenterVC animated:YES];
        
    }else {
        
        if (![self checkLogin]) {
            
            return;
        }
        
        
        NSString * to_nick_name = [self.selectDicInfo valueForKey:@"to_nick_name"];
        
        NSString * to_user_id = [self.selectDicInfo valueForKey:@"to_user_id"];
        
        UserCenterVC * userCenterVC = [self getStoryBoardControllerWithControllerID:@"UserCenterVC" storyBoardName:@"Other"];
        userCenterVC.otherID = to_user_id;
        userCenterVC.nickName = to_nick_name;
        userCenterVC.isRoot = NO;
        
        [self.navigationController pushViewController:userCenterVC animated:YES];
    
    }
}

#pragma mark - postDelegate

- (void)postDateViewDidSelectDidPost:(NSDictionary *)dic {
    
    if (self.type == 0) { //取消事件
        
        NSString * inviteID = [dic valueForKey:@"id"];
        
        NSNumber * userID = [[NSUserDefaults standardUserDefaults] currentMemberID];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"invitation",@"c",@"cancelInvitation",@"act",userID,@"userid", inviteID,@"invitationid",nil];
        
        [AppUtil showHudInView:self.view tag:10003];
        
        [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [AppUtil hideHudInView:self.view mtag:10003];
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            if (response.err == 1) {
                
                [AppUtil HUDWithStr:@"取消成功" View:self.view];
                
                [self.postDateView.acctptButton setHidden:YES];
                [self.postDateView.rejectButton setHidden:YES];
                [self.postDateView.postButton setHidden:YES];
                [self.postDateView.inviteState setHidden:NO];
                
                self.postDateView.inviteState.text = @"已取消";
                self.postDateView.inviteState.textColor = [UIColor lightGrayColor];
                self.postDateView.inviteState.left = 100;
                
                
                page = 1;
                refreshing = YES;
                [self getAboutData];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [AppUtil hideHudInView:self.view mtag:10003];
            
            NSLog(@"Error: %@", error);
        }];

    }
}

- (void)postDateViewDidAcceptWithDic:(NSDictionary *)dic {
    
    NSString * invietID =  [dic valueForKey:@"id"];
    
    NSNumber * userID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"invitation",@"c",@"acceptInvitation",@"act",userID,@"userid", invietID,@"invitationid",nil];
    
    [AppUtil showHudInView:self.view tag:10003];
    
    [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [AppUtil hideHudInView:self.view mtag:10003];
        [header endRefreshing];
        [footer endRefreshing];
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
          
            [AppUtil HUDWithStr:@"操作成功" View:self.view];
         
            page = 1;
            refreshing = YES;
            [self getAboutData];
            
    //////////////已同意/////////
            [self.postDateView.acctptButton setHidden:YES];
            [self.postDateView.rejectButton setHidden:YES];
            [self.postDateView.postButton setHidden:YES];
            [self.postDateView.inviteState setHidden:NO];
            
            self.postDateView.inviteState.text = @"已同意";
            self.postDateView.inviteState.textColor = [UIColor colorWithRed:0.161 green:0.608 blue:0.584 alpha:1.000];
            self.postDateView.inviteState.left = 100;
///////////////////////
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [AppUtil hideHudInView:self.view mtag:10003];
        [header endRefreshing];
        [footer endRefreshing];
        NSLog(@"Error: %@", error);
        
    }];
}

- (void)postDateViewDidRejectWithDic:(NSDictionary *)dic {
    
    NSString * invietID =  [dic valueForKey:@"id"];
    
    NSNumber * userID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"invitation",@"c",@"refuseInvitation",@"act",userID,@"userid", invietID,@"invitationid",nil];
    
    [AppUtil showHudInView:self.view tag:10003];
    
    [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [AppUtil hideHudInView:self.view mtag:10003];
        [header endRefreshing];
        [footer endRefreshing];
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            [AppUtil HUDWithStr:@"操作成功" View:self.view];
            
            page = 1;
            refreshing = YES;
            [self getAboutData];
            
            /////////////////////
            [self.postDateView.acctptButton setHidden:YES];
            [self.postDateView.rejectButton setHidden:YES];
            [self.postDateView.postButton setHidden:YES];
            [self.postDateView.inviteState setHidden:NO];
            
            self.postDateView.inviteState.text = @"已拒绝";
            self.postDateView.inviteState.textColor = [UIColor lightGrayColor];
            self.postDateView.inviteState.left = 100;
            ////////////////////////////
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [AppUtil hideHudInView:self.view mtag:10003];
        [header endRefreshing];
        [footer endRefreshing];
        NSLog(@"Error: %@", error);
        
    }];
    
}

#pragma mark - Actions

- (void)tapAction {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.postDateView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self.postDateView setHidden:YES];
        
    }];
    
}

#pragma mark - InviteCellDelegate

-(void)myInviteCell:(MyInviteCell *)myInviteCell didGotoUserDetail:(NSDictionary *)dic {
    
    if (![self checkLogin]) {
        
        return;
    }
    
    if(self.type == 0) {
        
        NSString * toNickName = [dic valueForKey:@"to_nick_name"];
        NSString * user_id = [dic valueForKey:@"to_user_id"];
        
        UserCenterVC * userCenter = [self getStoryBoardControllerWithControllerID:@"UserCenterVC" storyBoardName:@"Other"];
        userCenter.otherID = user_id;
        userCenter.nickName = toNickName;
        [self.navigationController pushViewController:userCenter animated:YES];
        
    }else {
        
        NSString * toNickName = [dic valueForKey:@"nick_name"];
        NSString * user_id = [dic valueForKey:@"user_id"];
        
        UserCenterVC * userCenter = [self getStoryBoardControllerWithControllerID:@"UserCenterVC" storyBoardName:@"Other"];
        userCenter.otherID = user_id;
        userCenter.nickName = toNickName;
        [self.navigationController pushViewController:userCenter animated:YES];

    }
}

- (void)myInviteCellDidCancel:(MyInviteCell *)myInviteCell {
    
    if (myInviteCell.cancelButton.tag == 100) {
        
         [self openPostDateViewWithInviteInfo:myInviteCell.inviteInfo];
        
    }else {
        
        
        NSString * inviteID = [myInviteCell.inviteInfo valueForKey:@"id"];
        
        NSNumber * userID = [[NSUserDefaults standardUserDefaults] currentMemberID];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"invitation",@"c",@"cancelInvitation",@"act",userID,@"userid", inviteID,@"invitationid",nil];
        
        [AppUtil showHudInView:self.view tag:10003];
        
        [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [AppUtil hideHudInView:self.view mtag:10003];
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            if (response.err == 1) {
                
                [AppUtil HUDWithStr:@"取消成功" View:self.view];
                
                page = 1;
                refreshing = YES;
                [self getAboutData];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [AppUtil hideHudInView:self.view mtag:10003];
            
            NSLog(@"Error: %@", error);
        }];

    }
    
}

- (void)myInviteCellDidOpenDetail:(MyInviteCell *)myInviteCell {

      [self openPostDateViewWithInviteInfo:myInviteCell.inviteInfo];
}

#pragma mark - 获取相关数据

- (void)getAboutData {
    
    NSString * pageStr =[NSString stringWithFormat:@"%d",page];
    
    if (self.type == 0){
        
        NSNumber * userID = [[NSUserDefaults standardUserDefaults] currentMemberID];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"invitation",@"c",@"invitationBySend",@"act",userID,@"userid", pageStr,@"page",nil];
        
        [AppUtil showHudInView:self.view tag:10003];
        
        [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [AppUtil hideHudInView:self.view mtag:10003];
            [header endRefreshing];
            [footer endRefreshing];
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            if (response.err == 1) {
                
                if(!actiArray) {
                    
                    actiArray = [[NSMutableArray alloc] initWithCapacity:0];
                }
                
                if (refreshing) {
                    
                    [actiArray removeAllObjects];
                }
                
                [actiArray addObjectsFromArray:response.result];
                
                [self.tableView reloadData];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [AppUtil hideHudInView:self.view mtag:10003];
            [header endRefreshing];
            [footer endRefreshing];
            NSLog(@"Error: %@", error);
        }];
        
        
    }else {
        
        NSNumber * userID = [[NSUserDefaults standardUserDefaults] currentMemberID];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"invitation",@"c",@"invitationByAccept",@"act", userID,@"userid",pageStr,@"page",nil];
        
        [AppUtil showHudInView:self.view tag:10003];
        
        [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [AppUtil hideHudInView:self.view mtag:10003];
            [header endRefreshing];
            [footer endRefreshing];
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            if (response.err == 1) {
                
                if (refreshing) {
                    
                    [actiArray removeAllObjects];
                }
                
                [actiArray addObjectsFromArray:response.result];
                
                [self.tableView reloadData];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [AppUtil hideHudInView:self.view mtag:10003];
            [header endRefreshing];
            [footer endRefreshing];
            NSLog(@"Error: %@", error);
        }];
    }
}

#pragma mark -

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    NSDictionary * dic = actiArray[cell.row];
    
    NSNumber * userID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"invitation",@"c",@"delInvitation",@"act",userID, @"userid",[dic valueForKey:@"id"],@"invitationid",nil];
    
    [AppUtil showHudInView:self.view tag:10003];
    
    [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [AppUtil hideHudInView:self.view mtag:10003];
        [header endRefreshing];
        [footer endRefreshing];
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            page = 1;
            
            refreshing = YES;
            
            [self getAboutData];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [AppUtil hideHudInView:self.view mtag:10003];
        [header endRefreshing];
        [footer endRefreshing];
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - Memory Manage

- (void)dealloc {
    
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
