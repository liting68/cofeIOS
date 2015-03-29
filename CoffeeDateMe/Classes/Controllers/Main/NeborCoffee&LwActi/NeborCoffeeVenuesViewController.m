//
//  NeborCoffeeVenuesViewController.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-9-30.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "NeborCoffeeVenuesViewController.h"
#import "WTURLImageView.h"
#import "PostLeaveWordViewController.h"
#import "CafeDetailVC.h"
#import "CafeDetailViewController.h"
#import "SWTableViewCell.h"
#import "VenuesSelectVC.h"
#import "MJRefreshConst.h"

@interface NeborCoffeeVenuesViewController ()<WTURLImageViewDelegate,UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,VenuesSelectVCDelegate>
{
    NSMutableArray * _coffeeVenuesArr;
}
@end

@implementation NeborCoffeeVenuesViewController

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
        [self forNavBeNoTransparent];
        
        if (self.type == 4) {
            
              [self initTitleViewWithTitleString:@"热门活动"];
            
        }else {
            
            
            [self initTitleViewWithTitleString:@"附近的咖啡厅"];
            [self initWithRightButtonWithImageName:nil title:@"筛选" action:@selector(selectAction)];
            
        }
        
   
        [self.postFlagView setHidden:YES];
        [self.postButton setHidden:YES];
        [self modifyConstraint];
        [self.view setNeedsLayout];
        
     page = 1;
    refreshing = YES;
    [self initHeaderViewWithTableView:self.tableView];
    [self initFooterViewWithTableView:self.tableView];
    
     _coffeeVenuesArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    ///////////////////////
//    [self initNavView];
  //  [self initBackButton];
  //  [self forNavBeNoTransparent];
    //////////////////
    
    [self getAboutData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self hideTabBar];
}

#pragma mark - Super Method

- (void)refreshingAction {
 
    if (self.type == 4) {
     
        [self getAboutData];
        
    }else if (self.keyName) {
       
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSString * pageStr = [NSString stringWithFormat:@"%d",page];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"shop",@"c",@"getShopByConditions",@"act",pageStr,@"page",self.keyName,@"keyword", nil];
        
        [AppUtil showHudInView:self.view tag:10003];
        
        [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            [AppUtil hideHudInView:self.view mtag:10003];
            [header endRefreshing];
            [footer endRefreshing];
            
            if (response.err == 1) {
                
                NSLog(@"%@",response.result);
                if (refreshing) {
                    
                    [_coffeeVenuesArr removeAllObjects];
                }
                
                
                [_coffeeVenuesArr addObjectsFromArray:response.result];
                
                [self.tableView reloadData];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [AppUtil hideHudInView:self.view mtag:10003];
            [header endRefreshing];
            [footer endRefreshing];
            NSLog(@"Error: %@", error);
        }];

        
    }else if (self.isSelected) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSString * pageStr = [NSString stringWithFormat:@"%d",page];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"shop",@"c",@"getShopByConditions",@"act",pageStr,@"page",self.provinceID,@"provinceid",self.cityID,@"cityid", nil];
        if (self.townID) {
            
            [parameters setValue:self.townID forKey:@"townid"];
        }
        
        if (self.circleID) {
            
            [parameters setValue:self.circleID forKey:@"circleid"];
        }
        
        [AppUtil showHudInView:self.view tag:10003];
        
        [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            [AppUtil hideHudInView:self.view mtag:10003];
            [header endRefreshing];
            [footer endRefreshing];
            
            if (response.err == 1) {
                
                NSLog(@"%@",response.result);
                if (refreshing) {
                    
                    [_coffeeVenuesArr removeAllObjects];
                }
                
                
                [_coffeeVenuesArr addObjectsFromArray:response.result];
                
                [self.tableView reloadData];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [AppUtil hideHudInView:self.view mtag:10003];
            [header endRefreshing];
            [footer endRefreshing];
            NSLog(@"Error: %@", error);
        }];

        
    }else {
        
          [self getAboutData];
    }
    
}

