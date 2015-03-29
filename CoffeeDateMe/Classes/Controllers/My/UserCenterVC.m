//
//  UserCenterVC.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/9.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "UserCenterVC.h"
#import "ChatListCell.h"
#import "HeaderCell.h"
#import "TGRImageViewController.h"
#import "TGRImageZoomAnimationController.h"
#import "InviteViewController.h"
#import "ChatViewController.h"
#import "PhotoLibraryVC.h"
#import "DateSquareVC.h"
#import "InfoCell.h"
#import "NeborCoffeeVenuesViewController.h"
#import "AddrSelectView.h"
#import "UIColor+expanded.h"

#define TIME 0.000001
#define EDIT_LEFT 110
#define NO_EDIT_LEFT 110

@interface UserCenterVC ()<UITableViewDataSource,UITableViewDelegate,UIViewControllerTransitioningDelegate,HeaderCellDelegate,UIActionSheetDelegate,WTURLImageViewDelegate,PostDateViewDelegate,NeborCoffeeSelectedDelegate,AddrSelectDelegate,ModifyInfoVCDelegate>
{
    AddrSelectView * addreSelectView;
    
      UIView * moreView;
}
@property (nonatomic, strong) NSMutableDictionary * userinfoDic;
@property (nonatomic, strong) NSMutableDictionary * editDic;

////////////用户中心的头像和大图
@property (nonatomic, strong) AvatarView * avatarView;
@property (nonatomic, strong) WTURLImageView * avatarBigView;
@property (nonatomic, strong) UILabel * numberLabel;

@property (nonatomic, strong) UITextView * sigitureView;
/////////

@end

@implementation UserCenterVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     self.isEdit = NO;
    
    if (self.isFromLogin) {
     
        [self editAction];
    }
      ///确认是自己
    if (self.isMySelf) {
      
        self.isMySelf = YES;
        
    }else {
        
        NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
        
        if (!memberID) {
            
            self.isMySelf = NO;
         
        }else {
            
            if([memberID intValue] == [self.otherID intValue]) {
                
                self.isMySelf = YES;
            
            }else {
                
                self.isMySelf = NO;
            }
            
        }
    }
    
    if (self.isMySelf) {
        
        [self changeConstraints];
        [self.mailButton setHidden:YES];
    
    }else {
        
        [self changeOContraints];
        [self.mailButton setHidden:NO];
        
    }
/////表格
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (!self.isMySelf) {
        
        _keyArray = [NSArray arrayWithObjects:@"",@"个人签名",@"我的约会",@"约我账号",@"昵称",@"性别",@"年龄",@"星座",/*@"昵称",*/@"职业",@"籍贯",@"兴趣",@"关系", nil];
        
        _valArray = [NSArray arrayWithObjects:@"",@"signature",@"",@"user_name",@"nick_name",@"sex",@"age",@"constellation",/*@"nick_name",*/@"career",@"home",@"interest",@"relation",nil];
    
    }else {
        
        _allXZArray = [NSArray arrayWithObjects:@"保密",@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座", nil];
        
        _keyArray = [NSArray arrayWithObjects:@"",@"个人签名",@"我的约会",@"约我账号",@"昵称",@"性别",@"年龄",@"星座",@"职业",@"籍贯",@"兴趣", nil];
        
        _valArray = [NSArray arrayWithObjects:@"",@"signature",@"",@"user_name",@"nick_name",@"sex",@"age",@"constellation",@"career",@"home",@"interest",nil];
    }
    
    if (self.isFromLogin) {
    
        [AppUtil HUDWithStr:@"请先完善信息" View:self.view];
        
        [self performSelector:@selector(getMyUserInfo) withObject:nil afterDelay:1.5];
        
    }else {
        
        [self getMyUserInfo];
    }
    
    /////////初始化
    [self initNavView];
   
    if (![self isFromLogin]) {
        
        [self initBackButton];
    }
    
    [self forNavBeTransparent];
   
    if (self.isMySelf) {
        
        [self initTitleViewWithTitleString:@"个人资料"];
        
        if (self.isEdit) {
            
              [self initWithRightButtonWithImageName:nil title:@"完成" action:@selector(editAction)];
        
        }else {
            
             [self initWithRightButtonWithImageName:nil title:@"编辑" action:@selector(editAction)];
        }
        
    }else {
        
        [self initTitleViewWithTitleString:self.nickName];
        
       // [self initWithRightButtonWithImageName:@"make_friActi" title:nil action:@selector(likeAction)];
        
          [self initWithRightButtonWithImageName:@"pd_more" title:nil action:@selector(moreAction)];
        
    }
    
    if(self.isMySelf) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMyUserInfo) name:K_UPDATE_USER_INFO_NOTIFICATION object:nil];
        
        ///相册信息数组
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatePhotoLibrary:) name:k_PHOTO_LIBLARY_UPDATE object:nil];
        
    }else {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMyUserInfo) name:K_LOGIN_NOTIFICATION object:nil];
        
    }
    
}


- (void) initWithRightButtonWithImageName:(NSString *)imageName title:(NSString *)title action:(SEL)action {
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (imageName) {
        
        rightButton.frame = CGRectMake(265, 6 + 20, 50, 28);
        [rightButton setImage:TTImage(imageName) forState:UIControlStateNormal];
        
    }else {
        
        rightButton.frame = CGRectMake(256, 13 + 20, 64, 18);
        
        [rightButton setTitle:title forState:UIControlStateNormal];
        
        [rightButton setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
        
    }
    
    myRightButton = rightButton;
    
    
    [myNavigationView addSubview:rightButton];
    // UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    //self.navigationItem.rightBarButtonItem = rightButtonItem;
}

#pragma mark -

- (void)viewWillAppear:(BOOL)animated {
    
    if (self.isMySelf) {
        
        [self changeConstraints];
        
    }
    
    if (self.isFromLogin) {
        
        [self panGestureEnable:NO];
    }
    
    //[self.tableView reloadData];
    
    [self hideTabBar];
}

- (void)viewWillDisappear:(BOOL)animated  {
    
    if (self.isFromLogin) {
        
        [self panGestureEnable:YES];
    }
    
}
- (void)changeConstraints {
    
    [self.view removeConstraint:self.bottomConstraint];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    
    [self.view setNeedsLayout];
}

- (void)changeOContraints {
    
    [self.view removeConstraint:self.bottomConstraint];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_tableView]-49-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    
    [self.view setNeedsLayout];
}

#pragma mark - Actions

- (void)moreAction {
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    if (!memberID) {
        
        [self gotoLogin];
        
        return;
    }
    
    if (!moreView) {
        
        moreView = [[UIView alloc] initWithFrame:CGRectMake(K_UIMAINSCREEN_WIDTH - 84, 64, 88, 84)];
        moreView.backgroundColor = [UIColor clearColor];
        
        [self updateMoreView];
        
        if (![moreView superview]) {
            
            [self.view addSubview:moreView];
            
        }
    }
    
    if (moreView.hidden == YES) {
        
        moreView.hidden = NO;
        
    }else {
        
        moreView.hidden = YES;
    }
}

- (void)likeAction:(UIButton *)button { //关注
    
     [moreView setHidden:YES];
    
    [self focusWithUserId:self.otherID];
    
}

