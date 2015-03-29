//
//  CafeDetailVC.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-10-1.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "CafeDetailVC.h"
#import "CommentCell.h"
#import "EvaluateCofeViewController.h"
#import "CafeMapViewController.h"
#import "UserCenterVC.h"
#import "PostLeaveWordViewController.h"
#import "ShopHeaderCell.h"
#import "UIColor+expanded.h"

@interface CafeDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray * _commentArr;///评论数组
    MenuView * _menuView;//菜单
    UIView * tagView;
    UIView * moreView;
    
    ShopHeaderCell * headerCell;
    
}
@property (nonatomic, strong)UITextView * inputView;

@end

@implementation CafeDetailVC

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
    
    //[self addNotificatons];
    
    [self initNavView];
    [self forNavBeTransparent];
    [self initBackButton];
    [self initTitleViewWithTitleString:self.cafeName];
    [self initWithRightButtonWithImageName:@"pd_more" title:nil action:@selector(moreAction)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    page = 1;
    refreshing = YES;
    [self initHeaderViewWithTableView:self.tableView];
    [self initFooterViewWithTableView:self.tableView];

    if (!_bottomView) {
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, K_UIMAINSCREEN_HEIGHT - 40, K_UIMAINSCREEN_WIDTH, 40)];
        _bottomView.backgroundColor = [UIColor colorWithWhite:0.941 alpha:1.000];
        
        _inputView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, 260, 30)];
        _inputView.backgroundColor = [UIColor whiteColor];
        _inputView.delegate = self;
        [_bottomView addSubview:_inputView];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor colorWithRed:0.522 green:0.522 blue:0.541 alpha:1.000] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:@"发送" forState:UIControlStateNormal];
        button.frame = CGRectMake(280, 5, 30, 30) ;
        [button addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:button];
                        
    }
    
  /*  UIButton * left1 = [UIButton buttonWithType:UIButtonTypeCustom];
    left1.frame = CGRectMake(7, 216, 28, 28);
    [left1 setBackgroundImage:TTImage(@"pd_collect") forState:UIControlStateNormal];
    [left1 addTarget:self action:@selector(collecAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:left1];
    
    UIButton * right1 = [UIButton buttonWithType:UIButtonTypeCustom];
    right1.frame = CGRectMake(K_UIMAINSCREEN_WIDTH - 35, 216, 28, 28);
    [right1 setBackgroundImage:TTImage(@"pd_edit") forState:UIControlStateNormal];
    [right1 addTarget:self action:@selector(leaveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:right1];*/
    
    ////数据
    _commentArr = [[NSMutableArray alloc] initWithCapacity:0];//评论存放数组
    
    [self getCafeDetailWithCafeID:self.cafeID];////获取详细信息
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBBS) name:k_CAFE_LEAVE_NOTIFICATION object:nil];
 }

