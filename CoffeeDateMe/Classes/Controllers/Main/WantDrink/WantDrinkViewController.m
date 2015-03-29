//
//  WantDrinkViewController.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-9-29.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "WantDrinkViewController.h"
#import "WantDrinkSubView.h"
#import "A3GridTableView.h"
#import "UserCenterVC.h"
#import "WantDrinkSelectedVC.h"
#import "MJRefreshConst.h"

@interface WantDrinkViewController ()<A3GridTableViewDataSource, A3GridTableViewDelegate,WantDrinkSelectedVCDelegate>{
   
    NSMutableArray * wantDrinkArray;
    WantDrinkSelectedVC * wantDrinkSelectedVC;
    A3GridTableView *gridTableView;
}
@property (nonatomic,readwrite) int currentPage;
@end

@implementation WantDrinkViewController

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
    
   /* self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, K_UIMAINSCREEN_HEIGHT)];
    self.bgView.backgroundColor = [UIColor colorWithRed:0.845 green:0.843 blue:0.865 alpha:1.000];
    [self.view addSubview:self.bgView];*/
    
    //初始化瀑布流
    gridTableView = [[A3GridTableView alloc] initWithFrame:CGRectMake(0, 64, K_UIMAINSCREEN_WIDTH, K_UIMAINSCREEN_HEIGHT - 64)];
    gridTableView.delegate = self;
    gridTableView.dataSource = self;
    [self.view addSubview:gridTableView];
    [self initHeaderViewWithTableView:gridTableView];
    [self initFooterViewWithTableView:gridTableView];
    
    _tempImageView = [[WTURLImageView alloc] init];
    //////////////////////////////////////
    [self initNavView];
    [self forNavBeNoTransparent];
    [self initBackButton];
    [self initWithRightButtonWithImageName:nil title:@"筛选" action:@selector(selectAction)];
    [self initTitleViewWithTitleString:@"附近爱喝咖啡的人"];
    
    
//    [self initHeaderViewWithTableView:gridTableView];
//    [self initFooterViewWithTableView:gridTableView];
    
    page = 1;
    refreshing = YES;
    [self getNebWantDrinkCoffees];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self hideTabBar];
}

- (void)reloadViews {
    
    if (!_noDataLabel) {
        
        _noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, K_UIMAINSCREEN_WIDTH, 40)];
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        _noDataLabel.text = @"抱歉,暂无您要的结果";
        _noDataLabel.textColor= MJRefreshLabelTextColor;
        _noDataLabel.font = [UIFont boldSystemFontOfSize:13];
        [self.view addSubview:_noDataLabel];
    }
        
    if ([wantDrinkArray count] == 0) {
        
        [_noDataLabel setHidden:NO];
       
        gridTableView.frame = CGRectMake(0, 104, K_UIMAINSCREEN_WIDTH, K_UIMAINSCREEN_HEIGHT - 104);
        
        
    }else {

        [_noDataLabel setHidden:YES];
        
      //  [footer setHidden:NO];
        
         gridTableView.frame = CGRectMake(0, 64, K_UIMAINSCREEN_WIDTH, K_UIMAINSCREEN_HEIGHT - 64);
    }
    
}

#pragma mark -

- (void)refreshingAction {
    
      [self getNebWantDrinkCoffees];
}

- (void)loadingingAction {
    
      [self getNebWantDrinkCoffees];
}

#pragma mark - A3GridDelegate & DataSource

- (void)A3GridTableView:(A3GridTableView *)gridTableView didSelectCellAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![self checkLogin]) {
        
        return;
    }
    
    
//    if (indexPath.row == 0 && indexPath.section == 0) {
        
     //   return;
 //   }
    
    if (2 * indexPath.row + indexPath.section >= [wantDrinkArray count]) {
     
        return;
    }
    
    
   // NSLog(@"text:%ld %ld %d %d",(long)indexPath.section, (long)indexPath.row,2 * indexPath.section + indexPath.row,2 * indexPath.row + indexPath.section);

    ///section 代表第几列
    //row 代表第几行
    

    NSDictionary * wantDrinkInfo = wantDrinkArray[2 * indexPath.row + indexPath.section];
    
    
    UserCenterVC * userCenter = [self getStoryBoardControllerWithControllerID:@"UserCenterVC" storyBoardName:@"Other"];
    userCenter.otherID = [wantDrinkInfo valueForKey:@"id"];
    
    if ([AppUtil isNotNull:[wantDrinkInfo valueForKey:@"nick_name"]]) {
        userCenter.nickName = [wantDrinkInfo valueForKey:@"nick_name"];
    }else{
        userCenter.nickName = [wantDrinkInfo valueForKey:@"user_name"];
    }

    [self.navigationController pushViewController:userCenter animated:YES];
    
}

// Data handling
- (NSInteger)numberOfSectionsInA3GridTableView:(A3GridTableView *)aGridTableView{//多少列
    
    return 2;
}

- (NSInteger)A3GridTableView:(A3GridTableView *) aGridTableView numberOfRowsInSection:(NSInteger) section{//多少行
    
    
    int totalNum = (int)[wantDrinkArray count]; //+ 1;
    
    return (totalNum % 2 == 0)?(totalNum / 2): (totalNum/2 + 1);
}


- (CGFloat)A3GridTableView:(A3GridTableView *)aGridTableView widthForSection:(NSInteger)section{

        return 155;
    
}