- (void)nolikeAction:(UIButton *)button {//不在关注
    
     [moreView setHidden:YES];
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    if ([AppUtil isNull:memberID]) {
        
        [self gotoLogin];
        
        return;
    }
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [dic setValue:@"unfollow" forKey:@"act"];
    [dic setObject:@"contact" forKey:@"c"];
    [dic setObject:self.otherID forKey:@"userid"];
    [dic setObject:memberID forKey:@"loginid"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:hostUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            [AppUtil HUDWithStr:@"操作成功" View:self.view];
            
            self.relation_status = [[[responseObject valueForKey:@"result"] valueForKey:@"relation_status"] intValue];
            
            [self updateMoreView];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)removeFromBlack:(UIButton *)button {
    
     [moreView setHidden:YES];
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    if ([AppUtil isNull:memberID]) {
        
        [self gotoLogin];
        
        return;
    }
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [dic setValue:@"unblack" forKey:@"act"];
    [dic setObject:@"contact" forKey:@"c"];
    [dic setObject:self.otherID forKey:@"userid"];
    [dic setObject:memberID forKey:@"loginid"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:hostUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            self.relation_status = [[[responseObject valueForKey:@"result"] valueForKey:@"relation_status"] intValue];
            
            [self updateMoreView];
            
            [AppUtil HUDWithStr:@"移除黑名单成功" View:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)updateMoreView {
    
    for (UIView * view in [moreView subviews]) {
        
        [view removeFromSuperview];
    }
    
    if(self.relation_status == 1) {
        
        moreView.height = 42 * 3;
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, moreView.width, 42);
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"关注" forState:UIControlStateNormal];
        [moreView addSubview:button];
        
        UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(0, 42, moreView.width, 42);
        button1.titleLabel.font = [UIFont systemFontOfSize:16];
        [button1 addTarget:self action:@selector(pullBackAction:) forControlEvents:UIControlEventTouchUpInside];
        [button1 setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button1 setTitle:@"拉黑" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [moreView addSubview:button1];
        
        
        UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame = CGRectMake(0, 84, moreView.width, 42);
        button2.titleLabel.font = [UIFont systemFontOfSize:16];
        [button2 addTarget:self action:@selector(reportAction:) forControlEvents:UIControlEventTouchUpInside];
        [button2 setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button2 setTitle:@"举报" forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [moreView addSubview:button2];
        
        [moreView setHidden:YES];
        
    }else if (self.relation_status == 2) {
        
        moreView.height = 42 * 3;
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, moreView.width, 42);
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(nolikeAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"不再关注" forState:UIControlStateNormal];
        [moreView addSubview:button];
        
        UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(0, 42, moreView.width, 42);
        button1.titleLabel.font = [UIFont systemFontOfSize:16];
        [button1 addTarget:self action:@selector(pullBackAction:) forControlEvents:UIControlEventTouchUpInside];
        [button1 setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button1 setTitle:@"拉黑" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [moreView addSubview:button1];
        
        
        UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame = CGRectMake(0, 84, moreView.width, 42);
        button2.titleLabel.font = [UIFont systemFontOfSize:16];
        [button2 addTarget:self action:@selector(reportAction:) forControlEvents:UIControlEventTouchUpInside];
        [button2 setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button2 setTitle:@"举报" forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [moreView addSubview:button2];
        
        [moreView setHidden:YES];
        
    }else if(self.relation_status == 3){
        
        moreView.height = 42 * 4;
        
        UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(0, 0, moreView.width, 42);
        button1.titleLabel.font = [UIFont systemFontOfSize:16];
        [button1 addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        [button1 setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button1 setTitle:@"关注" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [moreView addSubview:button1];
        
        UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame = CGRectMake(0, 42, moreView.width, 42);
        button2.titleLabel.font = [UIFont systemFontOfSize:16];
        [button2 addTarget:self action:@selector(removeFans:) forControlEvents:UIControlEventTouchUpInside];
        [button2 setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button2 setTitle:@"移除粉丝" forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [moreView addSubview:button2];
        
        
        UIButton * button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        button3.frame = CGRectMake(0, 84, moreView.width, 42);
        button3.titleLabel.font = [UIFont systemFontOfSize:16];
        [button3 addTarget:self action:@selector(pullBackAction:) forControlEvents:UIControlEventTouchUpInside];
        [button3 setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button3 setTitle:@"拉黑" forState:UIControlStateNormal];
        [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [moreView addSubview:button3];
        
        
        UIButton * button4 = [UIButton buttonWithType:UIButtonTypeCustom];
        button4.frame = CGRectMake(0, 126, moreView.width, 42);
        button4.titleLabel.font = [UIFont systemFontOfSize:16];
        [button4 addTarget:self action:@selector(reportAction:) forControlEvents:UIControlEventTouchUpInside];
        [button4 setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button4 setTitle:@"举报" forState:UIControlStateNormal];
        [button4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [moreView addSubview:button4];

        
        
        [moreView setHidden:YES];
        
        
    }else if (self.relation_status == 4) {
        
        moreView.height = 42 * 5;
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, moreView.width, 42);
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(beizhu:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"备注" forState:UIControlStateNormal];
        [moreView addSubview:button];
        
        UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(0, 42, moreView.width, 42);
        button1.titleLabel.font = [UIFont systemFontOfSize:16];
        [button1 addTarget:self action:@selector(nolikeAction:) forControlEvents:UIControlEventTouchUpInside];
        [button1 setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button1 setTitle:@"不再关注" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [moreView addSubview:button1];
        
        
        UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame = CGRectMake(0, 84, moreView.width, 42);
        button2.titleLabel.font = [UIFont systemFontOfSize:16];
        [button2 addTarget:self action:@selector(removeFans:) forControlEvents:UIControlEventTouchUpInside];
        [button2 setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button2 setTitle:@"移除粉丝" forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [moreView addSubview:button2];
        
        
        UIButton * button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        button3.frame = CGRectMake(0, 126, moreView.width, 42);
        button3.titleLabel.font = [UIFont systemFontOfSize:16];
        [button3 addTarget:self action:@selector(pullBackAction:) forControlEvents:UIControlEventTouchUpInside];
        [button3 setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button3 setTitle:@"拉黑" forState:UIControlStateNormal];
        [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [moreView addSubview:button3];
        
        
        UIButton * button4 = [UIButton buttonWithType:UIButtonTypeCustom];
        button4.frame = CGRectMake(0, 168, moreView.width, 42);
        button4.titleLabel.font = [UIFont systemFontOfSize:16];
        [button4 addTarget:self action:@selector(reportAction:) forControlEvents:UIControlEventTouchUpInside];
        [button4 setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button4 setTitle:@"举报" forState:UIControlStateNormal];
        [button4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [moreView addSubview:button4];
        
        
        [moreView setHidden:YES];
        
    }else if (self.relation_status == 5) {
        
        moreView.height = 42 * 2;
        
        UIButton * button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        button3.frame = CGRectMake(0, 0, moreView.width, 42);
        button3.titleLabel.font = [UIFont systemFontOfSize:16];
        [button3 addTarget:self action:@selector(removeFromBlack:) forControlEvents:UIControlEventTouchUpInside];
        [button3 setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button3 setTitle:@"移除黑名单" forState:UIControlStateNormal];
        [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [moreView addSubview:button3];
        
        
        UIButton * button4 = [UIButton buttonWithType:UIButtonTypeCustom];
        button4.frame = CGRectMake(0, 42, moreView.width, 42);
        button4.titleLabel.font = [UIFont systemFontOfSize:16];
        [button4 addTarget:self action:@selector(reportAction:) forControlEvents:UIControlEventTouchUpInside];
        [button4 setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button4 setTitle:@"举报" forState:UIControlStateNormal];
        [button4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [moreView addSubview:button4];
        
        
        [moreView setHidden:YES];
        
    }else if (self.relation_status == 6) {
        
        moreView.height = 42 * 2;
        
        UIButton * button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        button3.frame = CGRectMake(0, 0, moreView.width, 42);
        button3.titleLabel.font = [UIFont systemFontOfSize:16];
        [button3 addTarget:self action:@selector(pullBackAction:) forControlEvents:UIControlEventTouchUpInside];
        [button3 setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button3 setTitle:@"拉黑" forState:UIControlStateNormal];
        [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [moreView addSubview:button3];
        
        
        UIButton * button4 = [UIButton buttonWithType:UIButtonTypeCustom];
        button4.frame = CGRectMake(0, 42, moreView.width, 42);
        button4.titleLabel.font = [UIFont systemFontOfSize:16];
        [button4 addTarget:self action:@selector(reportAction:) forControlEvents:UIControlEventTouchUpInside];
        [button4 setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button4 setTitle:@"举报" forState:UIControlStateNormal];
        [button4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [moreView addSubview:button4];
        
    }else if(self.relation_status == 31) {
        
        moreView.height = 42 * 4;
        
        UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(0, 0, moreView.width, 42);
        button1.titleLabel.font = [UIFont systemFontOfSize:16];
        [button1 addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        [button1 setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button1 setTitle:@"关注" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [moreView addSubview:button1];
        
        UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame = CGRectMake(0, 42, moreView.width, 42);
        button2.titleLabel.font = [UIFont systemFontOfSize:16];
        [button2 addTarget:self action:@selector(removeFans:) forControlEvents:UIControlEventTouchUpInside];
        [button2 setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button2 setTitle:@"移除粉丝" forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [moreView addSubview:button2];
        
        
        UIButton * button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        button3.frame = CGRectMake(0, 84, moreView.width, 42);
        button3.titleLabel.font = [UIFont systemFontOfSize:16];
        [button3 addTarget:self action:@selector(pullBackAction:) forControlEvents:UIControlEventTouchUpInside];
        [button3 setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button3 setTitle:@"拉黑" forState:UIControlStateNormal];
        [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [moreView addSubview:button3];
        
        
        UIButton * button4 = [UIButton buttonWithType:UIButtonTypeCustom];
        button4.frame = CGRectMake(0, 126, moreView.width, 42);
        button4.titleLabel.font = [UIFont systemFontOfSize:16];
        [button4 addTarget:self action:@selector(reportAction:) forControlEvents:UIControlEventTouchUpInside];
        [button4 setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button4 setTitle:@"举报" forState:UIControlStateNormal];
        [button4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [moreView addSubview:button4];
    }
    
     [moreView setHidden:YES];
    
    if(self.relation_status == 6) {
        
        [self.mailButton setHidden:YES];
        
        [self changeConstraints];
    
    }else {
        
        [self.mailButton setHidden:NO];
        
    }
}

#pragma mark - InfoCellDelegate

- (void)infoCell:(InfoCell *)infoCell didChangeValue:(NSString *)value {
    
    NSString * key =  _valArray[infoCell.hintField.tag - 1000];
    
    [_editDic setObject:value forKey:key];
    
}

#pragma mark - WTURLImageViewDelegate

- (void) URLImageViewDidClicked : (WTURLImageView*)imageView {
    
    if (self.isMySelf) {
        
         [self openSelectSingleImageAction];
 
    }else {
        
        [self showImage];
    }

}

#pragma mark - PostDateVieDelegat

-(void) postDateViewDidSelectTitle {
    
    if (!addreSelectView) {
        
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AddrSelectView" owner:nil options:nil];
        addreSelectView  = [nibView objectAtIndex:0];
        addreSelectView.delegate = self;
        
        addreSelectView.frame = CGRectMake(0,K_UIMAINSCREEN_HEIGHT , K_UIMAINSCREEN_WIDTH, addreSelectView.height);
        [self.view addSubview:addreSelectView];
        
    }
    
    addreSelectView.type = 4;
    
    [addreSelectView initAddrSelectViewWithData:self.allTitles level:0];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        if (addreSelectView.top == K_UIMAINSCREEN_HEIGHT) {
            
            addreSelectView.top = K_UIMAINSCREEN_HEIGHT - addreSelectView.height;
            
        }else {
            

            
            addreSelectView.top = K_UIMAINSCREEN_HEIGHT;
        }
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)postDateViewDidSelectTime:(PostDateView *)postDateView {
    
    [self.view endEditing:YES];
    
        if (!_selectDayView) {
            
            _selectDayView = [[UIView alloc] initWithFrame:CGRectMake(0, K_UIMAINSCREEN_HEIGHT + 30, K_UIMAINSCREEN_WIDTH, 186 + 30)];
            _selectDayView.backgroundColor= [UIColor colorWithWhite:0.922 alpha:1.000];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"facesBack"]];//[UIColor yellowColor];
            _birthDatePicker = [[UIDatePicker alloc] init];
            _birthDatePicker.frame = CGRectMake(0, 30, K_UIMAINSCREEN_WIDTH, 186);
            _birthDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
            
            _birthDatePicker.minimumDate = [NSDate date];
                // 完成按钮
                //    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
                // toolbar.barStyle = UIBarStyleBlackTranslucent;
                
            UIView * toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, 30)];
                
            toolbar.backgroundColor = [UIColor whiteColor];
                
                
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 60, 30);
            [button setTitle:@"取消" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(cancelPress) forControlEvents:UIControlEventTouchUpInside];
                [button setTitleColor:[UIColor colorWithRed:0.043 green:0.368 blue:0.792 alpha:1.000] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:18];
            [toolbar addSubview:button];
                
                
            UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
            button1.frame = CGRectMake(K_UIMAINSCREEN_WIDTH - 60, 0, 60, 30);
            [button1 setTitle:@"完成" forState:UIControlStateNormal];
            button1.titleLabel.font = [UIFont systemFontOfSize:18];
            [button1 addTarget:self action:@selector(donePress) forControlEvents:UIControlEventTouchUpInside];
            [button1 setTitleColor:[UIColor colorWithRed:0.043 green:0.368 blue:0.792 alpha:1.000] forState:UIControlStateNormal];
            [toolbar addSubview:button1];
                
            [_selectDayView addSubview:toolbar];
                
            [_selectDayView addSubview:_birthDatePicker];
        
                //  [self.view addSubview:_selectDayView];
            [self.view addSubview:_selectDayView];
        }
            
            NSDate *maxDate = [NSDate date];
            
            _birthDatePicker.minimumDate = maxDate;
            
            _birthDatePicker.date = maxDate;
            
            if (!datePickerSwitch) {
                // 弹出动画
                datePickerSwitch = !datePickerSwitch;
                
                CGRect rect = _selectDayView.frame;
                rect.origin.y = K_UIMAINSCREEN_HEIGHT - 216;
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    _selectDayView.frame = rect;
                }];
                
            }else {
                
                [self dismissDatePicker];
            }
}
- (void)donePress {
    /////设置值
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *date = [formatter stringFromDate:[_birthDatePicker date]];
    
    self.dateTime = date;
    
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString * cdate = [formatter stringFromDate:[_birthDatePicker date]];
    
    [_postDateView.inviteTimeButton setTitle:cdate forState:UIControlStateNormal];
    
    [_postDateView.inviteTimeButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    [self dismissDatePicker];
}

- (void)cancelPress {
    
    [self dismissDatePicker];
}

-(void) dismissDatePicker {
    
    datePickerSwitch = !datePickerSwitch;
    
    CGRect rect = _selectDayView.frame;
    
    rect.origin.y = K_UIMAINSCREEN_HEIGHT;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _selectDayView.frame = rect;
    }];
}

/////////

- (void)postDateViewDidSelectAddress:(PostDateView *)postDateView {
    
    NeborCoffeeVenuesViewController * neboroffeeVC = [self getStoryBoardControllerWithControllerID:@"NeborCoffeeVenuesViewController"];
    neboroffeeVC.type = 0;
    
    neboroffeeVC.delegate = self;
    
    [self.navigationController pushViewController:neboroffeeVC animated:YES];

}

- (void)postDateViewDidSelectDidPost:(NSMutableDictionary *)dic {
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    if (!memberID) {
        
        [self gotoLogin];
        
        return;
    }
    
    NSString * title = _postDateView.inviteTitle.text;
    
    if ([AppUtil isNull:title]) {
        
        [AppUtil HUDWithStr:@"标题不能为空" View:self.view];
        
        return;
    }
    
    if ([AppUtil isNull:self.dateTime]) {
        
        [AppUtil HUDWithStr:@"请选择约会时间" View:self.view ];
        
        return;
    }
    

    if ([AppUtil isNull:self.selectedVenues]) {
        
        [AppUtil HUDWithStr:@"请选择约会地址" View:self.view];
        
        return;
    }
    
    NSString * tel = _postDateView.telField.text;
    
    if ([AppUtil isNull:tel]) {
        
        [AppUtil HUDWithStr:@"号码不能为空" View:self.view];
        
        return;
    }
    
    NSString * vid = [self.selectedVenues valueForKey:@"id"];

      //////发布
    NSMutableDictionary *  parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"invitation",@"c",@"sendInvitation",@"act",self.otherID,@"touserid", memberID,@"userid",title,@"title",self.dateTime,@"datetime",vid,@"shopid",tel,@"tel",nil];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [AppUtil showHudInView:self.view tag:10000];
    
    [manager POST:hostUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [AppUtil hideHudInView:self.view mtag:10000];
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
         
            [AppUtil HUDWithStr:@"发送成功" View:self.view];
            
            self.dateTime = nil;
            self.selectedVenues = nil;
            
            [self performSelector:@selector(tapAction) withObject:nil afterDelay:1.5];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [AppUtil hideHudInView:self.view mtag:10000];
        NSLog(@"Error: %@", error);
    }];
}


#pragma mark - NeborCoffeeSelectedDelegate

- (void)venuesDidSelectedSuccess:(NSDictionary *)venues {
    
    NSLog(@"%@",venues);
    
    self.selectedVenues = [NSDictionary dictionaryWithDictionary:venues];
    
    [self.postDateView.inviteAddressButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    [self.postDateView.inviteAddressButton setTitle:[venues valueForKey:@"address"] forState:UIControlStateNormal];
    
}

#pragma mark - HeaderCellDelegate

//0 相册  1. 约会
- (void)headerCell:(HeaderCell *)headerCell didClickAction:(int)index {
    
    if (index == 0) {
        
        [self showImage];
    
    }else {
        
        NSMutableDictionary *  parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"base",@"c",@"getInvitationTitle",@"act",self.otherID,@"userid", nil];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
        [AppUtil showHudInView:self.view tag:10000];
            
        [manager POST:hostUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
            [AppUtil hideHudInView:self.view mtag:10000];
                
            Response * response = [self parseJSONValueWithJSONString:responseObject];
                
            if (response.err == 1) {
            
            ///////////////////////////////////
                if (!self.postDateView) {
                    
                    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PostDateView" owner:nil options:nil];
                    _postDateView  = [nibView objectAtIndex:0];
                    _postDateView.frame = CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, K_UIMAINSCREEN_HEIGHT);
                    _postDateView.delegate = self;
                    _postDateView.userInteractionEnabled = YES;
                    [self.view addSubview:_postDateView];
                    [_postDateView setHidden:YES];
                    
                    
                    [_postDateView.rejectButton setHidden:YES];
                    [_postDateView.acctptButton setHidden:YES];
                    [_postDateView.inviteState setHidden:YES];
                
                /*
                    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
                    [topView setBarStyle:UIBarStyleBlack];
                    
                    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
                    
                    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
                    [button setTitle:@"收起键盘" forState:UIControlStateNormal];
                    button.frame = CGRectMake(0, 0, 80, 30);
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];

                    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithCustomView:button];
                    
                    
                    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
                    [topView setItems:buttonsArray];
                    [_postDateView.telField setInputAccessoryView:topView];*/
                    
                    NSString * phone =   [[[NSUserDefaults standardUserDefaults]userInfo]valueForKey:@"phone"];
                    _postDateView.telField.text = phone;
                    
                    _postDateView.telField.userInteractionEnabled = NO;
            
                    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
                    tapGesture.numberOfTapsRequired = 1;
                    [_postDateView addGestureRecognizer:tapGesture];
                }
                
                //////获取所有表忒
                self.allTitles = [responseObject valueForKey:@"result"];
                
                ///////////
                _postDateView.inviteTitle.text = [[responseObject valueForKey:@"result"][0] valueForKey:@"name"];
                
                NSString * nickName = nil;
                
                if ([AppUtil isNotNull:[self.userinfoDic valueForKey:@"nick_name"]]) {
                    
                    nickName = [self.userinfoDic valueForKey:@"nick_name"];
                    
                }else {
    
                    nickName = [self.userinfoDic valueForKey:@"user_name"];
                }
                
                _postDateView.inviteNickNameLabel.text = nickName;///受邀请人
                

                _postDateView.inviteNickName.text = nickName;
             
               //[_postDateView.inviteTimeButton setTitle:@"" forState:UIControlStateNormal];
                
               // [_postDateView.inviteAddressButton setTitle:@"" forState:UIControlStateNormal];
                
                ////////////选择时间////////////
                [_postDateView.inviteTimeButton setTitleColor:[UIColor colorWithWhite:0.759 alpha:1.000] forState:UIControlStateNormal];
                [_postDateView.inviteTimeButton setTitle:@"点这里输入/选择" forState:UIControlStateNormal];
                
                ///////////选择地址////////
                [_postDateView.inviteAddressButton setTitleColor:[UIColor colorWithWhite:0.759 alpha:1.000] forState:UIControlStateNormal];
                [_postDateView.inviteAddressButton setTitle:@"点这里输入/选择" forState:UIControlStateNormal];


              //  _postDateView.telField.keyboardType = UIKeyboardTypeNumberPad;
                
                NSString * avatarStr = [self.userinfoDic valueForKey:@"head_photo"];
                [self.postDateView.inviteAvatar setConers];
                [self.postDateView.inviteAvatar setURL:avatarStr defaultImage:nil type:1];
                
                NSDictionary * myUserinfo = [[NSUserDefaults standardUserDefaults] userInfo];
                
                NSLog(@"%@",myUserinfo);
                
                NSString * myName = nil;
                
                if ([AppUtil isNotNull:[myUserinfo valueForKey:@"nick_name"]]) {
                    
                    myName = [myUserinfo valueForKey:@"nick_name"];
                
                }else {
                    
                    myName = [myUserinfo valueForKey:@"user_name"];
                }
                  _postDateView.telField.text = [myUserinfo valueForKey:@"mobile"];
                
                self.postDateView.beInviteNickName.text = myName;
                
                NSString* myAvatarString = [myUserinfo valueForKey:@"head_photo"];
                
                [self.postDateView.beInviteAvatar setURL:myAvatarString defaultImage:nil type:1];
                [self.postDateView.beInviteAvatar setConers];
                
            
                 _postDateView.alpha = 0;
                [_postDateView setHidden:NO];
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    _postDateView.alpha = 1;
                    
                } completion:^(BOOL finished) {
                    
                }];
             ////////////////////////////////////////
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [AppUtil hideHudInView:self.view mtag:10000];
                NSLog(@"Error: %@", error);
        }];
  }
}



#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [_keyArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        HeaderCell * headerCell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
        
        headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [headerCell initSubViewWithIsMyself:self.isMySelf];
        
        headerCell.delegate = self;
        
        [headerCell.avatarView setConers];
        
        NSString * nickName = [self.userinfoDic valueForKey:@"nick_name_real"];
        //  NSString * address = [[NSUserDefaults standardUserDefaults] currentCityName];
        NSString * address = [self.userinfoDic valueForKey:@"address"];
        NSString * avatar = [self.userinfoDic valueForKey:@"head_photo"];
        
        if ([AppUtil isNotNull:nickName]) {
            
            headerCell.nickName.text = nickName;
            
        }else {
            
            headerCell.nickName.text = @"";
        }
        
        if ([AppUtil isNotNull:address]) {
            
            headerCell.addressLabel.text = address;
            
        }else {
            
            headerCell.addressLabel.text = @"";

        }
        
        [headerCell.addressLabel sizeToFit];
         headerCell.locateView.left = (K_UIMAINSCREEN_WIDTH -  (headerCell.locateView.width + headerCell.addressLabel.width))/2;
        
        headerCell.addressLabel.left = headerCell.locateView.right;
        
        
        self.avatarView = headerCell.avatarView;
        self.avatarBigView = headerCell.avatarBigView;
        
        self.avatarView.delegate = self;
        
        if ([AppUtil isNotNull:avatar]) {
            
            [headerCell.avatarView setURL:avatar defaultImage:nil type:1];
            
            [headerCell.avatarBigView setURLWithBlurry:avatar defaultImage:nil type:1];
            
        }else {
            
            [headerCell.avatarView setURL:nil defaultImage:@"chatListCellHead" type:1];

        }
        
        if (self.isMySelf) {
            
            [headerCell.takePhotoButton setHidden:NO];
            headerCell.avatarView.userInteractionEnabled = YES;
            headerCell.avatarView.delegate = self;
        
        }else {
            
              [headerCell.takePhotoButton setHidden:YES];
            headerCell.avatarView.userInteractionEnabled = YES;
            headerCell.avatarBigView.delegate = self;
        }
        
        return headerCell;
        
    }else if(indexPath.section == 1){
        
        UITableViewCell * headerCell = [tableView dequeueReusableCellWithIdentifier:@"SignatureCell"];
        
          headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel * label = (UILabel *)[headerCell viewWithTag:100];//
        label.text = _keyArray[indexPath.section];
        
        NSString * dateValue = [_editDic valueForKey:_valArray[indexPath.section]];
        
        if (!dateValue) {
            
            dateValue = [self.userinfoDic valueForKey:_valArray[indexPath.section]];
        }
        
        UITextView * textView = (UITextView *)[headerCell viewWithTag:103]; ///全名
        textView.textColor = [UIColor colorWithHexString:@"0xfb6c02"];
      //  textView.delegate = self;
        textView.text = dateValue;
        self.sigitureView = textView;

        //////////调整row 的高度
        UIView * view = [headerCell viewWithTag:104];
        CGFloat height =[self getSigitureHeight:indexPath];
        view.top = (height - view.height)/2;
        ////////
        
        
        textView.userInteractionEnabled = NO;//self.isEdit;
        
        if (self.isEdit) {
            
           // [UIView animateWithDuration:1.0 animations:^{
                
                textView.left = EDIT_LEFT;
                
           // }];
            
            [view setHidden:NO];
            
            //textView.layer.borderColor = [[UIColor colorWithWhite:0.906 alpha:1.000]CGColor];
            //textView.layer.borderWidth = 1.0;
            
        }else {
            
            //  textView.left = 110;
            
            [view setHidden:YES];
            
          //  textView.layer.borderColor = [[UIColor clearColor]CGColor];
           // textView.layer.borderWidth = 0;
        }
    
        [self.view setNeedsDisplay];
        
        return headerCell;

    }else if (indexPath.section == 2) {
       
        ////固定的
        UITableViewCell * headerCell = [tableView dequeueReusableCellWithIdentifier:@"GoDateCell"];
      
        headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel * label = (UILabel *)[headerCell viewWithTag:100];
        //label.text = _keyArray[indexPath.section];
        
        if(self.isMySelf) {
            
            label.text = @"我的活动";
            
        }else {
            
            label.text = @"Ta的活动";
        }
        
        //UILabel * labelBg = (UILabel *)[headerCell viewWithTag:101];
       // labelBg.layer.cornerRadius = labelBg.frame.size.width/2;
       // labelBg.layer.masksToBounds = YES;
        
      // self.numberLabel = labelBg;

        return headerCell;
        
    }else {//////////////////
        
        InfoCell * headerCell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
        headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        headerCell.delegate = self;
        
        UILabel * label = headerCell.hintLabel;//(UILabel *)[headerCell viewWithTag:100];
        label.text = _keyArray[indexPath.section];
        
        
        NSString * dateValue = [_editDic valueForKey:_valArray[indexPath.section]];
        
        if (!dateValue) {
            
            dateValue = [self.userinfoDic valueForKey:_valArray[indexPath.section]];
        }
        
        
        UITextField * textField = headerCell.hintField;//(UITextField *)[headerCell viewWithTag:101];
        textField.textColor = [UIColor colorWithHexString:@"0xfb6c02"];
         textField.text = dateValue;
         textField.delegate = self;
        
        textField.tag = indexPath.section + 1000;
        
        if(indexPath.section == 5){
         
            int sex = [dateValue intValue];
            
            if (sex == 1) {
                
                textField.text = @"男";
            
            }else if(sex == 2){
                
                textField.text = @"女";
           
            }else {
                
                textField.text = @"保密";
            }
            
            
            textField.userInteractionEnabled = NO;
          
            if (self.isEdit) {
                
              //  [UIView animateWithDuration:1.0 animations:^{
                    
                    textField.left = EDIT_LEFT;
                    
              //  }];
                
                [headerCell.rightIcon setHidden:NO];
              //  textField.layer.borderColor = [[UIColor colorWithWhite:0.906 alpha:1.000]CGColor];
              //  textField.layer.borderWidth = 1.0;
                
            }else {
                
               // [UIView animateWithDuration:1.0 animations:^{
                    
                   // textField.left = 110;
                    
             //   }];
                
                [headerCell.rightIcon setHidden:YES];
             //   textField.layer.borderColor = [[UIColor clearColor]CGColor];
              //  textField.layer.borderWidth = 0;
            }
            
        }else if (indexPath.section == 3) {
            
            NSString * acount = [self.userinfoDic valueForKey:_valArray[indexPath.section]];
            
            if ([AppUtil isNotNull:acount]) {
                
                textField.userInteractionEnabled = NO;
                
              //  [UIView animateWithDuration:1.0 animations:^{
                    
                  //  textField.left = 110;
                    
             //   }];
                
                [headerCell.rightIcon setHidden:YES];
              //  textField.layer.borderColor = [[UIColor clearColor]CGColor];
               // textField.layer.borderWidth = 0;
            
            }else {
                
                textField.userInteractionEnabled = NO;//self.isEdit;
                
                if (self.isEdit) {
                    
                //    [UIView animateWithDuration:1.0 animations:^{
                        
                        textField.left = EDIT_LEFT;
                        
                  //  }];
                    
                    [headerCell.rightIcon setHidden:NO];
                  //  textField.layer.borderColor = [[UIColor colorWithWhite:0.906 alpha:1.000]CGColor];
                   // textField.layer.borderWidth = 1.0;
                    
                }else {
                    
                  //  [UIView animateWithDuration:1.0 animations:^{
                        
                       // textField.left = 110;
                        
                  //  }];
                    
                    [headerCell.rightIcon setHidden:YES];
                   // textField.layer.borderColor = [[UIColor clearColor]CGColor];
                   // textField.layer.borderWidth = 0;
                }
            }
            
        }else if (indexPath.section == 8){
        
            textField.userInteractionEnabled = NO;
            
            if (self.isEdit) {
                
              //  [UIView animateWithDuration:1.0 animations:^{
                    
                    textField.left = EDIT_LEFT;
                    
               // }];
                
                [headerCell.rightIcon setHidden:NO];
              //  textField.layer.borderColor = [[UIColor colorWithWhite:0.906 alpha:1.000]CGColor];
                //textField.layer.borderWidth = 1.0;
                
            }else {
                
              //  [UIView animateWithDuration:1.0 animations:^{
                    
                  //  textField.left = 110;
                    
              //  }];
              //
                [headerCell.rightIcon setHidden:YES];
               // textField.layer.borderColor = [[UIColor clearColor]CGColor];
              // textField.layer.borderWidth = 0;
            }
            
        } else {
            
            textField.userInteractionEnabled = NO;//self.isEdit;
            
            if (self.isEdit) {
            
              //  [UIView animateWithDuration:1.0 animations:^{
                    
                    textField.left = EDIT_LEFT;
                    
              //  }];
                
                [headerCell.rightIcon setHidden:NO];
                //textField.layer.borderColor = [[UIColor colorWithWhite:0.906 alpha:1.000]CGColor];
               // textField.layer.borderWidth = 1.0;
                
            }else {
                
               // [UIView animateWithDuration:1.0 animations:^{
                    
                  //  textField.left = 110;
                    
               // }];
                
                [headerCell.rightIcon setHidden:YES];
              //  textField.layer.borderColor = [[UIColor clearColor]CGColor];
               // textField.layer.borderWidth = 0;
            }
        }
    
       // [self.view setNeedsDisplay];
        
        return headerCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 310;
    
    }else if (indexPath.section == 1){
     
        return [self getSigitureHeight:indexPath];
        
    }else {
        
        return 35;
    }
    
}

- (CGFloat)getSigitureHeight:(NSIndexPath *)indexPath {
    
    NSString * content = [self.userinfoDic valueForKey:_valArray[indexPath.section - 1]];
    float height = [UserCenterVC heightForTextView:nil WithText:content];
    
    if (height <= 35) {
        
        return 62;
        
    }else {
        
        return 27 + height;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 0;
    
    }else {
        
        return 15;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return;
    }
    
   if (indexPath.section == 2) {
        
        if (self.isMySelf ) {
            
            InviteViewController * inviteVC = [self getStoryBoardControllerWithControllerID:@"InviteViewController" storyBoardName:@"Other"];
            
            inviteVC.isOther = NO;
         
            [self.navigationController pushViewController:inviteVC animated:NO];

            
        }else {//
            
            InviteViewController * inviteVC = [self getStoryBoardControllerWithControllerID:@"InviteViewController" storyBoardName:@"Other"];
            
            inviteVC.isOther = YES;
            
            NSString * nickName = [self.userinfoDic valueForKey:@"nick_name"];
            
            NSString * userID = [self.userinfoDic valueForKey:@"id"];
            
            inviteVC.titleString = [NSString stringWithFormat:@"%@的活动",nickName];
            
            inviteVC.userID = userID;
            
            [self.navigationController pushViewController:inviteVC animated:NO];
            
        }
        
    }else if(indexPath.section == 5) {
        
        if (self.isEdit) {
         
            UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",@"保密", nil];
            
             actionSheet.tag = 1003;
            
            [actionSheet showInView:self.view];

        }
    }else if (indexPath.section == 9) {
        
        if (self.isMySelf && self.isEdit) {

            /////////去选择城市
            NSArray * allArea = [AppUtil readDataWithPlistName:@"all_area.plist" cat:[NSArray array]];
            
            if (!addreSelectView) {
                
                NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AddrSelectView" owner:nil options:nil];
                addreSelectView  = [nibView objectAtIndex:0];
                addreSelectView.delegate = self;
                
                addreSelectView.frame = CGRectMake(0,K_UIMAINSCREEN_HEIGHT , K_UIMAINSCREEN_WIDTH, addreSelectView.height);
                [self.view addSubview:addreSelectView];
                
            }
            addreSelectView.type = 2;
            addreSelectView.level = 3;
            addreSelectView.level1_key = @"city";
            addreSelectView.level2_key = @"town";
            
            [addreSelectView initAddrSelectViewWithData:allArea level:3];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                if (addreSelectView.top == K_UIMAINSCREEN_HEIGHT) {
                    
                    addreSelectView.top = K_UIMAINSCREEN_HEIGHT - addreSelectView.height;
                    
                }else {
                    
                    addreSelectView.top = K_UIMAINSCREEN_HEIGHT;
                }
                
            } completion:^(BOOL finished) {
                
            }];
    
        }
        
    }else if (indexPath.section == 7) {
        
        if (self.isMySelf && self.isEdit) {
        
            if (!addreSelectView) {
                
                NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AddrSelectView" owner:nil options:nil];
                addreSelectView  = [nibView objectAtIndex:0];
                addreSelectView.delegate = self;
                
                addreSelectView.frame = CGRectMake(0,K_UIMAINSCREEN_HEIGHT , K_UIMAINSCREEN_WIDTH, addreSelectView.height);
                [self.view addSubview:addreSelectView];
                
            }
            
            addreSelectView.type = 5;
            
            [addreSelectView initAddrSelectViewWithData:self.allXZArray level:0];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                if (addreSelectView.top == K_UIMAINSCREEN_HEIGHT) {
                    
                    addreSelectView.top = K_UIMAINSCREEN_HEIGHT - addreSelectView.height;
                    
                }else {
                    
                    addreSelectView.top = K_UIMAINSCREEN_HEIGHT;
                }
                
            } completion:^(BOOL finished) {
                
            }];

        }
        
        
    }else if (indexPath.section == 6){
        
        if (self.isMySelf && self.isEdit) {
            
            if (!addreSelectView) {
                
                NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AddrSelectView" owner:nil options:nil];
                addreSelectView  = [nibView objectAtIndex:0];
                addreSelectView.delegate = self;
                
                addreSelectView.frame = CGRectMake(0,K_UIMAINSCREEN_HEIGHT , K_UIMAINSCREEN_WIDTH, addreSelectView.height);
                [self.view addSubview:addreSelectView];
                
            }
            
            addreSelectView.type = 6;
            
            [addreSelectView initAddrSelectViewWithData:nil level:0];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                if (addreSelectView.top == K_UIMAINSCREEN_HEIGHT) {
                    
                    addreSelectView.top = K_UIMAINSCREEN_HEIGHT - addreSelectView.height;
                    
                }else {
                    
                    addreSelectView.top = K_UIMAINSCREEN_HEIGHT;
                }
                
            } completion:^(BOOL finished) {
                
            }];
            
        }
    
    }else {
        
        if (self.isMySelf && self.isEdit) {
            
            if (indexPath.section == 3) { ////咖啡号只能修改一次
                
                NSString * acount = [self.userinfoDic valueForKey:_valArray[indexPath.section]];
                
                if ([AppUtil isNotNull:acount]) {
                    
                    return;
                    
                }
            }
            
            ModifyInfoVC * modifyInfoVC =[self getStoryBoardControllerWithControllerID:@"ModifyInfoVC" storyBoardName:@"Other"];
            
            modifyInfoVC.index = indexPath.section;
            
            modifyInfoVC.keyName = self.keyArray[indexPath.section];
            
            modifyInfoVC.keyValue = self.valArray[indexPath.section];
            
            modifyInfoVC.delegate = self;
            
            [self.navigationController pushViewController:modifyInfoVC animated:YES];
            
        }
    }
}

