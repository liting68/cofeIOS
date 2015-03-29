//
//  DateSquareDetail.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/14.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "DateSquareDetail.h"
#import "CafeMapViewController.h"
#import "UserCenterVC.h"
#import "CafeDetailVC.h"

@interface DateSquareDetail ()<InterestPersonViewDelegate,DateDetailHeaderDelegate>

@end

@implementation DateSquareDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavView];
    [self forNavBeNoTransparent];
    [self initBackButton];
    [self initTitleViewWithTitleString:@"约会详情"];
    
    [self getDetailEvents];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self hideTabBar];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - DateDetailHeaderDelegate

-(void)dateDetailHeaderDidGotoShop {
    
    UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CafeDetailVC * cafeDetailVC  = [board instantiateViewControllerWithIdentifier:@"CafeDetailVC"];
    
    NSDictionary * cafeInfo = _activityDic;
    cafeDetailVC.cafeName = [cafeInfo valueForKey:@"shoptitle"];
    
  
        
  cafeDetailVC.cafeID = [NSString stringWithFormat:@"%@",[cafeInfo valueForKey:@"shop_id"]];

    
    
    [self.navigationController pushViewController:cafeDetailVC animated:YES];
}

- (void)dateDetailHeaderDidGotoMap {
    
    CafeMapViewController * cafeMapViewController = [[CafeMapViewController alloc] init];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[self.activityDic valueForKey:@"lat"] doubleValue], [[self.activityDic valueForKey:@"lng"] doubleValue]);
    
    cafeMapViewController.coordinate = coordinate;
    
    [self.navigationController pushViewController:cafeMapViewController animated:YES];
    
}

#pragma MARK - interestPersonDelegate

- (void)interestPersonView:(InterestPersonView *)interestPersonView didClickAvatarWithPersonInfo:(NSDictionary *)dic {
    
    if (![self checkLogin]) {
        
        return;
    }
    
    
    UserCenterVC * userCenter = [self getStoryBoardControllerWithControllerID:@"UserCenterVC" storyBoardName:@"Other"];
    
    userCenter.otherID = [dic valueForKey:@"user_id"];
    
    userCenter.nickName = [dic valueForKey:@"nick_name"];
    
    [self.navigationController pushViewController:userCenter animated:YES];
    
}

- (void)interestPersonViewDidClickInterestButton:(InterestPersonView *)interestPersonView {
    
  NSNumber * memberID =  [[NSUserDefaults standardUserDefaults]currentMemberID];
    
    if (!memberID) {
        
        [AppUtil HUDWithStr:@"请先登录" View:self.view];
        
        [self gotoLogin];
        
        return;

    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"userEvent",@"c",@"joinEvent",@"act",self.eventID,@"eventid",memberID,@"userid",nil];
    
    [AppUtil showHudInView:self.view tag:10003];
    
    [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [AppUtil hideHudInView:self.view mtag:10003];
        [header endRefreshing];
        [footer endRefreshing];
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            NSDictionary * dic = [responseObject valueForKey:@"result"];
            
            [_interestPersonView layoutOutWithDic:dic];
            
            _tableView.tableFooterView = nil;
            
            _tableView.tableFooterView = _interestPersonView;
          //  _bottomConstraint.constant = _interestPersonView.height;///对的
            
           // _interestPersonView.top = K_UIMAINSCREEN_HEIGHT - _interestPersonView.height;
            
            [AppUtil HUDWithStr:@"报名成功" View:self.view];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [AppUtil hideHudInView:self.view mtag:10003];
        [header endRefreshing];
        [footer endRefreshing];
        NSLog(@"Error: %@", error);
    }];

}

#pragma mark - util

- (void)fillInInfomationWithActivityData:(id)object {
    
    self.activityDic = object;///
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"InterestPersonView" owner:nil options:nil];
    _interestPersonView  = [nibView objectAtIndex:0];
    _interestPersonView.delegate = self;
    _interestPersonView.isPerson = 1;
    [_interestPersonView layoutOutWithDic:object];
    _interestPersonView.frame = CGRectMake(0,0 , K_UIMAINSCREEN_WIDTH, _interestPersonView.height);
   // [self.view addSubview:_interestPersonView];
    
    self.bottomConstraint.constant = 0;//_interestPersonView.height;
    [self.view setNeedsDisplay];
    
    self.tableView.tableFooterView = _interestPersonView;
    
    
    NSArray* nibView1 =  [[NSBundle mainBundle] loadNibNamed:@"DateDetailHeader" owner:nil options:nil];
    _dateDetailHeader  = [nibView1 objectAtIndex:0];
    _dateDetailHeader.dateAddr.copyableLabelDelegate = self;
    _dateDetailHeader.backgroundColor = [UIColor clearColor];
    _dateDetailHeader.delegate = self;
    [_dateDetailHeader layoutWithDic:object];
    self.tableView.tableHeaderView = nil;
    self.tableView.tableHeaderView = _dateDetailHeader;
    
//    
//    
//#pragma mark -
//    
//    - (void)fillInInfomationWithActivityData:(id)object {
//        
//        self.activityDic = object;
//        
//        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"InterestPersonView" owner:nil options:nil];
//        _interestPersonView  = [nibView objectAtIndex:0];
//        _interestPersonView.delegate = self;
//        [_interestPersonView layoutOutWithDic:object];
//        _interestPersonView.frame = CGRectMake(0,K_UIMAINSCREEN_HEIGHT - _interestPersonView.height , K_UIMAINSCREEN_WIDTH, _interestPersonView.height);
//        [self.view addSubview:_interestPersonView];
//        
//        self.bottomConstraint.constant = _interestPersonView.height;
//        [self.view setNeedsDisplay];
//        
//        NSArray* nibView1 =  [[NSBundle mainBundle] loadNibNamed:@"OfficeHeaderView" owner:nil options:nil];
//        _offieceHeaderView  = [nibView1 objectAtIndex:0];
//        // _offieceHeaderView.activityAddr.copyableLabelDelegate = self;
//        _offieceHeaderView.activityName.copyableLabelDelegate = self;
//        _offieceHeaderView.backgroundColor = [UIColor clearColor];
//        _offieceHeaderView.delegate = self;
//        [_offieceHeaderView layoutWithActivityDic:object];
//        self.tableView.tableHeaderView = nil;
//        self.tableView.tableHeaderView = _offieceHeaderView;
//    }

  
}

#pragma mark -

- (void)getDetailEvents {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"userEvent",@"c",@"eventInfo",@"act",self.eventID,@"eventid", [NSString stringWithFormat:@"%d",page],@"page",nil];
    
    [AppUtil showHudInView:self.view tag:10003];
    
    [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [AppUtil hideHudInView:self.view mtag:10003];
        [header endRefreshing];
        [footer endRefreshing];
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            NSDictionary * dic = [responseObject valueForKey:@"result"];
            
            [self fillInInfomationWithActivityData:dic];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [AppUtil hideHudInView:self.view mtag:10003];
        [header endRefreshing];
        [footer endRefreshing];
        NSLog(@"Error: %@", error);
    }];
    
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