- (void) initWithRightButtonWithImageName:(NSString *)imageName title:(NSString *)title action:(SEL)action {
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (imageName) {
        
        rightButton.frame = CGRectMake(265, 6 + 20, 50, 28);
        [rightButton setImage:TTImage(imageName) forState:UIControlStateNormal];
        
    }else {
        
        rightButton.frame = CGRectMake(276, 13 + 20, 44, 18);
        
        [rightButton setTitle:title forState:UIControlStateNormal];
        
        [rightButton setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
        
    }
    
    myRightButton = rightButton;
    
    
    [myNavigationView addSubview:rightButton];
    // UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    //self.navigationItem.rightBarButtonItem = rightButtonItem;
}


- (void)viewWillAppear:(BOOL)animated {
    
    [self hideTabBar];
    
    [self addNotificatons];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self removeNotifications];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
   /* [UIView animateWithDuration:0.3 animations:^{
        
        self.bottomView.top = K_UIMAINSCREEN_HEIGHT - 216 - 40;
        
    }];*/

    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
      /*  [UIView animateWithDuration:0.3 animations:^{
           
            self.bottomView.top = K_UIMAINSCREEN_HEIGHT - 40;
            
        }];*/
        
    }
    return YES;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        if (headerCell) {
            
            return headerCell;
        }
        
        ShopHeaderCell * shopHeaderViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopHeaderCell"];
        shopHeaderViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        shopHeaderViewCell.delegate = self;
        
        if (self.cafeDetailInfo) {
            
             [shopHeaderViewCell layoutWithDic:self.cafeDetailInfo];
            
             headerCell = shopHeaderViewCell;
        
        }else {
            
              [shopHeaderViewCell layoutWithDic:self.cafeDetailInfo];
        }

        return shopHeaderViewCell;
    }
    
    if (self.selectIndex == 0) {
        
        if (indexPath.row == 2){
            
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CD_Name"];
            
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel * distanceLabel = (UILabel *)[cell viewWithTag:102];
            
            if ([AppUtil isNotNull:[self.cafeDetailInfo valueForKey:@"distance"]]) {
                
                distanceLabel.text =[NSString stringWithFormat:@"%@KM",[self.cafeDetailInfo valueForKey:@"distance"]];
                
            }else {
                
                distanceLabel.text = @"0KM";
            }
            
            
            [distanceLabel sizeToFit];
            
            UILabel * cafeName = (UILabel *)[cell viewWithTag:103];
            cafeName.text = [self.cafeDetailInfo valueForKey:@"address"];
            
            return cell;
            
        }else if (indexPath.row == 1){
            
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CD_PHONE"];
            
              cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel * hintLabel = (UILabel *)[cell viewWithTag:100];
            hintLabel.text = @"电话";
        
            UILabel * cafeName = (UILabel *)[cell viewWithTag:101];
            cafeName.text = [self.cafeDetailInfo valueForKey:@"tel"];
            
            return cell;
            
        }/*else if (indexPath.row == 3){
            
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CD_PHONE"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel * hintLabel = (UILabel *)[cell viewWithTag:100];
            hintLabel.text = @"地址";
            
            UILabel * cafeName = (UILabel *)[cell viewWithTag:101];
            cafeName.text = [self.cafeDetailInfo valueForKey:@"address"];
            
            return cell;
            
        }*/else if (indexPath.row == 3){
            
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CD_INTRO"];
            
              cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel * cafeName = (UILabel *)[cell viewWithTag:100];
            cafeName.text = [self.cafeDetailInfo valueForKey:@"introduction"];
            
            cafeName.width = 296;
            
            [cafeName setNeedsDisplay];
            
            UIView * lineView = [cell viewWithTag:104];
            lineView.bottom = cafeName.height + 57;
            
            [cell setNeedsLayout];
            
            return cell;
            
        }else {
            
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CD_TAG"];
            
              cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (tagView) {//tagView为空
                
                tagView.top = 15;
                
                [cell.contentView addSubview:tagView];
            }
            
            return cell;
        }
        
    }else if (self.selectIndex == 1){
        
        if ([_commentArr count] == 0) {
            
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NO_CONTENT"];
          
            cell.backgroundColor = [UIColor clearColor];
            
            return cell;
        }
        
        if (indexPath.row == [_commentArr count] + 1) {
            
            NSDictionary * dic = _commentArr[[_commentArr count] - 1];
            
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TIME_CELL"];
            
            cell.backgroundColor = [UIColor clearColor];
            
            UILabel * label = (UILabel *)[cell viewWithTag:100];
            
            label.text = [AppUtil convertToTimeFromDateTime:[dic valueForKey:@"created"]];
        
            return cell;
        }
        
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.avatatView setConers];
    
        NSDictionary * commentDic = _commentArr[indexPath.row -1];
        
        [cell.avatatView setURL:[commentDic valueForKey:@"path"] defaultImage:@"default_avatar" type:1];
        cell.avatatView.userInteractionEnabled = YES;
        cell.avatatView.delegate = self;
        cell.avatatView.layer.masksToBounds = YES;
        cell.avatatView.layer.cornerRadius = cell.avatatView.width/2;
        
        cell.avatatView.tag = 5000 + indexPath.row;
        
        if ([AppUtil isNull:[commentDic valueForKey:@"nick_name"]]) {
           
            cell.nickName.text = @"";
       
        }else {
            cell.nickName.text = [commentDic valueForKey:@"nick_name"];
        }
        
         cell.content.text = [commentDic valueForKey:@"content"];
       // [cell.content sizeToFit];

        ////////////////
        float height;
        
        if (cell.content.height > 29) {
            
            height = 86 + cell.content.height - 29;
            
        }else {
            
            height = 86;
        }
        
        cell.lineView.top = height - 1;
        
        cell.timeLineView.bottom = height;
        
        cell.timeIcon.bottom = height;
        
        ////////////时间线
        cell.timeLineView.top = 0;
        cell.timeLineView.height = height - 1;
        
        if (indexPath.row == 1) {
            
              [cell.postTime setHidden:YES];
            
        }else {
            
            NSDictionary * dic = _commentArr[indexPath.row -2];
            
            [cell.postTime setHidden:NO];
            ///////////////////
            cell.postTime.text = [AppUtil convertToTimeFromDateTime:[dic valueForKey:@"created"]];///发布时间
        }
        
        cell.timeLineView.image = [TTImage(@"pd_timeline") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 10, 4) resizingMode:UIImageResizingModeStretch];
        
   
        
        return cell;
        
    }else {
        
        if (!_menuView || _menuView.noContent) {
            
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NO_CONTENT"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            
            return cell;
        
        }else {

            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Menu"];
            
            if (!cell) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Menu"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

                
                [cell addSubview:_menuView];
            }
            
            return cell;
            
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.selectIndex == 0) {
        
        return 5;
    
    }else if (self.selectIndex == 1){
        
        if ([_commentArr count] == 0) {
            
            return 2;
        
        }else {
            
            return [_commentArr count] + 2;///第一个是header  最后一个是 time
        }
        
    }else {
        
        return 2;
    }

}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectIndex == 0) {
        
        if(indexPath.row == 0) {
            
            return 292;
            
        }else if (indexPath.row == 1){
            
            return 50;
            
        }else if (indexPath.row == 2){
            
            return 32;
            
        }else if (indexPath.row == 3){
            
            return 32;
            
        }else if (indexPath.row == 4){
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 296, 0)];
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:13];
            label.text = [self.cafeDetailInfo valueForKey:@"introduction"];
            [label sizeToFit];
            
            return 57 + label.height;
            
        }else {
            
            if (!tagView) {
                
                return 40;
                
            }else {
                
                return 25 + tagView.height + 10;
            }
        }
        
    }else if(self.selectIndex == 1) {
        
        if(indexPath.row == 0) {
            
            return 292;
            
        }else {
            
            if([_commentArr count] == 0) {
                
                return 200;
            }
            
            if(indexPath.row == [_commentArr count] + 1) {
                
                return 17;
            }
            
            NSDictionary * commentDic = _commentArr[indexPath.row -1];
            
            NSString * content = [commentDic valueForKey:@"content"];
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(101, 0, 203, 29)];
            label.font = [UIFont systemFontOfSize:12];
            label.numberOfLines = 0;
            label.text = content;
            [label sizeToFit];
            
            if (label.height  > 29) {///
                
                return 86 + label.height - 29;
                
            }else {
                
                return 86;
            }
        }
        
    }else {
        
        
        if(indexPath.row == 0) {
            
            return 292;
            
        }else {
            
            if (!_menuView || _menuView.noContent) {
                
                return 200;
                
            }else {
                
                return 262;
              //  return _menuView.height;
            }
        }
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    if (self.selectIndex == 0) {
        
        if(indexPath.row == 0) {
            
            return 292;
            
        }else if (indexPath.row == 1){
            
            return 32;
            
        }else if (indexPath.row == 2){
            
            return 40;
            
        }else if (indexPath.row == 3){
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 296, 0)];
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:13];
            label.text = [self.cafeDetailInfo valueForKey:@"introduction"];
            [label sizeToFit];
            
            return 57 + label.height;
            
        }else {
            
            if (!tagView) {
                
                return 40;
            
            }else {
                
                return 25 + tagView.height + 10;
            }
        }

    }else if(self.selectIndex == 1) {
        
        if(indexPath.row == 0) {
            
            return 292;
            
        }else {
            
            if([_commentArr count] == 0) {
                
                return 200;
            }
            
            if(indexPath.row == [_commentArr count] + 1) {
                
                return 17;
            }
            
            NSDictionary * commentDic = _commentArr[indexPath.row -1];
            
            NSString * content = [commentDic valueForKey:@"content"];
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(101, 0, 203, 29)];
            label.font = [UIFont systemFontOfSize:12];
            label.numberOfLines = 0;
            label.text = content;
            [label sizeToFit];
            
            if (label.height  > 29) {///
                
                return 86 + label.height - 29;
                
            }else {
                
                return 86;
            }
        }
        
    }else {
        
        if(indexPath.row == 0) {
            
            return 292;
            
         }else {
            
            if (!_menuView || _menuView.noContent) {
                
                return 200;
            
            }else {
                
               return 262;
               // return _menuView.height;
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectIndex == 0) {
        
        if (indexPath.row == 1) {
            
           NSString * tel =  [self.cafeDetailInfo valueForKey:@"tel"];
            
            NSString * title = [NSString stringWithFormat:@"拨打电话:%@",tel];
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:title delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            [alertView show];
            
        }else if (indexPath.row == 2) {
            
            CafeMapViewController * cafeMapViewController = [[CafeMapViewController alloc] init];
            
            cafeMapViewController.cafeTitle = [self.cafeDetailInfo valueForKey:@"title"] ;
            
            cafeMapViewController.coordinate = CLLocationCoordinate2DMake([[self.cafeDetailInfo valueForKey:@"lat"] doubleValue], [[self.cafeDetailInfo valueForKey:@"lng"] doubleValue]);
            
            [self.navigationController pushViewController:cafeMapViewController animated:YES];
        }
        
    }
}

#pragma mark - MenuViewDelegate

- (void)menuView:(MenuView *)menuView didSelectedIndex:(int)index {
    
    NSArray * menusArr =  [self.cafeDetailInfo valueForKey:@"menus"];
    
    NSMutableArray * urls = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary * dic in menusArr) {
        
        [urls addObject:[dic valueForKey:@"img"]];
    }
    
    NSArray * tempURLS = [AppUtil getBigImage:urls];
    
    [self openImageSetWithUrls:tempURLS initImageIndex:index];
}

