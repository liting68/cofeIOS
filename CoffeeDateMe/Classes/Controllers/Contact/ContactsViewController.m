//
//  ContactsViewController.m
//  IMApp
//
//  Created by chen on 14/7/20.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "ContactsViewController.h"
#import "MessageViewController.h"
#import "WTURLImageView.h"
#import "UserCenterVC.h"
#import "SWTableViewCell.h"
#import "ContactCell.h"
#import "Ccell.h"
#import "AvatarView.h"
#import "AddContactVC.h"

@interface ContactsViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,UISearchDisplayDelegate,UIAlertViewDelegate,SWTableViewCellDelegate>
{
    UITableView *_tableV;//
    UITableView *_indexTableView;//

    UIView *_tableHeaderV;
    UISearchBar *_searchB;
    MySearchDisplayController *_searchDisplayC;
    
    NSArray *_arMenuData;
    
    NSMutableDictionary * allGroups;
}

@end

@implementation ContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    self.view.backgroundColor = [UIColor whiteColor];
    
      _searchB = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64,self.view.width, 44)];
     [_searchB setBackgroundColor:[UIColor colorWithWhite:0.929 alpha:1.000]];
     [_searchB setPlaceholder:@"输入关键词"];
     [_searchB setSearchBarStyle:UISearchBarStyleDefault];
    
    _searchDisplayC = [[MySearchDisplayController alloc] initWithSearchBar:_searchB contentsController:self];
   
    _searchDisplayC.active = NO;
    _searchDisplayC.delegate = self;
    _searchDisplayC.searchResultsDataSource = self;
    _searchDisplayC.searchResultsDelegate = self;
   [ _searchDisplayC.searchResultsTableView registerNib:[self getNibWithName:@"Ccell"] forCellReuseIdentifier:@"Ccell"];
    [self.view addSubview:_searchDisplayC.searchBar];
    
  //   _tableHeaderV = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.width, 106)];
    //[_tableHeaderV setBackgroundColor:[UIColor whiteColor]];
   
    _contactsDic = [AppUtil readDataWithPlistName:@"contacts.plist" cat:[NSDictionary dictionary]];
    
    allGroups = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                    @"#",@"0",
                    @"a",@"1",
                    @"b",@"2",
                    @"c",@"3",
                    @"d",@"4",
                    @"e",@"5",
                    @"a",@"1",
                    @"a",@"1",
                    @"f",@"6",
                    @"g",@"7",
                    @"h",@"8",
                    @"i",@"9",
                    @"j",@"10",
                    @"k",@"11",
                    @"l",@"12",
                    @"m",@"13",
                    @"n",@"14",
                    @"o",@"15",
                    @"p",@"16",
                    @"q",@"17",
                    @"r",@"18",
                    @"s",@"19",
                    @"t",@"20",
                    @"u",@"21",
                    @"v",@"22",
                    @"w",@"23",
                    @"x",@"24",
                    @"y",@"25",
                    @"z",@"26"
                        , nil];

    if (self.isRoot) {
        
           _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchB.bottom, self.view.width - 20, self.view.height - _searchB.bottom) style:UITableViewStylePlain];
        
    }else{
        
           _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchB.bottom, self.view.width - 20, self.view.height - _searchB.bottom - 49) style:UITableViewStylePlain];
    }
    
    /////////////////////////////
 
    [_tableV registerNib:[self getNibWithName:@"Ccell"] forCellReuseIdentifier:@"Ccell"];
    _tableV.dataSource = self;
    _tableV.delegate = self;
    [_tableV setBackgroundColor:[UIColor whiteColor]];
    UIView * view = [UIView new];
    _tableV.tableFooterView = view;
    [self.view addSubview:_tableV];
    [self initHeaderViewWithTableView:_tableV];
    ///////////////////////////////
    
    if (self.isRoot) {
        
        /////////////////////////////
        _indexTableView = [[UITableView alloc] initWithFrame:CGRectMake(K_UIMAINSCREEN_WIDTH - 20, _searchB.bottom, 20, self.view.height - _searchB.bottom) style:UITableViewStylePlain];

        
    }else {
        
        /////////////////////////////
        _indexTableView = [[UITableView alloc] initWithFrame:CGRectMake(K_UIMAINSCREEN_WIDTH - 20, _searchB.bottom, 20, self.view.height - _searchB.bottom - 49) style:UITableViewStylePlain];

    }
    
     _indexTableView.backgroundColor = [UIColor whiteColor];
    _indexTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _indexTableView.dataSource = self;
    _indexTableView.delegate = self;
    [self.view addSubview:_indexTableView];

    ////////////////////////////////////////////////////////////////
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNewestData ) name:K_LOGIN_NOTIFICATION object:nil];//登录
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNewestData ) name:K_UPDATE_CONTACTS object:nil];//关注,拉黑
    
    //////////
    [self initNavView];
