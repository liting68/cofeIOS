//
//  MyCollectVC.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/11.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "MyCollectVC.h"
#import "MJRefresh.h"
#import "CollectionCell.h"
#import "CafeDetailVC.h"


@interface MyCollectVC ()<MJRefreshBaseViewDelegate,SWTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray * coffeeVenuesArr;

@end

@implementation MyCollectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavView];
    [self forNavBeNoTransparent];
    [self initTitleViewWithTitleString:@"我的收藏"];
    [self initBackButton];
    
    page = 1;
    refreshing = YES;
    
    [self initHeaderViewWithTableView:self.tableView];
    [self initFooterViewWithTableView:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self getMyCollectData];
}

#pragma mark - 

- (void)refreshingAction {
    
    page = 1;
    refreshing = YES;
    [self getMyCollectData];
}

- (void)loadingingAction {
    
    page = page + 1;
    refreshing = NO;
    [self getMyCollectData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_coffeeVenuesArr count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionCell * collectCell = [tableView dequeueReusableCellWithIdentifier:@"CollectionCell"];
    
      NSDictionary * cafeInfo = _coffeeVenuesArr[indexPath.row];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [collectCell.avatarView setURL:[cafeInfo valueForKey:@"img"] defaultImage:nil type:1];
        collectCell.avatarView.layer.cornerRadius = 5;
        collectCell.avatarView.layer.masksToBounds = YES;
        collectCell.venuesNameLabel.text = [cafeInfo valueForKey:@"title"];
        collectCell.axisLabel.text = [NSString stringWithFormat:@"别名:%@",[cafeInfo valueForKey:@"subtitle"]];
        collectCell.addressLabel.text = [NSString stringWithFormat:@"%@",[cafeInfo valueForKey:@"address"]];
        collectCell.likeNumberLabel.text = [NSString stringWithFormat:@"%@人喜欢",[cafeInfo valueForKey:@"num"]];
        [collectCell.likeNumberLabel sizeToFit];
        collectCell.likeNumberLabel.right = 312;
        
        collectCell.likeIcon.right = collectCell.likeNumberLabel.left - 4;
        
        collectCell.distanceLabel.text = [NSString stringWithFormat:@"%@km",[cafeInfo valueForKey:@"distance"]];
        [collectCell.distanceLabel sizeToFit];
        collectCell.distanceLabel.right = 312;
        collectCell.locaIcon.right = collectCell.distanceLabel.left - 3;
        
        [collectCell.likeNumberLabel sizeToFit];
        collectCell.likeNumberLabel.right = 307;
        collectCell.likeIcon.left = collectCell.likeNumberLabel.left - 3;
        
        collectCell.section = indexPath.section;
        collectCell.row = indexPath.row;
        
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:0.961 green:0.341 blue:0.039 alpha:1.000]
                                                    title:@""];
        
        collectCell.delegate = self;
        
        [collectCell setRightUtilityButtons:rightUtilityButtons WithButtonWidth:77.0f];

    });
    
    return collectCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    return 94;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CafeDetailVC * cafeDetailVC  = [board instantiateViewControllerWithIdentifier:@"CafeDetailVC"];
    
    NSDictionary * cafeInfo = _coffeeVenuesArr[indexPath.row];
    cafeDetailVC.cafeName = [cafeInfo valueForKey:@"title"];
    
    cafeDetailVC.cafeID = [NSString stringWithFormat:@"%@",[cafeInfo valueForKey:@"shop_id"]];
    
    [self.navigationController pushViewController:cafeDetailVC animated:YES];

}

#pragma mark - 

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    NSDictionary * dic = _coffeeVenuesArr[cell.row];
    
    NSNumber * userID = [[NSUserDefaults standardUserDefaults] currentMemberID];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"shop",@"c",@"removeFavoriteShopById",@"act",userID, @"userid",[dic valueForKey:@"shop_id"],@"shopid",nil];
    
    [AppUtil showHudInView:self.view tag:10003];
    
    [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [AppUtil hideHudInView:self.view mtag:10003];
        [header endRefreshing];
        [footer endRefreshing];
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            //[AppUtil HUDWithStr:@"取消收藏成功" View:self.view];
            
            [self getMyCollectData];
        
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [AppUtil hideHudInView:self.view mtag:10003];
        [header endRefreshing];
        [footer endRefreshing];
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - 获取数据

- (void)getMyCollectData {
    
    NSNumber * userID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    NSString *  pageStr = [NSString stringWithFormat:@"%d",page];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"shop",@"c",@"favoriteShops",@"act",userID, @"userid",pageStr,@"page",nil];
    
    [AppUtil showHudInView:self.view tag:10003];
    
    [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [AppUtil hideHudInView:self.view mtag:10003];
        [header endRefreshing];
        [footer endRefreshing];
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
           // NSLog(@"%@",response.result);
            
            if (!_coffeeVenuesArr) {
                
                _coffeeVenuesArr = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
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

#pragma mark - Memory Manage

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
