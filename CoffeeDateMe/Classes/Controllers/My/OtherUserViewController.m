//
//  OtherUserViewController.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-10-1.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "OtherUserViewController.h"
#import "ChatViewController.h"
#import "OtherUserViewController.h"
#import "NeborCoffeeVenuesViewController.h"

@interface OtherUserViewController ()

@end

@implementation OtherUserViewController

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
    
    [self initBackButton];
    
    [self initTitleViewWithTitleString:self.nickName];
    
    [self initWithRightButtonWithImageName:nil title:@"他的活动" action:@selector(otherActivitys)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
      NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ButtomBarView" owner:nil options:nil];
     _buttomBarView = [nibView objectAtIndex:0];
    _buttomBarView.delegate = self;
    _buttomBarView.top = K_UIMAINSCREEN_HEIGHT -_buttomBarView.height;
    [self.navigationController.view addSubview:_buttomBarView];
    
    
    NSArray* nibView1 =  [[NSBundle mainBundle] loadNibNamed:@"OtherUserHeaderView" owner:nil options:nil];
    _otherUserHeaderView = [nibView1 objectAtIndex:0];
   // _buttomBarView.delegate = self;
  ///  _buttomBarView.top = K_UIMAINSCREEN_HEIGHT -_buttomBarView.height;
  //  [self.navigationController.view addSubview:_buttomBarView];
    
    [self getUserDetailInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserDetailInfo) name:K_LOGIN_NOTIFICATION object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [_buttomBarView setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [_buttomBarView setHidden:YES];
}

- (void)getUserDetailInfo {
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];

    NSMutableDictionary *parameters;
    
    if (!memberID) {
        
        parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"user",@"c",@"info",@"act",self.userID,@"user_id", nil];
   
    }else {
        
         parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"user",@"c",@"info",@"act",self.userID,@"user_id",memberID,@"myself_id", nil];
        
    }
    
    [AppUtil showHudInView:self.view tag:10001];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:hostUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [AppUtil hideHudInView:self.view mtag:10001];
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            NSLog(@"%@",response.result);
            
            [self fillInfomationWithDictionary:response.result];
        
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
          [AppUtil hideHudInView:self.view mtag:10001];
        NSLog(@"Error: %@", error);
    }];
}
 
#pragma mark - 填写用户信心