//    [self initBackButton];
    [self forNavBeNoTransparent];
  //   [self initLeftBarButtonItem:@"common_list" title:nil action:@selector(listAction)];
    [self initTitleViewWithTitleString:@"好友"];
    [self initWithRightButtonWithImageName:@"Message_add" title:nil action:@selector(addAction)];
  
   
    /////////////////////////////
    ///////////////
    
    [self updateNewestData];
}

#pragma mark - util

- (UINib *)getNibWithName:(NSString *)nibName {
    
    UINib * cellNib = [UINib nibWithNibName:nibName bundle:nil];
    
    return cellNib;
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (self.navigationController.topViewController == self) {
        
        [self showTabBar];
    }
    
    [self getNewFocusCounts];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self hideTabBar];
}

#pragma mark - 获取数据

- (void)updateNewestData {
    
    [self getAllContacts];

}

#pragma mark - SWTableCellDelegate 
/*
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    NSArray * users = [_contactsArr[cell.section] valueForKey:@"users"];
    NSDictionary * user = users[cell.row];
    
    DevideGroupViewController * devideGroupVC = [self getStoryBoardControllerWithControllerID:@"DevideGroupViewController"];
    devideGroupVC.oldIndexPath = [NSIndexPath indexPathForRow:cell.row inSection:cell.section];
    devideGroupVC.delegate = self;
    
    devideGroupVC.allGroups = self.contactsArr;
    if ([AppUtil isNotNull:@"user_id"]) {
          devideGroupVC.userID = [user valueForKey:@"user_id"];
    }
    
    if ([AppUtil isNotNull:@"nick_name"]) {
        devideGroupVC.userName = [user valueForKey:@"nick_name"];
    }

    [self.navigationController pushViewController:devideGroupVC animated:YES];
    
}*/

#pragma mark - DevideVCDelegate
/*
- (void)editSuccessWithOldIndexRow:(NSIndexPath *)indexPath newSection:(int)section  newGroupInfo:(NSDictionary *)dic{
   
    NSDictionary * oldGroup = [dic valueForKey:@"group_old"];
    
    NSDictionary * newGroup = [dic valueForKeyPath:@"group_new"];
    
    _contactsArr[indexPath.section] = oldGroup;
    
    _contactsArr[section] = newGroup;
    
    [AppUtil saveDataWithObject:_contactsArr plistName:@"contacts.plist"];//每次修改数据都要写入缓存
    
   NSMutableIndexSet * indexSet = [NSMutableIndexSet indexSet];
    [indexSet addIndex:indexPath.section];
    [indexSet addIndex:section];
    [_tableV reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    
    NSNumber * memebrID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString * oldID = [NSString stringWithFormat:@"%@",[_contactsArr[indexPath.section] valueForKey:@"id"]];
    NSString * newID = [NSString stringWithFormat:@"%@",[_contactsArr[section] valueForKey:@"id"]];
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"contact",@"c",@"myGroupWithUsers",@"act",memebrID,@"userid",[NSString stringWithFormat:@"%@,%@",oldID,newID],@"groupid", nil];
    
    [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [header endRefreshing];
        
        NSLog(@"%@",responseObject);
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
   
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [header endRefreshing];
        NSLog(@"Error: %@", error);
    }];
}*/

#pragma mark - action

#pragma mark - Super Method

- (void)listAction {
    
    if ([self.getSlideMenuVC isMenuOpen]){
        
        [self.getSlideMenuVC closeMenuAnimated:YES completion:nil];
        
    }else {
        
        [self.getSlideMenuVC openMenuAnimated:YES completion:nil];
        
    }
}


- (void)addAction {
    
    AddContactVC * addContactVC = [self getStoryBoardControllerWithControllerID:@"AddContactVC" storyBoardName:@"Other"];
    [self.navigationController pushViewController:addContactVC animated:YES];
}

- (void)addGroup {
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"请输入新添加的分组名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.delegate = self;
    [alertView show];
}