- (void)loadingingAction {
    
    if (self.type == 4) {
        
        [self getAboutData];
        
    }else if (self.keyName) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSString * pageStr = [NSString stringWithFormat:@"%d",page];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"shop",@"c",@"getShopByConditions",@"act",pageStr,@"page",self.keyName,@"keyword", nil];
        
        [AppUtil showHudInView:self.view tag:10003];
        
        [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            [AppUtil hideHudInView:self.view mtag:10003];
            [header endRefreshing];
            [footer endRefreshing];
            
            if (response.err == 1) {
                
                NSLog(@"%@",response.result);
                if (refreshing) {
                    
                    [_coffeeVenuesArr removeAllObjects];
                }
                
                
                [_coffeeVenuesArr addObjectsFromArray:response.result];
                
                [self.tableView reloadData];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [AppUtil hideHudInView:self.view mtag:10003];
            [header endRefreshing];
            [footer endRefreshing];
            NSLog(@"Error: %@", error);
        }];
        
        
    }else if (self.isSelected) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSString * pageStr = [NSString stringWithFormat:@"%d",page];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"shop",@"c",@"getShopByConditions",@"act",pageStr,@"page",self.provinceID,@"provinceid",self.cityID,@"cityid", nil];
        if (self.townID) {
            
            [parameters setValue:self.townID forKey:@"townid"];
        }
        
        if (self.circleID) {
            
            [parameters setValue:self.circleID forKey:@"circleid"];
        }
        
        [AppUtil showHudInView:self.view tag:10003];
        
        [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            [AppUtil hideHudInView:self.view mtag:10003];
            [header endRefreshing];
            [footer endRefreshing];
            
            if (response.err == 1) {
                
                NSLog(@"%@",response.result);
                if (refreshing) {
                    
                    [_coffeeVenuesArr removeAllObjects];
                }
                
                
                [_coffeeVenuesArr addObjectsFromArray:response.result];
                
                [self.tableView reloadData];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [AppUtil hideHudInView:self.view mtag:10003];
            [header endRefreshing];
            [footer endRefreshing];
            NSLog(@"Error: %@", error);
        }];

        
    }else {
        
        [self getAboutData];
    }
    
   
}