- (void)fillInfomationWithDictionary:(NSDictionary *)responseObject {
    
    self.userInfo = responseObject;


    if ([AppUtil isNull:[responseObject valueForKey:@"sex"]]) {
        
       // self.sexFlag.image = TTImage(@"nv");
        
        [self updateTitleWithTitle:@"她的活动"];
        
    }else {
        
        int  sex = [[responseObject valueForKey:@"sex"] intValue];
        
        if (sex == 1) {//男的图标
            
          //   self.sexFlag.image = TTImage(@"nan");
            
            [self updateTitleWithTitle:@"他的活动"];
            
        }else {
            
            // self.sexFlag.image = TTImage(@"nv");
            
            [self updateTitleWithTitle:@"她的活动"];
        }
    }
    
  /*  if ([AppUtil isNull:[responseObject valueForKey:@"address"]]) {
        
        self.addressLabel.text = @"";
    }else {
        
        NSString * cafeNum =  [responseObject valueForKey:@"address"];
        self.addressLabel.text = cafeNum;
    }

    
    
    if ([AppUtil isNull:[responseObject valueForKey:@"user_name"]]) {
        
        self.coffeeNumber.text = @"";
    }else {
        
        NSString * cafeNum =  [responseObject valueForKey:@"user_name"];
        self.coffeeNumber.text = cafeNum;
    }
    
    if ([AppUtil isNotNull:[responseObject valueForKey:@"distance"]]) {
        
        if ([[responseObject valueForKey:@"distance"] isEqualToString:@"无法定位距离 "]) {
            
            self.postTime.text = @"[无法定位距离]";
            
        }else {
            
             self.postTime.text = [NSString stringWithFormat:@"[%@千米]",[responseObject valueForKey:@"distance"]];
            
        }
        
    }else {
        self.postTime.text = @"[无法定位距离]";
    }*/

 /*   if ([AppUtil isNull: [responseObject valueForKey:@"talk"]]) {
        
        self.bestSpecInfo.text = @"";
    }else {
        NSString * talk = [responseObject valueForKey:@"talk"];
        self.bestSpecInfo.text = talk;
    }*/
  
    
   /* if ([AppUtil isNotNull:[responseObject valueForKey:@"constellation"]]) {
        
        NSString * constellation = [responseObject valueForKey:@"constellation"];//星座
        self.xingzuoLabel.text = constellation;
    }


    if ([AppUtil isNotNull: [responseObject valueForKey:@"created"]]) {
        NSString * createed = [responseObject valueForKey:@"created"];
        self.registerDate.text = createed;

    }
    
    if ([AppUtil isNotNull:[responseObject valueForKey:@"career"]]) {
        
        NSString * career = [responseObject valueForKey:@"career"];
        self.job.text = career;

    }
    
    if ([AppUtil isNotNull: [responseObject valueForKey:@"signature"]]) {
        
        NSString * signature1 = [responseObject valueForKey:@"signature"];
       
        self.gxqmLabel.text = signature1;
        
        
       // CGFloat maxHeight = 9999;
    
   //     CGSize textSize = [self.gxqmLabel.text sizeWithFont:self.gxqmLabel.font
     //                             constrainedToSize:CGSizeMake(self.gxqmLabel.width, maxHeight)
                                    //  lineBreakMode:self.gxqmLabel.lineBreakMode];
       
        self.gxqmLabel.height = 9999;
        
        [self.gxqmLabel sizeToFit];
        
     //   self.gxqmLabel.height = textSize.height;
    }
    
   
    if ([AppUtil isNotNull:[responseObject valueForKey:@"home"]]) {
        
        NSString * home = [responseObject valueForKey:@"home"];//家乡
        self.homeTown.text = home;
    }

    
    if ([AppUtil isNotNull: [responseObject valueForKey:@"interest"]]) {
        
        NSString * interest = [responseObject valueForKey:@"interest"];
        self.xqahLabel.text = interest;
        
        [self.xqahLabel sizeToFit];
    }
*/
    if([AppUtil isNotNull:[responseObject valueForKey:@"relation"]]){
        
        NSString * relation = [responseObject valueForKey:@"relation"];
        
    //    self.releation.text = relation;
        
        if ([relation isEqualToString:@"黑名单"]) {////黑名单
            
            self.isBlack = YES;
            
            [_buttomBarView updatePullBlackWithFlag:NO];
        
        }else {
            
            self.isBlack = NO;
            
            [_buttomBarView updatePullBlackWithFlag:YES];
        }
    }
    
    /*****
     只差一个时间
     ***/
    
   /* if ([AppUtil isNotNull:[responseObject valueForKey:@"lasttime"]]) {
        
        self.distanceLabel.text = [responseObject valueForKey:@"lasttime"];
    }*/
    
    //[self.postTime sizeToFit];
    
   // [self.distanceLabel sizeToFit];
    
 //   self.distanceLabel.left = self.postTime.right + 20;
    
    
    NSArray * photoArr = [responseObject valueForKey:@"user_photos"];
    
    int headIndex = 0;
    int index = 0;
    
    if ([photoArr count] > 0) {
        
        NSMutableArray * images = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (NSDictionary * dic in photoArr) {
            
            [images addObject:[dic valueForKey:@"path"]];
            
            if ([[dic valueForKey:@"ishead"] intValue] == 1) {
                
                headIndex = index;
                self.headID = [[dic valueForKey:@"id"] intValue];
            }
            
            index ++;
        }
        _imageArr = images;
        
        _photoHeaderView = [[PhotoHeaderView alloc] initWithFrame:CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, 0)];
        [_photoHeaderView layoutWithType:1 Photos:images headIndex:headIndex];
        _photoHeaderView.delegate = self;
        _photoHeaderView.backgroundColor = [UIColor clearColor];
        self.tableView.tableHeaderView = _photoHeaderView;
    }
    
    [self.otherUserHeaderView layoutWithDic:responseObject];
    
    [self.tableView reloadData];

}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        [cell.contentView addSubview:self.otherUserHeaderView];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return _otherUserHeaderView.height;
}

#pragma mark - buttomBarViewDelegate