- (void)editB:(UIButton *)btn {
    
    NSLog(@"tag:%d",btn.tag);
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"请输入修改的分组名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = btn.tag;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.delegate = self;
    [alertView show];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _indexTableView) { ///右边
        
        return 1;
    }
    
    ////////////////////////////////////////////////////////////////////
    if (tableView == _searchDisplayC.searchResultsTableView)
    {
        return 1;
    }

    /////////
    return 27 + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == _indexTableView) {
        
        return 27;
    }
    
    if (tableView == _searchDisplayC.searchResultsTableView)
    {
        return [_searchResults count];
    }
  
    if (section == 0) {
        
        return 2;
    
    }else if(section == 1){
        
       NSArray * contacts = [_contactsDic valueForKey:@"other"];
        
        return [contacts count];
      
    }else {
        
        NSString * sectionStr = [NSString stringWithFormat:@"%d",section - 1];
        
        NSString * key = [allGroups valueForKey:sectionStr];
        
        NSArray * contacts = [_contactsDic valueForKey:key];
        
        return [contacts count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _indexTableView) {
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
            cell.backgroundColor = [UIColor clearColor];
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0,0 , 20, _indexTableView.height / 27)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor colorWithWhite:0.773 alpha:1.000];
            label.tag = 200;

            [cell.contentView addSubview:label];
            
        }
        
        NSString * sectionStr = [NSString stringWithFormat:@"%d",indexPath.row];
        
        UILabel * label = (UILabel *)[cell viewWithTag:200];
        NSString * hintStr =  [allGroups valueForKey:sectionStr];
        hintStr = [hintStr uppercaseString];
        label.text = hintStr;
        
        return cell;
        
    }
    
    
    
    if (indexPath.section == 0 && tableView == _tableV) {
        
          Ccell * cell = [tableView dequeueReusableCellWithIdentifier:@"Ccell"];
        
        if (indexPath.row == 0) {
            
            cell.iconView.image = TTImage(@"friend_like");
            cell.likeLabel.text = @"我喜欢的人";
        
        }else {
            
            cell.iconView.image = TTImage(@"friend_likeme");
            cell.likeLabel.text = @"喜欢我的人";
            
        }
        
        return cell;
    }
    
    NSString *reuseIdentifier = @"cell";
   
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!cell)
    {
        cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
        int w = tableView.width/6;
        UIImage *i = [UIImage imageNamed:@"default_avatar"];//default image
        AvatarView *iv = [[AvatarView alloc] initWithFrame:CGRectMake(10, (50 - w + 15)/2, w - 15, w - 15)];
        [iv setConers];
        iv.layer.masksToBounds = YES;
        iv.layer.cornerRadius = iv.width/2;
        iv.layer.borderWidth = 1.0;
        iv.layer.borderColor = [[UIColor whiteColor] CGColor];
        [iv setImage:i];
        iv.tag = 1;
        [cell.contentView addSubview:iv];
        
        UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(w + 5, 0, w*4 - 5, 30)];
        [nameL setBackgroundColor:[UIColor clearColor]];
        [nameL setTextAlignment:NSTextAlignmentNatural];
        [nameL setFont:[UIFont systemFontOfSize:18]];
        nameL.tag = 2;
        [cell.contentView addSubview:nameL];
        
      // UILabel *stateL = [[UILabel alloc] initWithFrame:CGRectMake(w + 5, 25, w*4 - 5, 20)];
       // [stateL setBackgroundColor:[UIColor clearColor]];
       // [stateL setFont:[UIFont systemFontOfSize:12]];
      // [stateL setTextColor:[UIColor grayColor]];
       // stateL.tag = 3;
        //[stateL setText:@"[离线]这家伙，什么也没有留下"];
      //  [cell.contentView addSubview:stateL];
        
     /*   UIImageView * sexBg = [[UIImageView alloc] initWithFrame:CGRectMake(K_UIMAINSCREEN_WIDTH - 40, nameL.top + 7, 35, 14)];
        sexBg.image = TTImage(@"sex_tag.png");
        [cell.contentView addSubview:sexBg];*/
        
       // UIImageView * segFlag = [[UIImageView alloc] initWithFrame:CGRectMake(K_UIMAINSCREEN_WIDTH - 36, 17, 26, 15)];
       // segFlag.tag = 4;
       // segFlag.image = TTImage(@"nan");
        //[cell.contentView addSubview:segFlag];
        //[sexBg addSubview:segFlag];
        
        
   //     NSMutableArray *rightUtilityButtons = [NSMutableArray new];
     //   [rightUtilityButtons sw_addUtilityButtonWithColor:
       //\  [UIColor colorWithRed:0.509 green:0.322 blue:0.158 alpha:1.000]
                                                //    title:@"移动好友至"];
        
         //[cell setRightUtilityButtons:rightUtilityButtons WithButtonWidth:140.0f];
    
       // cell.delegate = self;
    }
    
    cell.section = indexPath.section;
 
    cell.row = indexPath.row;
    
    NSDictionary * contactDic;
    
    if (tableView == _searchDisplayC.searchResultsTableView)
    {
       contactDic = _searchResults[indexPath.row];
        
    }else {
        
        if (indexPath.section == 1) {
            
            NSArray * contacts = [_contactsDic valueForKey:@"other"];
            
               contactDic = contacts[indexPath.row];
            
        }else {
            
            NSString * sectionStr = [NSString stringWithFormat:@"%d",indexPath.section - 1];
            
            NSString * key = [allGroups valueForKey:sectionStr];
            
            NSArray * contacts = [_contactsDic valueForKey:key];
            
             contactDic = contacts[indexPath.row];
        }
    }
    
    AvatarView * iv = (AvatarView *)[cell.contentView viewWithTag:1];
    [iv setURL:[contactDic valueForKey:@"head_photo"] defaultImage:@"default_avatar" type:1];
    
    UILabel *nameL = (UILabel *)[cell.contentView viewWithTag:2];
    
    if ([AppUtil isNotNull:[contactDic valueForKey:@"nick_name"]]) {
        
          nameL.text = [contactDic valueForKey:@"nick_name"];
    
    }else {
        
        nameL.text = @"";
    }
    //else {
        
       // nameL.text =[contactDic valueForKey:@"user_name"];
   // }

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView == _indexTableView) {
        
        return nil;
    }
    
    /////////////////
    
    if (section == 0) {
     
        return nil;
    
    }else {
        
        NSString * sectionStr = [NSString stringWithFormat:@"%ld",(long)section - 1];
        
        NSString * key = nil;
        
        if ([sectionStr intValue] == 0) {
            
             key = @"other";
            
        }else{
            
            key = [allGroups valueForKey:sectionStr];
        }
        
        NSArray * arr = [_contactsDic valueForKey:key];
        
        if ([arr count] > 0) {
            
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, 18)];
            view.backgroundColor = [UIColor colorWithWhite:0.886 alpha:1.000];
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(14, 2, 20, 14)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
            label.font = [UIFont systemFontOfSize:14];
            
            if (section == 0) {
                
                label.text = @"#";
                
            }else {
                
                 label.text = [[allGroups valueForKey:sectionStr] uppercaseString];
            }
            
           
            [view addSubview:label];
            
            return view;

        }else {
            
            return nil;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView == _indexTableView) {
        
        return 0;
    }
    
    if (section == 0) {
        
        return 0;
    
    }else {
        
        NSString * sectionStr = [NSString stringWithFormat:@"%d",section - 1];
        
        NSString * keyName = nil;
        
        if ([sectionStr intValue] == 0) {
            
             keyName = @"other";
        
        }else {
            
            keyName = [allGroups valueForKey:sectionStr];
        }
        
        NSArray * arr = [_contactsDic valueForKey:keyName];
        
        if ([arr count] > 0) {
            
            return 18;
            
        }else {
         
            return 0;
        }
    }
}