- (void)getAboutData {
    
    NSString * pageStr =[NSString stringWithFormat:@"%d",page];
    
    if (self.type == 4) {
        
        [self getOfficeActivity];
        
    }else  if (self.type == 0) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"shop",@"c",@"nearbyShops",@"act",pageStr,@"page", nil];
        
        [AppUtil showHudInView:self.view tag:10003];
        
        [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            [AppUtil hideHudInView:self.view mtag:10003];
            [header endRefreshing];
            [footer endRefreshing];
            
            if (response.err == 1) {
                
                NSLog(@"%@",response.result);
                if (refreshing) {
                    
                    [_coffeeVenuesArr removeAllObjects];
                }
                
                [_coffeeVenuesArr addObjectsFromArray:response.result];
                
                [self.tableView reloadData];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [AppUtil hideHudInView:self.view mtag:10003];
            [header endRefreshing];
            [footer endRefreshing];
            NSLog(@"Error: %@", error);
        }];

    }else if (self.type == 2) {
        
        NSNumber * userID = [[NSUserDefaults standardUserDefaults] currentMemberID];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"shop",@"c",@"favoriteShops",@"act",userID, @"userid",pageStr,@"page",nil];
        
        [AppUtil showHudInView:self.view tag:10003];
        
        [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [AppUtil hideHudInView:self.view mtag:10003];
            [header endRefreshing];
            [footer endRefreshing];
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            if (response.err == 1) {
                
                NSLog(@"%@",response.result);
                
                if (refreshing) {
                    
                    [_coffeeVenuesArr removeAllObjects];
                }

                
                [_coffeeVenuesArr addObjectsFromArray:response.result];
                
                [self.tableView reloadData];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [AppUtil hideHudInView:self.view mtag:10003];
            [header endRefreshing];
            [footer endRefreshing];
            NSLog(@"Error: %@", error);
        }];

    }else if (self.type == 1){
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"userEvent",@"c",@"getEvents",@"act", pageStr,@"page",nil];
        
        [AppUtil showHudInView:self.view tag:10003];
        
        [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [AppUtil hideHudInView:self.view mtag:10003];
            [header endRefreshing];
            [footer endRefreshing];
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            if (response.err == 1) {
                
                if (refreshing) {
                    
                    [_coffeeVenuesArr removeAllObjects];
                }
                
                
                [_coffeeVenuesArr addObjectsFromArray:[response.result valueForKey:@"events"]];
                
                
                [self.tableView reloadData];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [AppUtil hideHudInView:self.view mtag:10003];
            [header endRefreshing];
            [footer endRefreshing];
            NSLog(@"Error: %@", error);
        }];

    }else if (self.type == 3){
        
        NSNumber * userID = [[NSUserDefaults standardUserDefaults] currentMemberID];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"userEvent",@"c",@"myEvents",@"act",userID,@"userid", pageStr,@"page",nil];
        
        [AppUtil showHudInView:self.view tag:10003];
        
        [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [AppUtil hideHudInView:self.view mtag:10003];
            [header endRefreshing];
            [footer endRefreshing];
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            if (response.err == 1) {
               
                if (refreshing) {
                    
                    [_coffeeVenuesArr removeAllObjects];
                }


             [_coffeeVenuesArr addObjectsFromArray:response.result];

                
                [self.tableView reloadData];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [AppUtil hideHudInView:self.view mtag:10003];
            [header endRefreshing];
            [footer endRefreshing];
            NSLog(@"Error: %@", error);
        }];

        
    }else if (self.type == 4){
        
        NSNumber * userID = [[NSUserDefaults standardUserDefaults] currentMemberID];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"userEvent",@"c",@"myJoinEvents",@"act", userID,@"userid",pageStr,@"page",nil];
        
        [AppUtil showHudInView:self.view tag:10003];
        
        [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [AppUtil hideHudInView:self.view mtag:10003];
            [header endRefreshing];
            [footer endRefreshing];
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
        
            
            if (response.err == 1) {
                
                if (refreshing) {
                    
                    [_coffeeVenuesArr removeAllObjects];
                }
                
                
               [_coffeeVenuesArr addObjectsFromArray:[response.result valueForKey:@"events"]];
                
                
                [self.tableView reloadData];
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [AppUtil hideHudInView:self.view mtag:10003];
            [header endRefreshing];
            [footer endRefreshing];
            NSLog(@"Error: %@", error);
        }];

    }else if(self.type == 5){
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"userEvent",@"c",@"someoneEvents",@"act",self.userID,@"userid", pageStr,@"page",nil];
        
        [AppUtil showHudInView:self.view tag:10003];
        
        [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [AppUtil hideHudInView:self.view mtag:10003];
            [header endRefreshing];
            [footer endRefreshing];
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            if (response.err == 1) {
                
                if (refreshing) {
                    
                    [_coffeeVenuesArr removeAllObjects];
                }
                
                
                [_coffeeVenuesArr addObjectsFromArray:[response.result valueForKey:@"events"]];
                
                
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
                
                [_coffeeVenuesArr removeAllObjects];
            }
            
            [_coffeeVenuesArr addObjectsFromArray:response.result];
            
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [AppUtil hideHudInView:self.view mtag:10001];
        [header endRefreshing];
        [footer endRefreshing];
        NSLog(@"Error: %@", error);
    }];
}