#pragma mark - ModifyVCDelegate

- (void)modifyInfoVC:(ModifyInfoVC *)modifyInfoVC didModifySuccessWithTitle:(NSString *)title {
    
    if([modifyInfoVC.keyValue isEqualToString:@"report"]){
        
        NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        [dic setValue:@"report" forKey:@"act"];
        [dic setObject:@"contact" forKey:@"c"];
        [dic setObject:self.otherID forKey:@"userid"];
        [dic setObject:memberID forKey:@"loginid"];
        [dic setObject:title forKey:@"content"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:hostUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            if (response.err == 1) {
                
                [AppUtil HUDWithStr:@"举报成功" View:self.view];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
    }else if([modifyInfoVC.keyValue isEqualToString:@"beizhu"]) {
        
        NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        [dic setValue:@"relationName" forKey:@"act"];
        [dic setObject:@"contact" forKey:@"c"];
        [dic setObject:self.otherID forKey:@"userid"];
        [dic setObject:memberID forKey:@"loginid"];
        [dic setObject:title forKey:@"name"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:hostUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            if (response.err == 1) {
                
                [AppUtil HUDWithStr:@"已备注成功" View:self.view];
                
                [self updateTitle:title];
                
                 [[NSNotificationCenter defaultCenter] postNotificationName:K_UPDATE_CONTACTS object:nil];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];


    }else {
        
        [self.editDic setValue:title forKey:modifyInfoVC.keyValue];
        
        if ([modifyInfoVC.keyValue isEqualToString:@"signature"]) {
            
            self.sigitureView.text = title;
            
        }else {
            
            UITextField * field = (UITextField *)[self.view viewWithTag:1000 + modifyInfoVC.index];
            field.text = title;
            
        }

    }
}

#pragma mark - 

+ (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
   
    float fPadding = 16.0; // 8.0px x 2
   
    CGSize constraint = CGSizeMake(205 - fPadding, CGFLOAT_MAX);
    
    CGSize size = [strText sizeWithFont: textView.font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    float fHeight = size.height + 16.0;
    
    return fHeight;
}

#pragma mark - AddrSelectViewDelegate

- (void)addrSelectDidSelectTitle:(NSString *)title {
    
    if (addreSelectView.type == 4) {
        
          _postDateView.inviteTitle.text = title;
    
    }else if(addreSelectView.type == 5) {
        
        [_editDic setValue:title forKey:@"constellation"];
        
        UITextField * textField = (UITextField *)[self.view viewWithTag:1007];
        textField.text = title;
        
    }else if (addreSelectView.type == 6){
        
        [_editDic setValue:title forKey:@"age"];
        
        UITextField * textField = (UITextField *)[self.view viewWithTag:1006];
        textField.text = title;
    }
}

- (void)addrSelectDidSelectProvinceID:(NSString *)provinceID cityID:(NSString *)cityID townID:(NSString *)townID circleID:(NSString *)circleID addrString:(NSString *)addrString {
    
    UITextField * textField = (UITextField *)[self.view viewWithTag:1009];
    
    textField.text = addrString;
    
    [_editDic setObject:addrString forKey:@"home"];
    [_editDic setObject:townID forKey:@"home_town_id"];
    [_editDic setObject:cityID forKey:@"home_city_id"];
    [_editDic setObject:provinceID forKey:@"home_province_id"];
    
}

#pragma mark - Actions

- (void)dismissKeyBoard {
    
    [self.view endEditing:YES];
}

- (void)tapAction {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.postDateView.alpha = 0;
        
    } completion:^(BOOL finished) {
       
        [self.postDateView setHidden:YES];
        
    }];

}

- (void)editAction {
    
    if(self.isEdit) {//修改状态
        
        [_sigitureView resignFirstResponder];
        
        [self updateMemberInfomation];
        
    }else {//不可修改状态
        
        self.isEdit = !self.isEdit;
        
        [myRightButton setTitle:@"完成" forState:UIControlStateNormal];
        
        if (!_editDic) {
            _editDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        }
        [_editDic removeAllObjects];
        
        [self.tableView reloadData];

    }
}

- (void)backAction {
    
    if (self.isRoot) {
    
        [self.slideMenuController closeMenuBehindRootViewController:self.slideMenuController.rootViewController animated:YES completion:^(BOOL finished) {}];
        
    }else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)mailAction:(id)sender {
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults]currentMemberID];
    
    if (!memberID) {
        
        [self gotoLogin];
        
        return;
    }
    
    NSString * mobilePhone = [self.userinfoDic valueForKey:@"mobile"];
    
    ChatViewController * chatViewVC = [[ChatViewController alloc] initWithChatter:mobilePhone isGroup:NO];
    
    chatViewVC.userID = self.otherID;
    chatViewVC.nickName = [self.userinfoDic valueForKey:@"nick_name"];
    chatViewVC.avatar = [self.userinfoDic valueForKey:@"head_photo"];
    
    [self.navigationController pushViewController:chatViewVC animated:YES];
    
}

