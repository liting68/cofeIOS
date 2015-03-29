//
//  MainViewController.m
//  CoffeeDateMe
//  定位 + 2个问题 + 咖啡详情不知道如何改
//  Created by 波罗密 on 14-9-28.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "MainViewController.h"
#import "MainHeaderView.h"
#import "ActivityCell.h"
#import "WantDrinkViewController.h"
#import "NeborCoffeeVenuesViewController.h"
#import "CafeDetailViewController.h"
#import "WTURLImageView.h"
#import "NVSlideMenuController.h"
#import "DateSquareVC.h"
#import "AppDelegate.h"
#import "NVSlideMenuController.h"
#import "UserCenterVC.h"

@interface MainViewController ()<MainHeaderViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    MainHeaderView * _mainHeaderView;
    NSMutableArray * _activityArray;
}
@end

@implementation MainViewController

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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"MainHeaderView" owner:nil options:nil];
    _mainHeaderView = [nibView objectAtIndex:0];
    _mainHeaderView.pageControl.numberOfPages = 0;
    _mainHeaderView.delegate = self;
    self.tableView.tableHeaderView = _mainHeaderView;
    
    
    
   ///刷新
  //  page = 1;
   // refreshing = YES;
   // [self initHeaderViewWithTableView:self.tableView];
  //  [self initFooterViewWithTableView:self.tableView];
    
   // _activityArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self getBanners];
 //   [self getOfficeActivity];
    
    //////////////////////
    [self initNavView];
    [self forNavBeNoTransparent];
    [self initTitleViewWithTitleString:@"咖啡约我"];
    [self initLeftBarButtonItem:@"common_list" title:nil action:@selector(listAction)];
    /////////////////////////////
    
    [self checkUserIsCompleteUserName];
}

- (void)checkUserIsCompleteUserName {
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    if (memberID) {
        
        NSDictionary * userInfo = [[NSUserDefaults standardUserDefaults]userInfo];
        
        NSString * userName = [userInfo valueForKey:@"user_name"];
        
        if ([AppUtil isNull:userName]) {
        
         //   [AppUtil HUDWithStr:@"请先个人完善信息" View:self.view];
            
            [self gotoInputInfo];
            
          //  [self performSelector:@selector(gotoInputInfo) withObject:nil afterDelay:1.0];
       
        }
    }
}

- (void)gotoInputInfo {
    
    NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    if (memberID) {
        
        NSDictionary * userInfo = [[NSUserDefaults standardUserDefaults]userInfo];
        
        NSString * userName = [userInfo valueForKey:@"user_name"];
        
        if ([AppUtil isNull:userName]) {
            
            UserCenterVC * userCenter = [self getStoryBoardControllerWithControllerID:@"UserCenterVC" storyBoardName:@"Other"];
            userCenter.otherID = [NSString stringWithFormat:@"%@",memberID];
            userCenter.nickName = nil;
            userCenter.isFromLogin = YES;
            userCenter.isMySelf = YES;
            
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:userCenter] animated:YES
                             completion:^{
                                 
                             }];
        }
    }

}

- (void)viewWillAppear:(BOOL)animated {
    
    [self showTabBar];
    
   // AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
 //   NVSlideMenuController * slideMenuVC = (NVSlideMenuController *)appDelegate.window.rootViewController;
 //   slideMenuVC.panGestureEnabled = YES;

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self hideTabBar];
    
   // AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
   // NVSlideMenuController * slideMenuVC = (NVSlideMenuController *)appDelegate.window.rootViewController;
   // slideMenuVC.panGestureEnabled = NO;
}

#pragma mark - Super Method

- (void)listAction {
    
    if ([self.getSlideMenuVC isMenuOpen]){
        
        [self.getSlideMenuVC closeMenuAnimated:YES completion:nil];
        
    }else {
        
        [self.getSlideMenuVC openMenuAnimated:YES completion:nil];
        
    }
}

- (void)refreshingAction {
    
    [self getOfficeActivity];
}

- (void)loadingingAction {
    
    [self getOfficeActivity];
}

#pragma amrk - 获取首页的Banner