#pragma mark - SHopHeaderCell

- (void)shopHeaderCell:(ShopHeaderCell *)shopHeaderCell clickButtonsWithCategory:(int)category {
    
    if (self.selectIndex == category) {
        
        return;
    }
    self.selectIndex = category;
    
    if (self.selectIndex == 1) {
        
        self.bottomConstraint.constant = 40;
   
        if (![_bottomView superview]) {
            
            [self.view addSubview:_bottomView];

        }
        
    }else {
        
        self.bottomConstraint.constant = 0;
        
        if ([_bottomView superview]) {
            
            [_bottomView removeFromSuperview];
        }
    }
    [self updateViewConstraints];
    
    [self.tableView reloadData];
}

- (void)shopHeaderCell:(ShopHeaderCell *)shopHeaderCell clickShopPicsAtIndex:(int)index {
    
    NSArray * imageURLs = [self.cafeDetailInfo valueForKey:@"imgs"];
    NSArray * urls = [AppUtil getBigImage:imageURLs];
    
    [self openImageSetWithUrls:urls initImageIndex:index];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
          NSString * tel =  [self.cafeDetailInfo valueForKey:@"tel"];
        
        tel = [tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]]];
    }
}

#pragma mark - Actions

- (void)sendAction {
    
    [_inputView resignFirstResponder];
    
    NSString * message = _inputView.text;
    
    if ([AppUtil isNull:message]) {
        
        [AppUtil HUDWithStr:@"说点什么吧" View:self.view];
        
        return;
    }
    
    [self leaveWithMesage:message];
    
}