- (void)reportAction:(id)sender {
    
     [moreView setHidden:YES];
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    if ([AppUtil isNull:memberID]) {
        
        [self gotoLogin];
        
        return;
    }
    
    ModifyInfoVC * modifyInfoVC =[self getStoryBoardControllerWithControllerID:@"ModifyInfoVC" storyBoardName:@"Other"];
    
     modifyInfoVC.keyName = @"举报";
    
    modifyInfoVC.keyValue = @"report";
    

    modifyInfoVC.delegate = self;
    
    [self.navigationController pushViewController:modifyInfoVC animated:YES];
}

- (void)pullBackAction:(UIButton *)button {
    
     [moreView setHidden:YES];
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    if ([AppUtil isNull:memberID]) {
        
        [self gotoLogin];
        
        return;
    }
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [dic setValue:@"black" forKey:@"act"];
    [dic setObject:@"contact" forKey:@"c"];
    [dic setObject:self.otherID forKey:@"userid"];
    [dic setObject:memberID forKey:@"loginid"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:hostUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            self.relation_status = [[[responseObject valueForKey:@"result"] valueForKey:@"relation_status"] intValue];
            
            [self updateMoreView];
            
            [AppUtil HUDWithStr:@"拉黑成功" View:self.view];
            
             [[NSNotificationCenter defaultCenter] postNotificationName:K_UPDATE_CONTACTS object:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)beizhu:(UIButton *)button {
    
     [moreView setHidden:YES];
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    if ([AppUtil isNull:memberID]) {
        
        [self gotoLogin];
        
        return;
    }
    
    ModifyInfoVC * modifyInfoVC =[self getStoryBoardControllerWithControllerID:@"ModifyInfoVC" storyBoardName:@"Other"];
    
    modifyInfoVC.keyName = @"备注";
    
    modifyInfoVC.keyValue = @"beizhu";
    
    modifyInfoVC.delegate = self;
    
    if ([AppUtil isNotNull:[self.editDic valueForKey:@"beizu"]]) {
        
        modifyInfoVC.beizhuTitle = [self.editDic valueForKey:@"beizhu"];
        
    }else {
        
        modifyInfoVC.beizhuTitle = [self.userinfoDic valueForKey:@"nick_name"];
        
    }
    
    [self.navigationController pushViewController:modifyInfoVC animated:YES];
    
}

- (void)removeFans:(UIButton *)button {
    
     [moreView setHidden:YES];
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    if ([AppUtil isNull:memberID]) {
        
        [self gotoLogin];
        
        return;
    }
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [dic setValue:@"removefan" forKey:@"act"];
    [dic setObject:@"contact" forKey:@"c"];
    [dic setObject:self.otherID forKey:@"userid"];
    [dic setObject:memberID forKey:@"loginid"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:hostUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            [AppUtil HUDWithStr:@"操作成功" View:self.view];
            
            self.relation_status = [[[responseObject valueForKey:@"result"] valueForKey:@"relation_status"] intValue];
            
            [self updateMoreView];
            
             [[NSNotificationCenter defaultCenter] postNotificationName:K_UPDATE_CONTACTS object:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 4000) {
        
        if (buttonIndex == 0) {//举报
            
            NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
            
            if ([AppUtil isNull:memberID]) {
                
                [self gotoLogin];
                
                return;
            }
            
            NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:0];
            
            [dic setValue:@"report" forKey:@"act"];
            [dic setObject:@"contact" forKey:@"c"];
            [dic setObject:self.otherID forKey:@"userid"];
            [dic setObject:memberID forKey:@"loginid"];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            [manager POST:hostUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                Response * response = [self parseJSONValueWithJSONString:responseObject];
                
                if (response.err == 1) {
                    
                    [AppUtil HUDWithStr:@"举报成功" View:self.view];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
            
        }else if (buttonIndex == 1) { //拉黑
            
            NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
            
            if ([AppUtil isNull:memberID]) {
                
                [self gotoLogin];
                
                return;
            }
            
            NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:0];
            
            [dic setValue:@"black" forKey:@"act"];
            [dic setObject:@"contact" forKey:@"c"];
            [dic setObject:self.otherID forKey:@"userid"];
            [dic setObject:memberID forKey:@"loginid"];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            [manager POST:hostUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                Response * response = [self parseJSONValueWithJSONString:responseObject];
                
                if (response.err == 1) {
                    
                    [AppUtil HUDWithStr:@"拉黑成功" View:self.view];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
        }
        
    }else if (actionSheet.tag == 2001) {
        
        if (buttonIndex == 2) {
            
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            
        }else if(buttonIndex == 0){
            
            [self selectSinglePhoto];
        }
        else if(buttonIndex==1){
            
            [self takePhotoWithCamera];
        }
  
    }else if(actionSheet.tag == 1003) {
        
        if (buttonIndex == 0) {
            
            UITextField * textField = (UITextField *)[self.view viewWithTag:1005];
            
            textField.text = @"男";
            
            [_editDic setObject:@"1" forKey:@"sex"];
            
        }else if (buttonIndex == 1) {
            
            UITextField * textField = (UITextField *)[self.view viewWithTag:1005];
            
            textField.text = @"女";
            
             [_editDic setObject:@"2" forKey:@"sex"];
      
        }else if(buttonIndex == 2) {
            
            UITextField * textField = (UITextField *)[self.view viewWithTag:1005];
            
            textField.text = @"保密";
            
            [_editDic setObject:@"3" forKey:@"sex"];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    if (_postDateView.telField == textField) {
        
        return YES;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
       
        self.tableView.top = - 216;
        
    }];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    if (_postDateView.telField == textField) {
        
        return YES;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
       
        self.tableView.top = 0;
        
    }];
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.tableView.top = - 216;
        
    }];
    
    return YES;
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
         [textView resignFirstResponder];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.tableView.top = 0;
            
        }];
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    [_editDic setObject:textView.text forKey:@"signature"];
    NSLog(@"%@",textView.text);
}

#pragma mark - 填充

-(void)fillInfomationWithData:(NSDictionary *)dic {

    self.userinfoDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    self.relation_status = [[dic valueForKey:@"relation_status"] intValue];
    
    if (moreView) {
        
        [self updateMoreView];
    }
    
    if (self.isMySelf) {
        
         [[NSUserDefaults standardUserDefaults]setUserInfo:self.userinfoDic];
    }

    [self.tableView reloadData];
}

#pragma mark - UIViewControllerTransitioningDelegate methods

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    WTURLImageView * wturlImageView = [[WTURLImageView alloc] init];
    wturlImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if ([presented isKindOfClass:TGRImageViewController.class]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:wturlImageView];
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if ([dismissed isKindOfClass:TGRImageViewController.class]) {
        
          WTURLImageView * wturlImageView = [[WTURLImageView alloc] init];
          wturlImageView.contentMode = UIViewContentModeScaleAspectFill;
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:wturlImageView];
    }
    return nil;
}

