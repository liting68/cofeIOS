//
//  CafeDetailViewController.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-9-30.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "CafeDetailViewController.h"
#import "CafeMapViewController.h"
#import "UserCenterVC.h"
#import "InterestPersonView.h"

@interface CafeDetailViewController ()<OfficeHeaderViewDelegate,InterestPersonViewDelegate>
{
    InterestPersonView * _interestPersonView;
    OfficeHeaderView * _offieceHeaderView;
}
@end

@implementation CafeDetailViewController

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

    [self initBackButton];
   
    [self initTitleViewWithTitleString:@"热门活动"];
    
    [self forNavBeTransparent];
    
    [self getOfficeActivityWithActivityID:self.activityID];
    
}

- (void)getOfficeActivityWithActivityID:(NSString *)activityID {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"publicEvent",@"c",@"eventInfo",@"act",activityID,@"eventid", nil];
    [AppUtil showHudInView:self.view tag:10002];
    
    [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [AppUtil hideHudInView:self.view mtag:10002];
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            [self fillInInfomationWithActivityData:response.result];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [AppUtil hideHudInView:self.view mtag:10002];
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)partInAction {
    
    NSNumber * userID =  [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    if (!userID) {
        
        [self gotoLogin];
        
    }else {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"publicEvent",@"c",@"joinEvent",@"act",self.activityID,@"eventid",userID,@"userid", nil];
        
        [manager GET:hostUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            if (response.err == 1) {
                
                NSDictionary * dic = [responseObject valueForKey:@"result"];
                
                [_interestPersonView layoutOutWithDic:dic];
                
                _bottomConstraint.constant = _interestPersonView.height;///对的

                _interestPersonView.top = K_UIMAINSCREEN_HEIGHT - _interestPersonView.height;

              //  NSLog(@"%@",responseObject);
               // [AppUtil HUDWithStr:@"您已成功参加活动" View:self.view];
    
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}

#pragma mark - InterestPersonDelegate

- (void)interestPersonView:(InterestPersonView *)interestPersonView didClickAvatarWithPersonInfo:(NSDictionary *)dic {
    
    if (![self checkLogin]) {
        
        return;
    }
    
    
    NSString * userID = [dic valueForKey:@"user_id"];
    
    UserCenterVC * otherUserViweController = [self getStoryBoardControllerWithControllerID:@"UserCenterVC" storyBoardName:@"Other"];
    
    otherUserViweController.otherID = userID;
    
    if ([AppUtil isNotNull:[dic valueForKey:@"nick_name"]]) {
        
        otherUserViweController.nickName = [dic valueForKey:@"nick_name"];
    }else {
        
        otherUserViweController.nickName = [dic valueForKey:@"user_name"];
        
    }
    
    [self.navigationController pushViewController:otherUserViweController animated:YES];

}

- (void)interestPersonViewDidClickInterestButton:(InterestPersonView *)interestPersonView {
    
    [self partInAction];
}

#pragma mark - 

- (void)fillInInfomationWithActivityData:(id)object {
    
    self.activityDic = object;
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"InterestPersonView" owner:nil options:nil];
    _interestPersonView  = [nibView objectAtIndex:0];
    _interestPersonView.delegate = self;
    [_interestPersonView layoutOutWithDic:object];
    _interestPersonView.frame = CGRectMake(0,K_UIMAINSCREEN_HEIGHT - _interestPersonView.height , K_UIMAINSCREEN_WIDTH, _interestPersonView.height);
    [self.view addSubview:_interestPersonView];
    
    self.bottomConstraint.constant = _interestPersonView.height;
    [self.view setNeedsDisplay];
    
    NSArray* nibView1 =  [[NSBundle mainBundle] loadNibNamed:@"OfficeHeaderView" owner:nil options:nil];
    _offieceHeaderView  = [nibView1 objectAtIndex:0];
   // _offieceHeaderView.activityAddr.copyableLabelDelegate = self;
    _offieceHeaderView.activityName.copyableLabelDelegate = self;
    _offieceHeaderView.backgroundColor = [UIColor clearColor];
    _offieceHeaderView.delegate = self;
    [_offieceHeaderView layoutWithActivityDic:object];
    self.tableView.tableHeaderView = nil;
    self.tableView.tableHeaderView = _offieceHeaderView;
}

#pragma mark - OfficeHeaderViewDelegate

- (void)officeHeaderViewDidGotoMapView {
    
    CafeMapViewController * cafeMapViewController = [[CafeMapViewController alloc] init];
    
    cafeMapViewController.cafeTitle = [self.activityDic valueForKey:@"title"] ;


    cafeMapViewController.coordinate = CLLocationCoordinate2DMake([[self.activityDic valueForKey:@"lat"] doubleValue], [[self.activityDic valueForKey:@"lng"] doubleValue]);
    
    [self.navigationController pushViewController:cafeMapViewController animated:YES];
}

- (void)officeHeaderViewClickHeaderViewWithIndex:(int)index {
    
    if (![self checkLogin]) {
        
        return;
    }
    

    NSArray * header_photos = [self.activityDic valueForKey:@"users_photo"];
    
    NSDictionary * dic = header_photos[index];
    
    NSString * userID = [dic valueForKey:@"user_id"];
   
    UserCenterVC * otherUserViweController = (UserCenterVC *)[self getStoryBoardControllerWithControllerID:@"UserCenterVC"];
    otherUserViweController.otherID = userID;
    
    if ([AppUtil isNotNull:[dic valueForKey:@"nick_name"]]) {
        
        otherUserViweController.nickName = [dic valueForKey:@"nick_name"];
    }else {
        
        otherUserViweController.nickName = [dic valueForKey:@"user_name"];
        
    }
    
    [self.navigationController pushViewController:otherUserViweController animated:YES];
    
}

- (void)officeHeaderViewClickBannerViewWithIndex:(int) index {
    
    NSMutableArray * urls = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSArray * header_photos = [self.activityDic valueForKey:@"photos"];
    
    for (NSDictionary * dic in header_photos) {
        
        [urls addObject:[dic valueForKey:@"img"]];
    }
    
   NSArray *  urlArr = [AppUtil getBigImage:urls];

    [self openImageSetWithUrls:urlArr initImageIndex:index];
}

- (void)officeHeaderViewDidUpdateSubViewSuccess {
    
    self.tableView.tableHeaderView = nil;
    
    self.tableView.userInteractionEnabled = YES;
    _offieceHeaderView.userInteractionEnabled = YES;
   self.tableView.tableHeaderView = _offieceHeaderView;
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
}
*/

@end