- (CGFloat)A3GridTableView:(A3GridTableView *)aGridTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(2 * indexPath.row + indexPath.section < [wantDrinkArray count]) {
        
        return [self getHightWithIndex:indexPath] + 10;


    }else {
        
        return 0;
    }
}

- (CGFloat) getHightWithIndex:(NSIndexPath *)indexPath {
    

        NSDictionary * wantDrinkDic =  wantDrinkArray[2 * indexPath.row + indexPath.section];
        
        NSString * headPhoto = [wantDrinkDic valueForKey:@"head_photo"];
        
        if ([AppUtil isNull:headPhoto]) {
            
            return 150;
            
        }else {
            
            UIImage * image = [self.tempImageView getImageWithURL:headPhoto];
            
            if (!image) {
                
                return 150;
                
            }else{
                
                return (image.size.height * 145) * 1.0/image.size.width ;
                
            }
        }
}


- (A3GridTableViewCell *)A3GridTableView:(A3GridTableView *)aGridTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    A3GridTableViewCell *cell;
   
    cell = [aGridTableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (!cell) {
      
        cell = [[A3GridTableViewCell alloc] initWithReuseIdentifier:@"cellID"];
    }
    
    for (UIView * view in cell.subviews) {
        
        [view removeFromSuperview];
   }
    
    if (2 * indexPath.row + indexPath.section < [wantDrinkArray count]) {
            
        NSDictionary * wantDrinkDic =  wantDrinkArray[2 * indexPath.row + indexPath.section];
            
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"WantDrinkSubView" owner:nil options:nil];
        
        WantDrinkSubView *  wantDrinkView = [nibView objectAtIndex:0];
        
        wantDrinkView.frame = CGRectMake(10, 10, 145, [self getHightWithIndex:indexPath]);
        
        [wantDrinkView layoutWithData:wantDrinkDic];
    
        //////////////////////////////
        NSString * headPhoto = [wantDrinkDic valueForKey:@"head_photo"];
        
        if ([AppUtil isNotNull:headPhoto]) {
            
            NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:headPhoto]];
            
            [ wantDrinkView.avatarView setURLRequest:request fillType:UIImageResizeFillTypeFillIn options:WTURLImageViewOptionTransitionCrossDissolve | WTURLImageViewOptionShowActivityIndicator placeholderImage:TTImage(@"default_avatar") failedImage:TTImage(@"default_avatar") diskCacheTimeoutInterval:1.0 success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                
                [self performSelectorOnMainThread:@selector(updateHeight) withObject:nil waitUntilDone:NO];
                
            }];
        }
        //////////////////////////////////
        
        [cell addSubview:wantDrinkView];
    }
    
    return cell;
}

- (void)updateHeight {
    
    [gridTableView reloadData];
}

#pragma mark - 筛选

- (void)selectAction {
    
    if (!wantDrinkSelectedVC) {
        
        wantDrinkSelectedVC = [self getStoryBoardControllerWithControllerID:@"WantDrinkSelectedVC" storyBoardName:@"Other"];
        
        wantDrinkSelectedVC.delegate = self;
        
        wantDrinkSelectedVC.type = 0;
    }
    
    [wantDrinkSelectedVC initWithType:self.type];
    
    [self.navigationController pushViewController:wantDrinkSelectedVC animated:YES];
}

#pragma mark - 获取附近想和咖啡的人

- (void)getNebWantDrinkCoffees {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
    NSMutableDictionary *parameters = nil;
    
   NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    if (self.type == 0) {
        
         parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"contact",@"c",@"nearUsers",@"act",[NSString stringWithFormat:@"%d",page],@"page",memberID,@"userid",nil];
    
    }else {
        
        parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"contact",@"c",@"getUsersByConditions",@"act",[NSString stringWithFormat:@"%d",self.type],@"type",[NSString stringWithFormat:@"%d",page],@"page",memberID,@"userid",nil];

    }
    
        [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [header endRefreshing];
            [footer endRefreshing];
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            if (response.err == 1) {
                
               // NSLog(@"%@",responseObject);
                
                if (!wantDrinkArray) {
                    
                    wantDrinkArray = [[NSMutableArray alloc] initWithCapacity:0];
                }
                
                if (refreshing) {
                    
                      [wantDrinkArray removeAllObjects];
                }
                
                [wantDrinkArray addObjectsFromArray:response.result
                 ];
                
                [self reloadViews];
                
                [gridTableView reloadData];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [header endRefreshing];
            [footer endRefreshing];
            NSLog(@"Error: %@", error);
        }];
}

#pragma mark - WantDrinkSelectedVCDelegate

- (void)wantDrinkSelectedVC:(WantDrinkSelectedVC *)wantDrinkSelectedVC didSelectedType:(int)type {

    self.type = type;
    
    page = 1;
    refreshing = YES;
    
    if (self.type == 0) {
        
        [self updateTitle:@"附近爱喝咖啡的人"];
        //[self initTitleViewWithTitleString:@"附近的人"];
        
    }else if (self.type == 1) {
        
         [self updateTitle:@"附近爱喝咖啡的人(女)"];
       // [self initTitleViewWithTitleString:@"附近的人(女)"];
    
    }else if (self.type == 2){
        
          [self updateTitle:@"附近爱喝咖啡的人(男)"];
       //  [self initTitleViewWithTitleString:@"附近的人(男)"];
        
    }else if (self.type == 3) {
        
         [self updateTitle:@"附近爱喝咖啡的人(同籍)"];
       // [self initTitleViewWithTitleString:@"附近的人(同籍)"];
    }
    
    [self getNebWantDrinkCoffees];
    
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