- (void)modifyConstraint {
    
    self.footerContraint.constant = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    
   self.view.backgroundColor = [UIColor clearColor];
    
    if (self.type == 0 || self.type == 2) {//场馆
     
        [self.postButton setHidden:YES];
        
        [self.postFlagView setHidden:YES];
      
         [self modifyConstraint];
        
        [self.view setNeedsLayout];
        
     //   [self.view removeConstraint:self.footerContraint];
       /* [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
        [self.view setNeedsLayout];*/
    
    }else {//活动
        
        [self.postButton setHidden:NO];
        [self.postFlagView setHidden:NO];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	CoffeeVenuesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CoffeeVenuesCell"];
    
  //  cell.delegate = self;
    
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary * cofeInfo = _coffeeVenuesArr[indexPath.row];
    
    if (self.type == 4) {
        
        WTURLImageView	* avatarView = (WTURLImageView *)cell.bgView;//背景图
        [avatarView setURL:[cofeInfo valueForKey:@"img"] defaultImage:@"venues_acti_default" type:0];
        
        UILabel * venuesName = cell.nameLabel;//管名称
        venuesName.text = [cofeInfo valueForKey:@"title"];
        
        UILabel * tsLabel = cell.tsLabel;//特色
        
        if ([AppUtil isNull:[cofeInfo valueForKey:@"address"]]) {
            
            tsLabel.text = @"";
            
        }else {
            
            tsLabel.text = [NSString stringWithFormat:@"%@",[cofeInfo valueForKey:@"address"]];
            
        }
        
        UILabel * distanceLabel = cell.distanceLabel;//一样的
        
        if ([AppUtil isNotNull:[cofeInfo valueForKey:@"distance"]]) {
            
            if ([[cofeInfo valueForKey:@"distance"] isEqualToString:@"无法定位距离"]) {
                
                distanceLabel.text = @"无法定位距离";
                
            }else {
                
                distanceLabel.text = [NSString stringWithFormat:@"%@km",[cofeInfo valueForKey:@"distance"]];
                
            }
            
        }else {
            
            distanceLabel.text = @"无法定位距离";
        }
        
        [distanceLabel sizeToFit];
        
        distanceLabel.right = 310;
        
        cell.locationHint.right = distanceLabel.left - 3;
        
        UILabel * apartNumber = cell.apartNumber;
        
           NSString * datetime = [cofeInfo valueForKey:@"created"];
        
        apartNumber.text = datetime;

        
    }else if (self.type == 0 || self.type == 2) {
        
        WTURLImageView	* avatarView = (WTURLImageView *)cell.bgView;//背景图
        [avatarView setURL:[cofeInfo valueForKey:@"img"] defaultImage:@"venues_acti_default" type:0];
        
        UILabel * venuesName = cell.nameLabel;//管名称
        venuesName.text = [cofeInfo valueForKey:@"title"];
        
        UILabel * tsLabel = cell.tsLabel;//特色
        
        if ([AppUtil isNull:[cofeInfo valueForKey:@"feature"]]) {
            
            tsLabel.text = @"特色:";
        
        }else {
            
            tsLabel.text = [NSString stringWithFormat:@"特色:%@",[cofeInfo valueForKey:@"feature"]];

        }
        
        UILabel * distanceLabel = cell.distanceLabel;//一样的
    
        if ([AppUtil isNotNull:[cofeInfo valueForKey:@"distance"]]) {
            
            if ([[cofeInfo valueForKey:@"distance"] isEqualToString:@"无法定位距离"]) {
                
                distanceLabel.text = @"无法定位距离";
                
            }else {
                
                distanceLabel.text = [NSString stringWithFormat:@"%@km",[cofeInfo valueForKey:@"distance"]];
                
           }
            
        }else {
            
            distanceLabel.text = @"无法定位距离";
        }
        
        [distanceLabel sizeToFit];
        
        distanceLabel.right = 310;
     
        cell.locationHint.right = distanceLabel.left - 3;


        UILabel * apartNumber = cell.apartNumber;
      
        [apartNumber setHidden:YES];
        
    } else {//为1
        
        if (self.type == 3) {
            
            NSMutableArray *rightUtilityButtons = [NSMutableArray new];
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             [UIColor colorWithRed:0.509 green:0.322 blue:0.158 alpha:1.000]
                                                        title:@"取消活动"];
            
            [cell setRightUtilityButtons:rightUtilityButtons WithButtonWidth:140.0f];
            
             cell.row = indexPath.row;
            
            cell.delegate = self;
        
        }else if(self.type == 4){
            
            NSMutableArray *rightUtilityButtons = [NSMutableArray new];
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             [UIColor colorWithRed:0.509 green:0.322 blue:0.158 alpha:1.000]
                                                        title:@"取消报名"];
            
            [cell setRightUtilityButtons:rightUtilityButtons WithButtonWidth:140.0f];
            
             cell.row = indexPath.row;
            
            cell.delegate = self;
        }
        
        
         NSDictionary * cofeInfo = _coffeeVenuesArr[indexPath.row];
        
        WTURLImageView	* avatarView = cell.bgView;//(WTURLImageView *)[cell viewWithTag:103];//背景图
        
        avatarView.isNoActi = YES;
        
        [avatarView setURL:[cofeInfo valueForKey:@"img"] defaultImage:@"venues_acti_default"type:0];
    
        UILabel * venuesName = cell.nameLabel;//(UILabel *)[cell viewWithTag:100];//管名称
        venuesName.text = [cofeInfo valueForKey:@"title"];
        
        UILabel * tsLabel = cell.tsLabel;//(UILabel *)[cell viewWithTag:101];//特色
        tsLabel.text = [NSString stringWithFormat:@"地址:%@",[cofeInfo valueForKey:@"address"]];
        
        UILabel * distanceLabel = cell.distanceLabel;//(UILabel *)[cell viewWithTag:102];//一样的
       // distanceLabel.text = [NSString stringWithFormat:@"%@m",[cofeInfo valueForKey:@"distance"]];
        
        if ([AppUtil isNotNull:[cofeInfo valueForKey:@"distance"]]) {
            
            if ([[cofeInfo valueForKey:@"distance"] isEqualToString:@"无法定位距离"]) {
                
                distanceLabel.text = @"无法定位距离";
                
            }else {
                
                distanceLabel.text = [NSString stringWithFormat:@"%@km",[cofeInfo valueForKey:@"distance"]];
            }
            
        }else {
            
            distanceLabel.text = @"无法定位距离";
        }

    
        UILabel * apartNumber = cell.apartNumber;//(UILabel *)[cell viewWithTag:104];
        [apartNumber setHidden:NO];
        apartNumber.text = [NSString stringWithFormat:@"参加人数:%@",[cofeInfo valueForKey:@"num"]];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_coffeeVenuesArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    return 160;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.type == 0 || self.type == 1 || self.type == 2 || self.type == 3) {
        
        if ([_coffeeVenuesArr count] == 0) {
         
            return 40;
            
//            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, 40)];
//            label.textAlignment = NSTextAlignmentCenter;
//            label.text = @"抱歉,暂无您要的结果";
//            
//            return label;
            
        }
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.type == 0 || self.type == 1 || self.type == 2 || self.type == 3) {
        
        if ([_coffeeVenuesArr count] == 0) {
    
            
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, 40)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"抱歉,暂无您要的结果";
            label.textColor= MJRefreshLabelTextColor;
            label.font = [UIFont boldSystemFontOfSize:13];
            
            return label;
            
        }
    }
    
    return  nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.type == 4) {
        
        UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        CafeDetailViewController * cafeDetailViewController = [board instantiateViewControllerWithIdentifier:@"CafeDetailViewController"];
        
        NSDictionary * activity = _coffeeVenuesArr[indexPath.row];
        
        cafeDetailViewController.activityID = [NSString stringWithFormat:@"%@",[activity valueForKey:@"id"]];
        
        [self.navigationController pushViewController:cafeDetailViewController animated:YES];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }else if (self.type == 1 || self.type == 4 || self.type == 5) { /// PersonViewController
        
        NSDictionary * activityInfo = _coffeeVenuesArr[indexPath.row];
        
        if ([AppUtil isNotNull:[activityInfo valueForKey:@"public_event_id"]]) {///官方
            
            UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            CafeDetailViewController * cafeDetailViewController = [board instantiateViewControllerWithIdentifier:@"CafeDetailViewController"];
            
            cafeDetailViewController.activityID = [NSString stringWithFormat:@"%@",[activityInfo valueForKey:@"public_event_id"]];
            
            [self.navigationController pushViewController:cafeDetailViewController animated:YES];
            
        }else {
            
         //   UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
           // PersonViewController * personViewController  = [board instantiateViewControllerWithIdentifier:@"PersonViewController"];
            
           // personViewController.activityID = [NSString stringWithFormat:@"%@",[activityInfo valueForKey:@"user_event_id"]];
            
           // [self.navigationController pushViewController:personViewController animated:YES];
        }
        
    }else if(self.type == 0 || self.type == 2 ) {
        
        if (self.delegate) {
        
            NSDictionary * cafeInfo = _coffeeVenuesArr[indexPath.row];
            
            [self.delegate venuesDidSelectedSuccess:cafeInfo];
            
            [self popController];
            
        }else {
        
            UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            CafeDetailVC * cafeDetailVC  = [board instantiateViewControllerWithIdentifier:@"CafeDetailVC"];
            
            NSDictionary * cafeInfo = _coffeeVenuesArr[indexPath.row];
            cafeDetailVC.cafeName = [cafeInfo valueForKey:@"title"];
            
            if (self.type == 2) {//shop_id
                
                cafeDetailVC.cafeID = [NSString stringWithFormat:@"%@",[cafeInfo valueForKey:@"shop_id"]];
                
            }else {
                
                cafeDetailVC.cafeID = [NSString stringWithFormat:@"%@",[cafeInfo valueForKey:@"id"]];
                
            }
            
            
            [self.navigationController pushViewController:cafeDetailVC animated:YES];
            
        }
    
    }else if (self.type == 3){
        
      /*   NSDictionary * activityInfo = _coffeeVenuesArr[indexPath.row];
        
        UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PersonViewController * personViewController  = [board instantiateViewControllerWithIdentifier:@"PersonViewController"];
        
        personViewController.activityID = [NSString stringWithFormat:@"%@",[activityInfo valueForKey:@"id"]];
        
        [self.navigationController pushViewController:personViewController animated:YES];*/

    }
   
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SWTableCellDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {

     NSDictionary * activityInfo = _coffeeVenuesArr[cell.row];
    
    if (self.type == 3) { ///取消发起的活动
        
        NSNumber * memebrID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
        NSString * aid = [activityInfo valueForKey:@"id"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"userEvent",@"c",@"cancelEvent",@"act",memebrID,@"userid",aid,@"eventid", nil];
        
        [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [header endRefreshing];
            
            NSLog(@"%@",responseObject);
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            if (response.err == 1) {
                
                [_coffeeVenuesArr  removeObjectAtIndex:cell.row];
                
                [self.tableView reloadData];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [header endRefreshing];
            NSLog(@"Error: %@", error);
        }];
        
    }else if (self.type == 4) { //取消报名的活动
        
        NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
        
        NSString * aid = nil;
        
        NSMutableDictionary * paramsDic = nil;
        
        if ([AppUtil isNotNull:[activityInfo valueForKey:@"public_event_id"]]) {///官方
            
            aid = [NSString stringWithFormat:@"%@",[activityInfo valueForKey:@"public_event_id"]];
            
            paramsDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"userEvent",@"c",@"cancelJoinEvent",@"act",memberID,@"userid",aid,@"public_event_id", nil];
            
            
        }else {
            
            aid = [NSString stringWithFormat:@"%@",[activityInfo valueForKey:@"user_event_id"]];
            
              paramsDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"userEvent",@"c",@"cancelJoinEvent",@"act",memberID,@"userid",aid,@"user_event_id", nil];
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:hostUrl parameters:[self commonParamsWithDictionary:paramsDic] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            if (response.err == 1) {
                
                [_coffeeVenuesArr removeObjectAtIndex:cell.row];
                
                  [self.tableView reloadData];
            }
            
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [header endRefreshing];
            NSLog(@"Error: %@", error);
        }];
    }
}