#pragma mark - UIAlertViewDelegate
/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        if (alertView.tag >= 8000) {
            
            UITextField *tf = [alertView textFieldAtIndex:0];
            NSString * groupName = tf.text;
            
            if ([AppUtil isNull:groupName]) {
                
                return;
                
            }

            int tag = alertView.tag - 8000;
            
            NSDictionary * sectionDic = _contactsArr[tag];
            
            NSString * groupID = [sectionDic valueForKey:@"id"];
            
            [self ModGroupWithGroupName:groupName groupID:groupID section:tag];
        
        }else {
            
            UITextField *tf = [alertView textFieldAtIndex:0];
            NSString * groupName = tf.text;
            
            if ([AppUtil isNotNull:groupName]) {
                
                [self createGroupWithGroupName:groupName];
                
            }
        }
    }
}*/

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _indexTableView) {
        
        return _indexTableView.height/27;
    }
    
    if (indexPath.section == 0 && tableView == _tableV) {
        
        return 50;
    
    }else {
        
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(tableView == _indexTableView) {
        
        NSString * value = [allGroups valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        
        NSArray * contact = [self.contactsDic valueForKey:value];
        
        if ([contact count] > 0) {
            
            NSIndexPath * gIndexPath = [NSIndexPath indexPathForItem:0 inSection:indexPath.row + 1];
            
            [_tableV  scrollToRowAtIndexPath:gIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            return;
            
        }else {
            
            return;
        }
    
    }
    
    NSDictionary * userDic;
    
    if (tableView == _searchDisplayC.searchResultsTableView)
    {
      
        userDic = _searchResults[indexPath.row];
      
        UserCenterVC * otherUserViewController = [self getStoryBoardControllerWithControllerID:@"UserCenterVC" storyBoardName:@"Other"];
        
        otherUserViewController.otherID = [userDic valueForKey:@"user_id"];
        
        if ([AppUtil isNotNull:[userDic valueForKey:@"nick_name"]]) {
            otherUserViewController.nickName = [userDic valueForKey:@"nick_name"];
        }else{
            otherUserViewController.nickName = @"";
        }
        [self.navigationController pushViewController:otherUserViewController animated:YES];
        
    }else {
        
        
        if (indexPath.section == 0) {
            
            ///////////////////////////////////
            UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController * messageViewController = [board instantiateViewControllerWithIdentifier:@"MessageViewController"];
            
            if (indexPath.row == 0) {
                
                messageViewController.type = 1;
                
            }else  {
                
                messageViewController.type = 2;
                
            }
            
            [self.navigationController pushViewController:messageViewController animated:YES];
            
        }else {
        
            NSString * sectionStr = [NSString stringWithFormat:@"%d",indexPath.section - 1];
            
           
            NSString * keyName = nil;
           
            if (indexPath.section == 1) {
                
                keyName = @"other";
            
            }else {
                
                keyName = [allGroups valueForKey:sectionStr];
            }
            
            userDic = [_contactsDic valueForKey:keyName][indexPath.row];
            
            UserCenterVC * otherUserViewController = [self getStoryBoardControllerWithControllerID:@"UserCenterVC" storyBoardName:@"Other"];
            
            otherUserViewController.otherID = [userDic valueForKey:@"user_id"];
            
            if ([AppUtil isNotNull:[userDic valueForKey:@"nick_name"]]) {
                otherUserViewController.nickName = [userDic valueForKey:@"nick_name"];
            }else{
                otherUserViewController.nickName = @"";
            }
            
            [self.navigationController pushViewController:otherUserViewController animated:YES];
        }
        
    }
}

#pragma mark - UISearchDisplayDelegate

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    /*[UIView animateWithDuration:0.2 animations:^
     {
         self.navView.top -= 64;
         _searchB.top -= 44;
         _tableV.top -= 44;
     }completion:^(BOOL finished)
     {
         [self.navView setHidden:YES];
         _tableV.height += 44;
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
   /* [self.navView setHidden:NO];
    [UIView animateWithDuration:0.2 animations:^
     {
         self.navView.top += 64;
         _searchB.top += 44;
         _tableV.top += 44;
     }completion:^(BOOL finished)
     {
         _tableV.height -= 44;
     }];*/
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    if (!_searchResults) {
        
        _searchResults = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [_searchResults removeAllObjects];
    
    NSArray * allKeys = [self.contactsDic allKeys];
    
    for (NSString * key in allKeys) {
        
        NSArray * values = [self.contactsDic valueForKey:key];
        
        for (NSDictionary * user in values) {
            
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
    }

    return YES;
}

#pragma mark - Super Method

- (void)refreshingAction {
    
    [self getAllContacts];
}

#pragma mark - 获取所有联系人  myAllGroupsWithUsers

- (void)getAllContacts {
    
    NSNumber * memebrID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"contact",@"c",@"getFriends",@"act",memebrID,@"loginid", nil];
    
    [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [header endRefreshing];
        
   //    NSLog(@"%@",responseObject);
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            [AppUtil saveDataWithObject:[responseObject valueForKey:@"result"] plistName:@"contacts.plist"];
            
            _contactsDic = [responseObject valueForKey:@"result"];
            
            [_tableV reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [header endRefreshing];
        NSLog(@"Error: %@", error);
    }];
}


#pragma mark - 获取新增关注人数

- (void)getNewFocusCounts { ////每次更新联系人的时候都要更新一下这个
    
    NSNumber * memebrID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"contact",@"c",@"myNewFunsCount",@"act",memebrID,@"userid", nil];
    
    [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [header endRefreshing];
        
        NSLog(@"%@",responseObject);
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            int count = [[response.result valueForKey:@"count"] intValue];/////
            
           //////////////新增数量(先不管的)///////////
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [header endRefreshing];
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - Memory Manage

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:K_LOGIN_NOTIFICATION object:nil];
       [[NSNotificationCenter defaultCenter] removeObserver:self name:K_UPDATE_CONTACTS object:nil];
}

@end