- (void)moreAction {
    
    if (!moreView) {
        
        moreView = [[UIView alloc] initWithFrame:CGRectMake(K_UIMAINSCREEN_WIDTH - 84, 64, 88, 84)];
        moreView.backgroundColor = [UIColor clearColor];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, moreView.width, 42);
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(collecAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"收藏" forState:UIControlStateNormal];
        [moreView addSubview:button];
        
        UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(0, 42, moreView.width, 42);
        button1.titleLabel.font = [UIFont systemFontOfSize:16];
        [button1 addTarget:self action:@selector(postDateAction) forControlEvents:UIControlEventTouchUpInside];
        [button1 setBackgroundImage:TTImage(@"more_cell") forState:UIControlStateNormal];
        [button1 setTitle:@"发起约会" forState:UIControlStateNormal];
         [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [moreView addSubview:button1];
        
        [moreView setHidden:YES];
        
        [self.view addSubview:moreView];
    }
    
    if (moreView.hidden == YES) {
        
        moreView.hidden = NO;
        
        //[UIView animateWithDuration:0.3 animations:^{
        //    moreView.top = -64;
      //  }];

        
    }else {
        
        moreView.hidden = YES;
        
      //  [UIView animateWithDuration:0.3 animations:^{
           // moreView.top = 64;
       // }];

    }
}

