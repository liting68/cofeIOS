//
//  MessageViewController.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-9-28.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "MessageViewController.h"
#import "WTURLImageView.h"
#import "ChatViewController.h"
#import "MySearchDisplayController.h"
#import "OtherUserViewController.h"
#import "UserCell.h"
#import "FLViewController.h"
#import "FindNumberView.h"
#import "UserCenterVC.h"

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UserCellDelegate>
{
    UINib * cellNib;
    
    NSMutableArray * dataArray;
    
    UISearchBar *_searchB;
    MySearchDisplayController *_searchDisplayC;
}
@end

@implementation MessageViewController

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
    
    [self initNavView];
    [self forNavBeNoTransparent];
    
    NSString * titleName = nil;
    
    if (self.type == 0) {
        
       titleName = @"消息";
        
         [self initTitleViewWithTitleString:titleName];
    
    }else if(self.type == 1){
        
        titleName = @"我喜欢的人";
        
        [self initBackButton];
        
         [self initTitleViewWithTitleString:titleName];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchUserInfo) name:K_PULL_BLACK_NOTIFICATION object:nil];
        
    }else if(self.type == 2){
        
        titleName = @"喜欢我的人";
        
        [self initBackButton];
         [self initTitleViewWithTitleString:titleName];
        
    }else  if (self.type == 3){
        
        titleName = @"推荐";
        
        [self initBackButton];
         [self initTitleViewWithTitleString:titleName];
    
    }else if (self.type == 4) {
        
        titleName = @"搜索列表";
        
        [self initBackButton];
    
         [self initTitleViewWithTitleString:titleName];
        
    }else if (self.type == 5) {
        
        titleName = @"手机联系人";
        
        [self initBackButton];
         [self initTitleViewWithTitleString:titleName];
    
    }else if (self.type == 6) {
        
        titleName = @"附近爱喝咖啡的人";
        
        [self initBackButton];
        
         [self initTitleViewWithTitleString:titleName];
        
    }