#pragma mark - Private methods

- (void)showImage {
    
    NSArray * user_photos = [self.userinfoDic valueForKey:@"user_photos"];
   
    NSMutableArray * userphotos = [[NSMutableArray alloc] initWithArray:user_photos];
    
    NSMutableArray * user_photosArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary * dic in user_photos) {
        
        NSString * path = [dic valueForKey:@"path"];
        
        [user_photosArray addObject:path];
        
    }
    
    if (self.isMySelf) {
        
        if ([user_photos count] > 0) {
            
            TGRImageViewController *viewController = [[TGRImageViewController alloc] initWithImageURLs:user_photosArray];
         
            viewController.userCenterVC = self;
            
            viewController.isMySelf = self.isMySelf;
            
            viewController.photoDetailInfo = userphotos;
            
            viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:viewController];
            
            [self presentViewController:nav animated:YES completion:nil];
            
        }else {
        
            PhotoLibraryVC * photoLibrary =  [self getStoryBoardControllerWithControllerID:@"PhotoLibraryVC" storyBoardName:@"Other"];
            
            photoLibrary.photoDetailInfo = [NSMutableArray new];
            
            photoLibrary.photos = [NSMutableArray new];
            
            [self.navigationController pushViewController:photoLibrary animated:YES];

        }

    }else {
        
        if ([user_photos count] > 0) {
            
            TGRImageViewController *viewController = [[TGRImageViewController alloc] initWithImageURLs:user_photosArray];
          
            viewController.isMySelf = self.isMySelf;
            viewController.photoDetailInfo = userphotos;
            viewController.userName = [self.userinfoDic valueForKey:@"nick_name"];
                viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            // viewController.transitioningDelegate = self;
            
            [self presentViewController:viewController animated:YES completion:nil];
            
        }else {
           
             [AppUtil HUDWithStr:@"暂无相册" View:self.view];
        }
    }
    
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.tableView.top = 0;
        
    }];
    
    [self.view endEditing:YES];
}