#pragma mark - VenuesSelectVCDelegate 

- (void)veneusSelectVC:(VenuesSelectVC *)venuesSelectVC didSearchWithKeyName:(NSString *)keyName {
    
    [self updateTitle:keyName];
    
    self.keyName = keyName;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    page = 1;
    refreshing = YES;
    
    NSString * pageStr = [NSString stringWithFormat:@"%d",page];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"shop",@"c",@"getShopByConditions",@"act",pageStr,@"page",keyName,@"keyword", nil];
   
    [AppUtil showHudInView:self.view tag:10003];
    
    [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        [AppUtil hideHudInView:self.view mtag:10003];
        [header endRefreshing];
        [footer endRefreshing];
        
        if (response.err == 1) {
            
            NSLog(@"%@",response.result);
            if (refreshing) {
                
                [_coffeeVenuesArr removeAllObjects];
            }
            
            
            [_coffeeVenuesArr addObjectsFromArray:response.result];
            
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [AppUtil hideHudInView:self.view mtag:10003];
        [header endRefreshing];
        [footer endRefreshing];
        NSLog(@"Error: %@", error);
    }];
}

- (void)veneusSelectVC:(VenuesSelectVC *)venuesSelectVC didSelectWithProvinceID:(NSString *)provinceID cityID:(NSString *)cityID townID:(NSString *)townID circleID:(NSString *)circleID title:(NSString *)title {
    
    ///////更新标题////
    [self updateTitle:title];

    self.keyName = nil;
    
    ////////
    page = 1;
    refreshing = YES;
    self.isSelected = YES;
    self.provinceID = provinceID;
    self.circleID = cityID;
    self.townID = townID;
    self.circleID = circleID;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString * pageStr = [NSString stringWithFormat:@"%d",page];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"shop",@"c",@"getShopByConditions",@"act",pageStr,@"page",self.provinceID,@"provinceid",self.cityID,@"cityid", nil];
    if (townID) {
        
        [parameters setValue:townID forKey:@"townid"];
    }
    
    if (circleID) {
        
        [parameters setValue:circleID forKey:@"circleid"];
    }
    
    [AppUtil showHudInView:self.view tag:10003];
    
    [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        [AppUtil hideHudInView:self.view mtag:10003];
        [header endRefreshing];
        [footer endRefreshing];
        
        if (response.err == 1) {
            
            NSLog(@"%@",response.result);
            if (refreshing) {
                
                [_coffeeVenuesArr removeAllObjects];
            }
            
            
            [_coffeeVenuesArr addObjectsFromArray:response.result];
            
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [AppUtil hideHudInView:self.view mtag:10003];
        [header endRefreshing];
        [footer endRefreshing];
        NSLog(@"Error: %@", error);
    }];
}