////约会
- (void)postDateAction {

    [moreView setHidden: YES];
    
    //[UIView animateWithDuration:0.3 animations:^{
      //  moreView.top = -64;
    //}];

    PostLeaveWordViewController * postLeaveWordVC = [self getStoryBoardControllerWithControllerID:@"PostLeaveWordViewController"];
    
    postLeaveWordVC.venuesSelected = self.cafeDetailInfo;
    
    [self.navigationController pushViewController:postLeaveWordVC animated:YES];

}

- (void)collecAction:(id)sender {
    
       [moreView setHidden: YES];
    
   // [UIView animateWithDuration:0.3 animations:^{
     //   moreView.top = -64;
    //}];

  NSNumber * userID =  [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    if (!userID) {
        
        [self gotoLogin];
    
    }else {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"shop",@"c",@"favorites",@"act", userID,@"userid",self.cafeID,@"shopid",nil];
        
        [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            if (response.err == 1) {
                
                [AppUtil HUDWithStr:@"收藏成功" View:self.view];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}

- (void)leaveAction:(id)sender {
    
    EvaluateCofeViewController * postLeaveWordVC = (EvaluateCofeViewController *)[self getStoryBoardControllerWithControllerID:@"EvaluateCofeViewController"];
    postLeaveWordVC.cafeID = self.cafeID;
    
    postLeaveWordVC.cateTitle = self.cafeName;
    
    [self.navigationController pushViewController:postLeaveWordVC animated:YES];
    
}

#pragma mark - super Method

- (void)loadingingAction {
    
    [self getCafeDetailWithCafeID:self.cafeID];
}

- (void)refreshingAction {
    
    [self getCafeDetailWithCafeID:self.cafeID];
}

- (void)updateBBS {
    
    page = 1;
    refreshing = YES;

    [self getCafeDetailWithCafeID:self.cafeID];
}

#pragma mark - 获取咖啡店详情

- (void)leaveWithMesage:(NSString *)message {

    NSNumber * userID =  [[NSUserDefaults standardUserDefaults] currentMemberID];

    if (!userID) {
    
        [self gotoLogin];
    
    }else {
    
      if (self.cafeID) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"shop",@"c",@"leaveMsg",@"act", userID,@"userid",self.cafeID,@"shopid",message,@"content",nil];
        
        [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            if (response.err == 1) {
                
                _inputView.text = @"";
                
                [self updateBBS];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
      }
        
  }
}

- (void)getCafeDetailWithCafeID:(NSString *)cafeID {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"shop",@"c",@"shopInfo",@"act",self.cafeID,@"shopid",[NSString stringWithFormat:@"%d",page],@"page",nil];
    
    [AppUtil showHudInView:self.view tag:10004];
    
    [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [AppUtil hideHudInView:self.view mtag:10004];
        [header endRefreshing];
        [footer endRefreshing];
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
        
            self.cafeDetailInfo = response.result;
            
           [self fillDetailVCWtihCafeData:response.result];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        [AppUtil hideHudInView:self.view mtag:10004];
        [header endRefreshing];
        [footer endRefreshing];
        NSLog(@"Error: %@", error);
    }];
}

- (void)fillDetailVCWtihCafeData:(NSDictionary *)dic {
  
    if (!self.isFirst) {
        
        self.cafeDetailInfo = dic;
        
        self.isFirst = YES;
        
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"MenuView" owner:nil options:nil];
        _menuView = [nibView objectAtIndex:0];
        [_menuView layoutMenuView:self.cafeDetailInfo];
        _menuView.delegate = self;
        
        [self layoutWithTagViews];
    }
    
    if (refreshing) {//评论
        
        [_commentArr removeAllObjects];
    }
    
    [_commentArr addObjectsFromArray:[dic valueForKey:@"bbs"]];
    
    [self.tableView reloadData];
}