#pragma mark - Private Method

- (void)selectImageSuccess:(UIImage *)image {////选择成功
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    if ([AppUtil isNull:memberID]) {
        
        [self gotoLogin];
        
        return;
    }
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [dic setValue:@"uploadHeadImg" forKey:@"act"];
    [dic setObject:@"user" forKey:@"c"];
    [dic setObject:memberID forKey:@"userid"];

    [self requestUploadAvatar:image params:dic];
}

- (void)uploadImageSuccess:(NSDictionary *)dictionary {
    
    Response * response = [self parseJSONValueWithJSONString:dictionary];
    
    if (response.err == 1) {
        
        NSString * headPhoto = [[dictionary valueForKey:@"result"] valueForKey:@"path"];
        
        [AppUtil HUDWithStr:@"上传头像成功" View:self.view];
    
        [self.userinfoDic setObject:headPhoto forKey:@"head_photo"];
        
        [self.avatarView setURL:headPhoto defaultImage:nil type:1];
        
        [self.avatarBigView setURLWithBlurry:headPhoto defaultImage:nil type:1];
    }
}

- (void)updateNumber:(NSInteger)number {
    
    if (number == 0) {
        
        [self.numberLabel setHidden:YES];
        
    }else {
        
        [self.numberLabel setHidden:NO];
        
        self.numberLabel.text = [NSString stringWithFormat:@"%d",number];
    }
}