- (void)veneusSelectVC:(VenuesSelectVC *)venuesSelectVC isAll:(BOOL)isAll didSelectWith:(NSString *)city bussiness:(NSString *)business bus:(NSString *)bus title:(NSString *)title {
    
    if (isAll) {
    
        [self updateTitle:@"附近的咖啡厅"];
    
    }else {
        [self updateTitle:title];
    }
    
    self.keyName = nil;
    
    self.isSelected = NO;
    
    page = 1;
    refreshing = YES;
    [self getAboutData];

}

#pragma mark - Actions

- (void)backAction {
    
    if (self.isPresent) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    
    }else if(self.isRoot) {
        
        [self.slideMenuController closeMenuBehindContentViewController:self.slideMenuController.rootViewController animated:YES completion:nil];
        

    }else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)selectAction {
    
    VenuesSelectVC * venuesSelectVC = [self getStoryBoardControllerWithControllerID:@"VenuesSelectVC" storyBoardName:@"Other"];
    
    venuesSelectVC.delegate = self;
    
    [self.navigationController pushViewController:venuesSelectVC animated:YES];
}

- (IBAction)postAction:(id)sender {
    
    UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    PostLeaveWordViewController * postLeaveWordViewController = [board instantiateViewControllerWithIdentifier:@"PostLeaveWordViewController"];
    
    [self.navigationController pushViewController:postLeaveWordViewController animated:YES];
    
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