/*
    _searchB = [[UISearchBar alloc] initWithFrame:CGRectMake(0, self.navView.bottom,self.view.width, 44)];
    [_searchB setBackgroundColor:[UIColor colorWithRed:0.742 green:0.741 blue:0.760 alpha:1.000]];
    [_searchB setPlaceholder:@"搜索"];
    [_searchB setSearchBarStyle:UISearchBarStyleDefault];
    
    _searchDisplayC = [[MySearchDisplayController alloc] initWithSearchBar:_searchB contentsController:self];
    _searchDisplayC.active = NO;
    _searchDisplayC.delegate = self;
    _searchDisplayC.searchResultsDataSource =self;
    _searchDisplayC.searchResultsDelegate =self;
    [self.view addSubview:_searchDisplayC.searchBar];*/

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)viewDidAppear:(BOOL)animated {
    
    if (self.type == 0) {
        
        [self changeConstraints];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (self.type == 0) {
        [self showTabBar];
    }else {
        
        [self hideTabBar];
    }
    
    [self fetchUserInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    if (self.type ==0) {
         [self hideTabBar];
    }
}

#pragma mark - UserCellDelegate

- (void)userCellDidClickAdd:(UserCell *)userCell {
    
        NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
        
        if ([AppUtil isNull:memberID]) {
            
            [self gotoLogin];
            
            return;
        }
    
    NSDictionary * dic1 = userCell.dic;
    NSString * userid = [dic1 valueForKey:@"user_id"];
    
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        [dic setValue:@"follow" forKey:@"act"];
        [dic setObject:@"contact" forKey:@"c"];
        [dic setObject:userid forKey:@"userid"];
        [dic setObject:memberID forKey:@"loginid"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:hostUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            if (response.err == 1) {
                
                [AppUtil HUDWithStr:@"添加成功" View:self.view];
                
                [userCell.addButton setBackgroundImage:TTImage(@"coffee_add_normal") forState:UIControlStateNormal];
                userCell.addButton.enabled = NO;
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
}

#pragma mark - changeConstraints 

- (void)changeConstraints {
    
    [self.view removeConstraint:self.footerContraint];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_tableView]-44-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    
    [self.view setNeedsLayout];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    
    if (self.type == 4 || self.type == 5 || self.type == 6) {
        
        return 36;
    
    }else {
        
        return 0;
    }

   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.type == 4 || self.type == 5 || self.type == 6) {
        
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"FindNumberView" owner:nil options:nil];
        FindNumberView * findNumberView  = [nibView objectAtIndex:0];
        findNumberView.numberLbael.text = [NSString stringWithFormat:@"%d",self.count];
        [findNumberView sizeToFit];
        
        findNumberView.lastLabel.left = findNumberView.numberLbael.right + 1;
        
        return findNumberView;
    }else {
        
        return nil;
    }

}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary * userInfo;
    
    if (tableView == _searchDisplayC.searchResultsTableView)
    {
        userInfo = _searchResults[indexPath.row];
    }else{
        userInfo = dataArray[indexPath.row];
    }
    
    static NSString *CellIdentifier = @"UserCell";
    
    if (!cellNib) {
        
        cellNib = [UINib nibWithNibName:CellIdentifier bundle:nil];
        
        [self.tableView registerNib:cellNib forCellReuseIdentifier:CellIdentifier];
    }
    
    UserCell *cell = (UserCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.dic = userInfo;
    cell.delegate = self;
    
    cell.avatarView.layer.masksToBounds = YES;
    cell.avatarView.layer.cornerRadius = cell.avatarView.width/2;
    cell.avatarView.layer.borderWidth = 1.0;
    cell.avatarView.layer.borderColor = [[UIColor whiteColor] CGColor];
    [cell.avatarView setURL:[userInfo valueForKey:@"head_photo"] defaultImage:@"default_avatar" type:1];

    if ([AppUtil isNotNull:[userInfo valueForKey:@"nick_name"]]) {
        
         cell.nickName.text = [userInfo valueForKey:@"nick_name"];
        
    }else{
        
          cell.nickName.text = [userInfo valueForKey:@"user_name"];
    }
    
    int  sex = [[userInfo valueForKey:@"sex"] intValue];
    
    if (sex == 1) {///男女
        
       cell.sexView.image= TTImage(@"wantD_nan");
       cell.xzBg.image = TTImage(@"xingzuo_boy_Bg");
        cell.ageLabel.textColor = [UIColor colorWithRed:0.682 green:0.851 blue:0.961 alpha:1.000];
        
    }else if(sex == 2) {
        
        cell.sexView.image = TTImage(@"wantD_nv");
      cell.xzBg.image = TTImage(@"xingzuo_nv_Bg");
        cell.ageLabel.textColor = [UIColor colorWithRed:0.961 green:0.407 blue:0.618 alpha:1.000];
        
    }else  {
        
       cell.sexView.image= TTImage(@"buxian");
        cell.xzBg.image = TTImage(@"xingzuo_none");
        cell.ageLabel.textColor = [UIColor colorWithWhite:0.537 alpha:1.000];
    }
    
    cell.xingzuoLabel.text = [userInfo valueForKey:@"constellation"
                              ];
    cell.ageLabel.text = [userInfo valueForKey:@"age"];
    
    cell.coffeeLabel.text = [NSString stringWithFormat:@"咖啡号:%@",[userInfo valueForKey:@"user_name"]];
    
    
    if (self.type == 4 || self.type == 5 || self.type == 6) {
        
        [cell.addButton setHidden:NO];
        [cell.locationView setHidden:YES];
        [cell.distanceLabel setHidden:YES];
        
        NSString * isadd = [userInfo valueForKey:@"isadd"];
        
        if ([isadd isEqualToString:@"added"]) {
            
            [cell.addButton setBackgroundImage:TTImage(@"coffee_add_normal") forState:UIControlStateNormal];
            cell.addButton.enabled = NO;
         
            
        }else {
            
            [cell.addButton setBackgroundImage:TTImage(@"coffee_add") forState:UIControlStateNormal];
            cell.addButton.enabled = YES;
            
        }
        
    }else {
        
        [cell.addButton setHidden:YES];
        [cell.locationView setHidden:NO];
        [cell.distanceLabel setHidden:NO];
        
        if ([[userInfo valueForKey:@"distance"] isEqualToString:@"无法定位距离"]) {
            
            cell.distanceLabel.text = @"无法定位距离";
            
        }else {
            
            cell.distanceLabel.text = [NSString stringWithFormat:@"%@km",[userInfo valueForKey:@"distance"]];
            
        }

        [cell.distanceLabel sizeToFit];
        
        cell.distanceLabel.right = 310;
        
        cell.locationView.right = cell.distanceLabel.left - 5;
        
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _searchDisplayC.searchResultsTableView)
    {
        return [_searchResults count];
    }
    return [dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    

    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary * userInfo;
    
    if (tableView == _searchDisplayC.searchResultsTableView)
    {
        userInfo = _searchResults[indexPath.row];
    }else{
        userInfo = dataArray[indexPath.row];
    }
    
    if (self.type == 0) {
        
        FLViewController * flViewVC = [[FLViewController alloc] init];
        
        flViewVC.userID = [userInfo valueForKey:@"user_id"];
        
        flViewVC.userName = [userInfo valueForKey:@"nick_name"];
        
        UIView * view = [self.view viewWithTag:8000 + indexPath.row];
        [view setHidden:YES];
        UIView * view2 = [self.view viewWithTag:9000 + indexPath.row];
        [view2 setHidden:YES];
        
        [self.navigationController pushViewController:flViewVC animated:YES];
        
    }else {
        
        if (![self checkLogin]) {
            
            return;
        }
        
        
          UserCenterVC * otherUserViewController = [self getStoryBoardControllerWithControllerID:@"UserCenterVC" storyBoardName:@"Other"];
      //  OtherUserViewController * otherUserViewController = [self getStoryBoardControllerWithControllerID:@"OtherUserViewController"];
        
        if ([AppUtil isNotNull:[userInfo valueForKey:@"user_id"]]) {
            
            otherUserViewController.otherID = [userInfo valueForKey:@"user_id"];
        }else {
            
            otherUserViewController.otherID = @"";
        }
        
        if ([AppUtil isNotNull:[userInfo valueForKey:@"nick_name"]]) {
            otherUserViewController.nickName = [userInfo valueForKey:@"nick_name"];
        }else{
            otherUserViewController.nickName = [userInfo valueForKey:@"user_name"];
        }
        
        [self.navigationController pushViewController:otherUserViewController animated:YES];
        
    }
}

#pragma mark - Actions 

- (void)cancelAction {
    
    
}

- (void)goAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchDisplayDelegate

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
   /* [UIView animateWithDuration:0.2 animations:^
     {
         self.navView.top -= 64;
         _searchB.top -= 44;
         _tableView.top -= 44;
     }completion:^(BOOL finished)
     {
         [self.navView setHidden:YES];
         _tableView.height += 44;
     }];*/
    
    controller.searchBar.showsCancelButton = YES;
    for(UIView *subView in [[controller.searchBar.subviews objectAtIndex:0] subviews])
    {
        if([subView isKindOfClass:UIButton.class])
        {
            [(UIButton*)subView setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
/*    [self.navView setHidden:NO];
    [UIView animateWithDuration:0.2 animations:^
     {
         self.navView.top += 64;
         _searchB.top += 44;
         _tableView.top += 44;
     }completion:^(BOOL finished)
     {
         _tableView.height -= 44;
     }];*/
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    if (!_searchResults) {
        
        _searchResults = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    [_searchResults removeAllObjects];
    
        
        for (NSDictionary * user in dataArray) {
            
            //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", searchString];
            //  self.searchResults = [self.names filteredArrayUsingPredicate:predicate];
            
            BOOL isIn = NO;
            
            if ([AppUtil isNotNull:@"nick_name"]) {
                
                NSString * nickName = [user valueForKey:@"nick_name"];
                
                if ([nickName rangeOfString:searchString].location != NSNotFound) {
                    
                    isIn = YES;
                    
                    [_searchResults addObject:user];
                }
                
            }
            
            if (!isIn && [AppUtil isNotNull:@"user_name"]){
                
                NSString * nickName = [user valueForKey:@"user_name"];
                
                if ([nickName rangeOfString:searchString].location != NSNotFound) {
                    
                    [_searchResults addObject:user];
                }
                
            }
        }
    
      return YES;
}


#pragma mark - 获取数据

- (void)fetchUserInfo {
    
    NSString * c;
    NSString * act;
    
    if (self.type == 0) {
        
        c = @"chat";
        act = @"getChatList";
        
    }else if(self.type ==1) {//关注
        
        c = @"contact";
        act = @"myFavri";
        
    }else if (self.type == 2){//粉丝
        
        c = @"contact";
        act = @"myFuns";
    }else if (self.type == 3){
        
        c = @"contact";
        act = @"recommend";
    
    }else if (self.type == 4) {///关键字
        
        c = @"contact";
        act = @"searchUsersByKeyword";
        
    }else if (self.type == 5) {//手机通讯录
        
        c = @"contact";
        act = @"searchUsersByMobiles";

        
    }else if (self.type == 6) {
        
        c = @"contact";
        act = @"searchUsersByNear";
    }
    
    NSNumber * memebrID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters;
    
    if (self.type == 0) {
        
         parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:c,@"c",act,@"act",memebrID,@"loginid", nil];
        
    }else {
        
        parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:c,@"c",act,@"act",memebrID,@"loginid", nil];
        
        if (self.type == 4) {
            
            [parameters setObject:self.keyword forKey:@"keyword"];
            
        }else if(self.type == 5) {
            
            if ([AppUtil isNotNull:self.mobile]) {
                
                 [parameters setObject:self.mobile forKey:@"mobile"];
            
            }else {
                
                [self.tableView reloadData];
                
                return;
                
            }
        
        }
    }
    
    [AppUtil showHudInView:self.view tag:10001];
    
    [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        
        [AppUtil hideHudInView:self.view mtag:10001]
        ;
        if (response.err == 1) {
            
            NSLog(@"%@",responseObject);
            
            if (!dataArray) {
                
                dataArray = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [dataArray removeAllObjects];
            
            [dataArray addObjectsFromArray:[response.result valueForKey:@"users"]];
            
            self.count = [[response.result valueForKey:@"count"] intValue];
            
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [AppUtil hideHudInView:self.view mtag:10001]
        ;
        
        NSLog(@"Error: %@", error);
    }];
}


#pragma mark - Memory Manage

- (void)dealloc {
    
    if (_type == 1) {
           [[NSNotificationCenter defaultCenter] removeObserver:self name:K_PULL_BLACK_NOTIFICATION object:nil];
    }

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