#pragma mark - 关注

- (void)focusWithUserId:(NSString *)userID {
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    if ([AppUtil isNull:memberID]) {
        
        [self gotoLogin];
        
        return;
    }
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [dic setValue:@"follow" forKey:@"act"];
    [dic setObject:@"contact" forKey:@"c"];
    [dic setObject:userID forKey:@"userid"];
    [dic setObject:memberID forKey:@"loginid"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:hostUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            [AppUtil HUDWithStr:@"关注成功" View:self.view];
            
            self.relation_status = [[[responseObject valueForKey:@"result"] valueForKey:@"relation_status"] intValue];
            
            [self updateMoreView];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:K_UPDATE_CONTACTS object:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (void)updateMemberInfomation {
    
    ////约我名称 为空
    if ([AppUtil isNull:[self.userinfoDic valueForKey:@"user_name"]]) {
        
        NSString * user_name = [self.editDic valueForKey:@"user_name"];
        
        if ([AppUtil isNull:user_name]) {
            
            [AppUtil HUDWithStr:@"请输入约我账号" View:self.view];
      
            return;
      
        }else {
        
            if (![AppUtil isValidateUserName:user_name]) {
                
                [AppUtil HUDWithStr:@"约我账号必须由六位及六位以上的字母或数组组成" View:self.view];
                
                return;
            }
        }
    }
    
    ////约我名称 为空
    if ([AppUtil isNull:[self.userinfoDic valueForKey:@"nick_name"]]) {
        
        NSString * user_name = [self.editDic valueForKey:@"nick_name"];
        
        if ([AppUtil isNull:user_name]) {
            
            [AppUtil HUDWithStr:@"请输入昵称" View:self.view];
            
            return;
            
        }
    }
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    [self.editDic setValue:@"infoEdit" forKey:@"act"];
    [self.editDic setObject:@"user" forKey:@"c"];
    [self.editDic setObject:memberID forKey:@"userid"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [AppUtil showHudInView:self.view withFrame:CGRectMake(0, 64, K_UIMAINSCREEN_WIDTH, K_UIMAINSCREEN_HEIGHT - 64) tag:20001];
    
    [manager POST:hostUrl parameters:self.editDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [AppUtil hideHudInView:self.view mtag:20001];
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            [AppUtil HUDWithStr:@"资料保存成功" View:self.view];
            
            NSArray * user_photos = [self.userinfoDic valueForKey:@"user_photos"];
            
            self.userinfoDic = [[NSMutableDictionary alloc] initWithDictionary:response.result];
            
            [self.userinfoDic setValue:user_photos forKey:@"user_photos"];
            
            [[NSUserDefaults standardUserDefaults] setUserInfo:self.userinfoDic];
            
            [self.editDic removeAllObjects];
            
              self.isEdit = !self.isEdit;
            [myRightButton setTitle:@"编辑" forState:UIControlStateNormal];
            
            [self.tableView reloadData];
            
            if(self.isFromLogin) {
                
                [self performSelector:@selector(gotoFirstPage) withObject:nil afterDelay:1.0];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - 获取自己用户信息

- (void)updatePhotoLibrary:(id)noti {
    
    if ([noti isKindOfClass:[NSNotification class]]) {
        
        NSNotification * note = (NSNotification *)noti;
        
        NSArray * photoArray = [NSArray arrayWithArray:note.object];
        
        [self.userinfoDic setValue:photoArray forKey:@"user_photos"];
    
    }else if([noti isKindOfClass:[NSMutableArray class]]){
        
        [self.userinfoDic setValue:noti forKey:@"user_photos"];

    }
}

- (void)getMyUserInfo {
    
    NSMutableDictionary *parameters = nil;
    
    if (self.isMySelf) {
        
        NSNumber * memberID = [[NSUserDefaults standardUserDefaults]currentMemberID];
        parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"user",@"c",@"info",@"act",memberID,@"userid", nil];
        
    }else {
        
        NSNumber * memberID = [[NSUserDefaults standardUserDefaults]currentMemberID];
        
        parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"user",@"c",@"info",@"act",self.otherID,@"userid",memberID ,@"loginid",nil];
        
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [AppUtil showHudInView:self.view tag:10000];
    
    [manager POST:hostUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [AppUtil hideHudInView:self.view mtag:10000];
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            [self fillInfomationWithData:response.result];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [AppUtil hideHudInView:self.view mtag:10000];
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - util

- (void)gotoFirstPage {
    
    if(self.loginVC) { //刚登陆完成
        
        if (self.loginVC.isRoot) {
            
            [self.loginVC goBackAcion];
            
        }else if(self.loginVC.isPresent) {
            
            [self.loginVC goBackAcion];
            
        }else {
            
            NSArray * array = self.navigationController.viewControllers;
            
            NSMutableArray * newArray =[[NSMutableArray alloc] initWithArray:array];
            
            if ([newArray count] > 2) {
                
                [newArray removeLastObject];
                [newArray removeLastObject];
            }
            
            self.navigationController.viewControllers =  newArray;
        }
    
    }else {
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }
    
}

#pragma mark - Memory Manage

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    if (self.isMySelf) {
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:K_UPDATE_USER_INFO_NOTIFICATION object:nil];
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:k_PHOTO_LIBLARY_UPDATE object:nil];

    }else{
        
          [[NSNotificationCenter defaultCenter]removeObserver:self name:K_LOGIN_NOTIFICATION object:nil];
    }
}

@end