- (void)getBanners {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"index",@"c",@"banner",@"act", nil];
    
    [manager GET:hostUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            NSLog(@"%@",response.result);
            
            [self getBannerSuccessWithDictionry:response.result];
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - 获取官方活动

- (void)getOfficeActivity {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"publicEvent",@"c",@"getEvents",@"act",[NSString stringWithFormat:@"%d",page],@"page", nil];
    
    [AppUtil showHudInView:self.view tag:10001];
    
    [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [AppUtil hideHudInView:self.view mtag:10001];
        [header endRefreshing];
        [footer endRefreshing];
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            if (refreshing) {
                
                [_activityArray removeAllObjects];
            }
            
            [_activityArray addObjectsFromArray:response.result];
            
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
        [AppUtil hideHudInView:self.view mtag:10001];
        [header endRefreshing];
        [footer endRefreshing];
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - getBannerSuccess

- (void)getBannerSuccessWithDictionry:(NSArray *)imgs {
    
 //   NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"MainHeaderView" owner:nil options:nil];
 //   _mainHeaderView = [nibView objectAtIndex:0];
  //  _mainHeaderView.delegate = self;
    
    NSMutableArray * imagesArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary * dic  in imgs) {
        
        [imagesArr addObject:[dic valueForKey:@"img"]];
    }
    
    [_mainHeaderView layoutWithBanners:imagesArr];
    
 //   self.tableView.tableHeaderView = _mainHeaderView;
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ActivityCell *cell = (ActivityCell *)[tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary * activity = _activityArray[indexPath.row];
    
    cell.activityAvatarView.layer.cornerRadius = 6.0;
    cell.activityAvatarView.layer.masksToBounds = YES;
   [cell.activityAvatarView setURL:[activity valueForKey:@"img"] defaultImage:@"candan" type:0];
    cell.activityName.text = [activity valueForKey:@"title"];
  
   // num
    if ([AppUtil isNotNull:[activity valueForKey:@"num"]]) {
        
        cell.partInNumber.text = [NSString stringWithFormat:@"%@",[activity valueForKey:@"num"]];
    
    }else {
        
        cell.partInNumber.text = @"0";
    }
    
    
   // cell.partInNumber.text = @"1000";
    
    [cell.partInNumber sizeToFit];
    
    /////////////
    cell.hintLabel.left = cell.partInNumber.right + 2;
    
 //   [cell setNeedsDisplay];
    
  //  NSString * datetime = [activity valueForKey:@"datetime"];
    
    NSString * datetime = [activity valueForKey:@"created"];
    
    cell.partInTimes.text = [AppUtil convertToTimeFromDateTime:datetime];
    
    cell.timeLabel.text = [AppUtil convertToFdateFromDateTime:datetime];
    
    cell.weekLabel.text = [AppUtil getWeekFromDate:datetime];
    
   /* if ([AppUtil isNotNull:[activity valueForKey:@"distance"]]) {
        
        if ([[activity valueForKey:@"distance"] isEqualToString:@"无法定位距离"]) {
            
            cell.distanceLabel.text = @"无法定位距离";
            
        }else {
            
            cell.distanceLabel.text = [NSString stringWithFormat:@"%@km",[activity valueForKey:@"distance"]];
            
        }
        
    }else {
       
       cell.distanceLabel.text = @"无法定位距离";
    }*/

    
  /*  if ([AppUtil isNotNull:[activity valueForKey:@"distance"]]) {
        
        cell.distanceLabel.text = @"0";
        
    }else {
        
        cell.distanceLabel.text = [NSString stringWithFormat:@"%@",[activity valueForKey:@"distance"]];
    }*/

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_activityArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    return 116;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CafeDetailViewController * cafeDetailViewController = [board instantiateViewControllerWithIdentifier:@"CafeDetailViewController"];
 
    NSDictionary * activity = _activityArray[indexPath.row];
    
    cafeDetailViewController.activityID = [NSString stringWithFormat:@"%@",[activity valueForKey:@"id"]];
    
    [self.navigationController pushViewController:cafeDetailViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - MainHeaderViewDelegte

// 0.想喝咖啡 1.发起的留言活动 2.附近的咖啡店
- (void)mainHeaderViewDidClickAction:(int)type {
    
    if (type == 0) {
        
        WantDrinkViewController * wantDrinkViewController = [[WantDrinkViewController alloc] init];
        
        [self.navigationController pushViewController:wantDrinkViewController animated:YES];
        
    }else if(type == 1){
        
        UIStoryboard * board = [UIStoryboard storyboardWithName:@"Other" bundle:nil];
        
        DateSquareVC * beborCV = [board instantiateViewControllerWithIdentifier:@"DateSquareVC"];
        
        [self.navigationController pushViewController:beborCV animated:YES];
        
    }else if(type == 2){
        
        UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

        NeborCoffeeVenuesViewController * beborCV = [board instantiateViewControllerWithIdentifier:@"NeborCoffeeVenuesViewController"];
        
        beborCV.type = 0;
        
        [self.navigationController pushViewController:beborCV animated:YES];
        
    }else {
         UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        NeborCoffeeVenuesViewController * beborCV = [board instantiateViewControllerWithIdentifier:@"NeborCoffeeVenuesViewController"];
        
        beborCV.type = 4;
        
        [self.navigationController pushViewController:beborCV animated:YES];
        
    }
}

#pragma mark - Memory Manage

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
}*/


@end
