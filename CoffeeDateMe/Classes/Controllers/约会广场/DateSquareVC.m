//
//  DateSquareVC.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/1/30.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "DateSquareVC.h"
#import "PostLeaveWordViewController.h"
#import "DateSquareCell.h"
#import "DateSquareDetail.h"

@interface DateSquareVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray * dateArray;
}
@end

@implementation DateSquareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self layoutContentView];
    
    dateArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    page  = 1;
    refreshing = YES;
    [self getAboutData];
    
    [self initNavView];
    [self forNavBeNoTransparent];
    [self initBackButton];///返回
    [self initTitleViewWithTitleString:@"约会广场"];
    [self initWithRightButtonWithImageName:nil title:@"发起" action:@selector(postAction)];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self hideTabBar];
}

- (void)layoutContentView {
    
    [self initHeaderViewWithTableView:_tableView];
    [self initFooterViewWithTableView:_tableView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
    
    //创建一屏的视图大小
    _tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    _tableView.collectionViewLayout = flowLayout;
    _tableView.alwaysBounceVertical = YES;
    [_tableView setUserInteractionEnabled:YES];
    [_tableView setDelegate:self]; //代理－视图
    [_tableView setDataSource:self]; //代理－数据
}

#pragma mark -

- (void)refreshingAction {
    
    [self getAboutData];
    
}
- (void)loadingingAction {
    
    [self getAboutData];
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

//定义展示的Section的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
 //   return 10;
    
    return [dateArray count];
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DateSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DateSquareCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.avatarView.layer.cornerRadius = cell.avatarView.frame.size.width/2;
    cell.avatarView.layer.borderColor = [[UIColor orangeColor] CGColor];
    cell.avatarView.layer.borderWidth = 1.0f;
    cell.avatarView.layer.masksToBounds = YES;
    
    
    cell.backImageView.layer.cornerRadius = 3;
  //  cell.avatarView.layer.borderColor = [[UIColor orangeColor] CGColor];
   // cell.avatarView.layer.borderWidth = 1.0f;
    cell.backImageView.layer.masksToBounds = YES;
    
    NSDictionary * cofeInfo = dateArray[indexPath.row];
    
    [cell.avatarView setURL:[cofeInfo valueForKey:@"photo"] defaultImage:@"default_avatar"type:0];
    
    [cell.backImageView setURLWithBlurry:[cofeInfo valueForKey:@"shop_img"] defaultImage:@"dateSquare_default" type:0];
    //[cell.backImageView setURL:[cofeInfo valueForKey:@"img"] defaultImage:@"activity" type:0];
    
    cell.nameLabel.text = [cofeInfo valueForKey:@"title"];
    
    cell.addrLabel.text = [NSString stringWithFormat:@"%@",[cofeInfo valueForKey:@"address"]];
    
    cell.layer.cornerRadius = 6;
    cell.layer.masksToBounds = YES;
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((K_UIMAINSCREEN_WIDTH - 30)/2, (K_UIMAINSCREEN_WIDTH - 30)/2);
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 10, 0, 10);
    
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
   NSDictionary * dic = dateArray[indexPath.row];
    
    NSString *eventID = [dic valueForKey:@"user_event_id"];///核实对错
    
    DateSquareDetail * productVC = [self getStoryBoardControllerWithControllerID:@"DateSquareDetail" storyBoardName:@"Other"];
    
    productVC.eventID = eventID;
    
    [self.navigationController pushViewController:productVC animated:YES];
}

#pragma mark - Action

- (void)postAction {
    
    UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    PostLeaveWordViewController * postLeaveWordViewController = [board instantiateViewControllerWithIdentifier:@"PostLeaveWordViewController"];
    
    [self.navigationController pushViewController:postLeaveWordViewController animated:YES];
}

#pragma mark -

- (void)getAboutData {
    
      AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"userEvent",@"c",@"getEvents",@"act", [NSString stringWithFormat:@"%d",page],@"page",nil];
        
        [AppUtil showHudInView:self.view tag:10003];
        
        [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [AppUtil hideHudInView:self.view mtag:10003];
            [header endRefreshing];
            [footer endRefreshing];
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            if (response.err == 1) {
                
                if (refreshing) {
                    
                    [dateArray removeAllObjects];
                }
                
                [dateArray addObjectsFromArray:[response.result valueForKey:@"events"]];
                
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