- (void)layoutWithTagViews {
    
    NSArray * features = [self.cafeDetailInfo valueForKey:@"features"];////特色
    
    if ([AppUtil isNotNull:features] && [features count] > 0) {
        
        tagView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, 0)];
        
        for (int index = 0; index < [features count]; index ++) {
            
            NSString * feature = features[index];
            
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12 + (index % 4) * 77, 25 + (index / 4) * 32 , 20, 20)];
            imageView.image = TTImage(@"shop_detail_icon");
            [tagView addSubview:imageView];
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 2, imageView.top, 60, 20)];
            label.text = feature;
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor colorWithWhite:0.298 alpha:1.000];
            [tagView addSubview:label];
        }
        tagView.height = 25 + (([features count] % 4 == 0)? ([features count] / 4 * 32):(([features count] / 4 + 1) * 32));
    }
}

#pragma mark - cafeDetailHeaderViewDelegate

- (void)cafeDetailHeaderViewDidGotoMap {
    
    CafeMapViewController * cafeMapViewController = [[CafeMapViewController alloc] init];
    
    cafeMapViewController.cafeTitle = [self.cafeDetailInfo valueForKey:@"title"] ;
    
    
    cafeMapViewController.coordinate = CLLocationCoordinate2DMake([[self.cafeDetailInfo valueForKey:@"lat"] doubleValue], [[self.cafeDetailInfo valueForKey:@"lng"] doubleValue]);
    
    [self.navigationController pushViewController:cafeMapViewController animated:YES];

}

- (void)cafeDetailCafeViewClickCafeAvatarView {
    
    NSArray * imageURLs = [self.cafeDetailInfo valueForKey:@"imgs"];
    
    NSArray * urls = [AppUtil getBigImage:imageURLs];
    
    [self openImageSetWithUrls:urls initImageIndex:0];
    
}

- (void)cafeDetailHeaderViewClickCaiDanMenuWithIndex:(int)index {
    
    NSArray * menusArr =  [self.cafeDetailInfo valueForKey:@"menus"];
    
    NSMutableArray * urls = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary * dic in menusArr) {
        
        [urls addObject:[dic valueForKey:@"img"]];
    }
    
    NSArray * tempURLS = [AppUtil getBigImage:urls];
    
    [self openImageSetWithUrls:tempURLS initImageIndex:0];

}

#pragma mark - WTURLImageViewDelegate

- (void)URLImageViewDidClicked:(WTURLImageView *)imageView {
    
    if (![self checkLogin]) {
        
        return;
    }
   
    NSDictionary * cafeInfo = _commentArr[imageView.tag - 5000 - 1];
    
    NSString * nickName = nil;
    
    if ([AppUtil isNull:[cafeInfo valueForKey:@"nick_name"]]) {
        
         nickName = @"";
    }else{
      
         nickName = [cafeInfo valueForKey:@"nick_name"];
    }
    
    NSString * user_id = [cafeInfo valueForKey:@"user_id"];
    
    UserCenterVC * userCenter = [self getStoryBoardControllerWithControllerID:@"UserCenterVC" storyBoardName:@"Other"];
    userCenter.otherID = user_id;
    userCenter.nickName = nickName;
    [self.navigationController pushViewController:userCenter animated:YES];
}

#pragma mark -
// 键盘将要显示通知

-(void) emojiKeyboardWillShow:(NSNotification *)note{
    
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = _bottomView.frame;
    
    containerFrame.origin.y = K_UIMAINSCREEN_HEIGHT - (keyboardBounds.size.height + containerFrame.size.height);
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    _bottomView.frame = containerFrame;
    [UIView commitAnimations];
}

// 键盘将要隐藏通知

-(void) emojiKeyboardWillHide:(NSNotification *)note{
    
    [UIView animateWithDuration:0.3 animations:^{
     
        _bottomView.top = K_UIMAINSCREEN_HEIGHT - 40;
        
    }];
    
}


#pragma mark - Memory Manage


- (void)addNotificatons {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(emojiKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(emojiKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)removeNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification object:nil];
    
}



- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_CAFE_LEAVE_NOTIFICATION object:nil];
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