- (void)buttomBarView:(ButtomBarView *)buttomBarView didClick:(int)type {
    
   NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    if (!memberID) {
        
        [self gotoLogin];
        
        return;
    }
    
    if (type == 0) {
        
        NSString * chatter = [self.userInfo valueForKey:@"user_name"];
        
        NSString * userName = [[[NSUserDefaults standardUserDefaults] userInfo]valueForKey:@"user_name"];
        
        if([AppUtil isNull:self.userID]){
            
            return;
            
        }
        
        if([userName isEqualToString:chatter]){
            
            [AppUtil HUDWithStr:@"自己不能邀约自己哦!" View:self.view];
            
            return;
        }
        
        [self takeFollowWithUid:self.userID];///自己的服务端邀约
        
    }else if(type == 1) {
        
        NSString * chatter = [self.userInfo valueForKey:@"user_name"];
        NSString * nickName = [self.userInfo valueForKey:@"nick_name"];
        NSString * headPhoto = [self.userInfo valueForKey:@"head_photo"];
        
       NSString * userName = [[[NSUserDefaults standardUserDefaults] userInfo]valueForKey:@"user_name"];
        
        
        if([AppUtil isNull:self.userID]){
            
            return;
            
        }
        
        if([userName isEqualToString:chatter]){
            
            [AppUtil HUDWithStr:@"自己不能跟自己聊天哦!" View:self.view];
            
            return;
        }
        
        
       ChatViewController * chatController = [[ChatViewController alloc] initWithChatter:chatter isGroup:NO];
        
        if ([AppUtil isNotNull:nickName]) {
            chatController.nickName = nickName;
        }else {
             chatController.nickName = chatter;
        }
        if([AppUtil isNotNull:headPhoto]) {
            
            chatController.avatar = headPhoto;
        }
        
        chatController.userID = self.userID;
   
        [self.navigationController pushViewController:chatController animated:YES];
        
    }else if(type == 2) {
        
        NSString * chatter = [self.userInfo valueForKey:@"user_name"];
        
        NSString * userName = [[[NSUserDefaults standardUserDefaults] userInfo]valueForKey:@"user_name"];
        
        if([AppUtil isNull:self.userID]){
            
            return;
            
        }
        
        if([userName isEqualToString:chatter]){
            
            [AppUtil HUDWithStr:@"自己不能拉黑自己哦!" View:self.view];
            
            return;
        }
        
        if (self.isBlack) {
            
            [self pullUNBlackWithUid:self.userID];
            
        }else{
            
              [self pullBlackWithUid:self.userID];//自己的服务端拉黑
        }
    
    }
    
}

#pragma mark - PhotoHeaderViewDelegate

- (void)photoHeaderViewDidClickPhotoActionWithIndex:(int)index type:(int)type {
    
    NSArray * urls = [AppUtil getBigImage:_imageArr];
    
    [self openImageSetWithUrls:urls initImageIndex:index];
}

- (void)photoHeaderViewDidClickAddAction {
    
    [self  openSelectSingleImageAction];
    
}

#pragma mark - Actions

- (void)otherActivitys {
    
   /* NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
  //  if (memberID && [memberID intValue] == [self.userID intValue] ) {
        
        /////我发起的活动
        UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        NeborCoffeeVenuesViewController * beborCV = [board instantiateViewControllerWithIdentifier:@"NeborCoffeeVenuesViewController"];
        
        beborCV.type = 4;////我参与的活动
        
        [self.navigationController pushViewController:beborCV animated:YES];

    }else {*/
        
        /////我发起的活动
        UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        NeborCoffeeVenuesViewController * beborCV = [board instantiateViewControllerWithIdentifier:@"NeborCoffeeVenuesViewController"];
        
        beborCV.userID = self.userID;///userID
        
        beborCV.titleName = [NSString stringWithFormat:@"%@的活动",self.nickName];
        

        beborCV.type = 5;
        
        [self.navigationController pushViewController:beborCV animated:YES];
        
    //}
}

#pragma mark - 获取用户资料

- (void)takeFollowWithUid:(NSString *)userID {
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"contact",@"c",@"follow",@"act", memberID,@"loginid",userID,@"userid",nil];
    
    [manager GET:hostUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            [AppUtil HUDWithStr:@"邀约成功" View:self.view];//K_UPDATE_CONTACTS
            
            [[NSNotificationCenter defaultCenter] postNotificationName:K_UPDATE_CONTACTS object:nil userInfo:nil];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)pullBlackWithUid:(NSString *) userID {
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"contact",@"c",@"black",@"act", memberID,@"loginid",userID,@"userid",nil];
    
    [manager GET:hostUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
             NSString * chatter = [self.userInfo valueForKey:@"user_name"];
            
             [[EaseMob sharedInstance].chatManager blockBuddy:chatter relationship:eRelationshipBoth];///环信拉黑
            
            [AppUtil HUDWithStr:@"拉黑成功" View:self.view];
            
              [_buttomBarView updatePullBlackWithFlag:NO];
            
            self.isBlack = YES;
            
             [[NSNotificationCenter defaultCenter] postNotificationName:K_UPDATE_CONTACTS object:nil userInfo:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:K_PULL_BLACK_NOTIFICATION object:chatter userInfo:nil];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)pullUNBlackWithUid:(NSString *) userID {
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"contact",@"c",@"unblack",@"act", memberID,@"loginid",userID,@"userid",nil];
    
    [manager GET:hostUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            NSString * chatter = [self.userInfo valueForKey:@"user_name"];
            [[EaseMob sharedInstance].chatManager unblockBuddy:chatter];/// 若有,从环信黑名单删除

            [AppUtil HUDWithStr:@"转粉成功" View:self.view];
            
            [_buttomBarView updatePullBlackWithFlag:YES];
           
            self.isBlack = NO;
            
             [[NSNotificationCenter defaultCenter] postNotificationName:K_UPDATE_CONTACTS object:nil userInfo:nil];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


#pragma mark - Memory Manage

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:K_LOGIN_NOTIFICATION object:nil];
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
