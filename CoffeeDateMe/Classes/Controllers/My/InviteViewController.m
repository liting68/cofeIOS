//
//  InviteViewController.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/9.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "InviteViewController.h"
#import "InviteCell.h"

@interface InviteViewController ()<SWTableViewCellDelegate>
{
    NSMutableArray * actiArray;
}
@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /////////////////////NAV/////////////////////////////
    [self initNavView];
    [self forNavBeNoTransparent];
    [self initBackButton];
    
    if (self.isOther) {
        
         [self initTitleViewWithTitleString:self.titleString];
    
    
    }else
    {
           [self initSwitchVC];
    }
    

    ///////////////////////////////////////////////////
    
    self.type = 0;
    actiArray = [[NSMutableArray alloc] initWithCapacity:0];
    page = 1;
    refreshing = YES;
    [self getAboutData];
    [self initHeaderViewWithTableView:self.tableView];
    [self initFooterViewWithTableView:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    ///////////////////////////////////////////////
}

#pragma mark - 切换类别
//////选择///////////0.选择做包  1.选择右边
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
    
    return 92;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [actiArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InviteCell * inviteCell = [tableView dequeueReusableCellWithIdentifier:@"InviteCell"];
    
  
    
    NSDictionary * dic = actiArray[indexPath.row];
    
    NSLog(@"%@",dic);
    
    [inviteCell.avatarView setURL:[dic valueForKey:@"photo"] defaultImage:nil type:1];
    inviteCell.avatarView.layer.cornerRadius = 5;
    inviteCell.avatarView.layer.masksToBounds = YES;
    inviteCell.actiName.text = [dic valueForKey:@"title"];
    
    inviteCell.timeLabel.text = [dic valueForKey:@"datetime"];
    
    NSString * date = [dic valueForKey:@"dating"];
    
    if ([date isEqualToString:@"男"]) {
        
        inviteCell.dateObjectLabel.text = @"限男生";
        inviteCell.dateObjectIcon.image = TTImage(@"boy");
        
    }else if([date isEqualToString:@"女"]) {
        
        inviteCell.dateObjectLabel.text = @"限女生";
        inviteCell.dateObjectIcon.image = TTImage(@"girl");
        
    }else {
        
        inviteCell.dateObjectLabel.text = @"不限";
        inviteCell.dateObjectIcon.image = TTImage(@"buxian");
    }
    
    inviteCell.drinkIcon.image = TTImage(@"coffee_drink");
    ////////////////////
    inviteCell.drinkTitle.text = @"喝咖啡";
    //////
    
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
    
    DateSquareDetail * dateSquareDetailVC = [self getStoryBoardControllerWithControllerID:@"DateSquareDetail" storyBoardName:@"Other"];
    
    NSDictionary * dic = actiArray[indexPath.row];
    
    dateSquareDetailVC.eventID = [dic valueForKey:@"id"];
    
    [self.navigationController pushViewController:dateSquareDetailVC animated:YES];
}


#pragma mark - 获取相关数据

- (void)getAboutData {
    
    NSString * pageStr =[NSString stringWithFormat:@"%d",page];
    
 if (self.type == 0){
     
     NSNumber * userID = nil;
     
     if (self.isOther) {
         
         userID = [NSNumber numberWithInt:[self.userID intValue]];
         
     }else {
         
           userID = [[NSUserDefaults standardUserDefaults] currentMemberID];
     }
     
     
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
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"userEvent",@"c",@"myJoinEvents",@"act", userID,@"userid",pageStr,@"page",nil];
        
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
    
    NSMutableDictionary * parameters = nil;
    
    if (self.type == 0) {//我发起的
        
      parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"userEvent",@"c",@"cancelEvent",@"act",userID, @"userid",[dic valueForKey:@"id"],@"eventid",nil];
        
    }else {//我参与的
        
       parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"userEvent",@"c",@"cancelJoinEvent",@"act",userID, @"userid",[dic valueForKey:@"id"],@"eventid",nil];
    }
    
    [AppUtil showHudInView:self.view tag:10003];
    
    [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [AppUtil hideHudInView:self.view mtag:10003];
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            page = 1;
            
            refreshing = YES;
            
            [self getAboutData];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [AppUtil hideHudInView:self.view mtag:10003];
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
