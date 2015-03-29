/************************************************************
  *  * EaseMob CONFIDENTIAL
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "ChatListViewController.h"
#import "SRRefreshView.h"
#import "ChatListCell.h"
#import "EMSearchBar.h"
#import "NSDate+Category.h"
#import "RealtimeSearchUtil.h"
#import "ChatViewController.h"
#import "EMSearchDisplayController.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "UserCenterVC.h"
#import "AppDelegate.h"
#import "SWTableViewCell.h"

@interface ChatListViewController ()<UITableViewDelegate,UITableViewDataSource, UISearchDisplayDelegate,SRRefreshDelegate, UISearchBarDelegate, IChatManagerDelegate,SWTableViewCellDelegate>

@property (strong, nonatomic) NSMutableArray        *dataSource;
@property (strong, nonatomic) NSMutableDictionary    * userInfo;

@property (strong, nonatomic) UITableView           *tableView;
@property (nonatomic, strong) EMSearchBar           *searchBar;
@property (nonatomic, strong) SRRefreshView         *slimeView;
@property (nonatomic, strong) UIView                *networkStateView;

@property (strong, nonatomic) EMSearchDisplayController *searchController;

@end

@implementation ChatListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self initNavView];
    
//[self initBackButton];
    
    [self forNavBeNoTransparent];
    
    [self initTitleViewWithTitleString:@"消息"];
    
    // [self initLeftBarButtonItem:@"common_list" title:nil action:@selector(listAction)];
    
   // [self initLeftBarButtonItem:@"common_home" title:nil action:@selector(goHome)];
  
   // [self initWithRightButtonWithImageName:@"Message_add" title:nil action:@selector(addAction)];
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.slimeView];
    [self networkStateView];
    
    [self searchController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pullBlackAction:) name:K_PULL_BLACK_NOTIFICATION object:nil];
}



#pragma mark - Memory Manage

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
 //   [super viewWillAppear:animated];
    
    [self showTabBar];
    
    [self refreshDataSource];
    [self registerNotifications];
    
   // [self panGestureEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
    
     [self hideTabBar];
    
   // [self panGestureEnable:YES];
}

#pragma mark - getter

- (SRRefreshView *)slimeView
{
    if (!_slimeView) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
        _slimeView.backgroundColor = [UIColor whiteColor];
    }
    
    return _slimeView;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 64, self.view.frame.size.width, 44)];
        
        _searchBar.delegate = self;
        _searchBar.placeholder = @"输入关键词";
        _searchBar.backgroundColor = [UIColor colorWithWhite:0.929 alpha:1.000];
    }
    
    return _searchBar;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        
        if (self.isRoot) {
            
               _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.bottom, self.view.frame.size.width, self.view.frame.size.height - self.searchBar.frame.size.height - 64) style:UITableViewStylePlain];
            
        }else {
               _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.bottom, self.view.frame.size.width, self.view.frame.size.height - self.searchBar.frame.size.height - 49 - 64) style:UITableViewStylePlain];
            
        }
        
     
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerClass:[ChatListCell class] forCellReuseIdentifier:@"chatListCell"];
    }
    
    return _tableView;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        
        [_searchController setActive:NO animated:NO];
        
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        //__block NSDictionary * tempUserInfo = self.userInfo;
        __weak ChatListViewController *weakSelf = self;
     //   __weak EMSearchDisplayController * weakSearchController = _searchController;
       //
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            
            static NSString *identify = @"chatListCell";
            ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
            
            if (!cell) {
                cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
            }
            
            cell.cdelegate = weakSelf; ///
            
            cell.indexRow = indexPath.row;
            
            cell.type = 1;
            
            EMConversation *conversation = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            
            NSDictionary * dictionary = [weakSelf.userInfo valueForKey:conversation.chatter];//获取用资料
            
            //////////////////解决了昵称
            NSString * nickName  = nil;
            
            if ([AppUtil isNotNull:[dictionary valueForKey:@"nick_name"]]) {
                
                nickName = [dictionary valueForKey:@"nick_name"];
                
            }else {
                
                nickName = [dictionary valueForKey:@"user_name"];
            }
            
          //  if (nickName) {
                
                cell.name = nickName;
                
          //  }else {
                
              //  cell.name = conversation.chatter;
         //   }
            ///////////////////////////////////
            
           // if (!conversation.isGroup) {
                
                if ([AppUtil isNotNull:[dictionary valueForKey:@"head_photo"]]) {
                    
                    cell.imageURL = [NSURL URLWithString:[dictionary valueForKey:@"head_photo"]];
                }
                
              //  cell.placeholderImage = [UIImage imageNamed:@"default_avatar"];
          //  }
          /*  else{
                NSString *imageName = @"groupPublicHeader";
                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                for (EMGroup *group in groupArray) {
                    if ([group.groupId isEqualToString:conversation.chatter]) {
                        cell.name = group.groupSubject;
                        imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
                        break;
                    }
                }
                cell.placeholderImage = [UIImage imageNamed:imageName];
            }*/
            cell.detailMsg = [weakSelf subTitleMessageByConversation:conversation];
            
            cell.time = [weakSelf lastMessageTimeByConversation:conversation];
         
            cell.unreadCount = [weakSelf unreadMessageCountByConversation:conversation];
            
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [ChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
        }];

        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
        
            EMConversation *conversation = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            NSDictionary * dictionary = [weakSelf.userInfo valueForKey:conversation.chatter];
            
            ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:conversation.chatter isGroup:conversation.isGroup];
         
            NSString * nickName = nil;
            
            if ([AppUtil isNotNull:[dictionary valueForKey:@"nick_name"]]) {
                
                nickName = [dictionary valueForKey:@"nick_name"];
            
            }else {
                
                nickName = [dictionary valueForKey:@"user_name"];
            }
        
            chatVC.nickName = nickName;
            
            chatVC.userID = [dictionary valueForKey:@"user_id"];
            
            if ([AppUtil isNotNull:[dictionary valueForKey:@"head_photo"]]) {
                
                chatVC.avatar = [dictionary valueForKey:@"head_photo"];
            }
            
            [weakSelf.navigationController pushViewController:chatVC animated:YES];
        }];
    }
    
    return _searchController;
}

- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"当前网络连接失败";
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}

#pragma mark - private

- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSArray* sorte = [conversations sortedArrayUsingComparator:
           ^(EMConversation *obj1, EMConversation* obj2){
               EMMessage *message1 = [obj1 latestMessage];
               EMMessage *message2 = [obj2 latestMessage];
               if(message1.timestamp > message2.timestamp) {
                   return(NSComparisonResult)NSOrderedAscending;
               }else {
                   return(NSComparisonResult)NSOrderedDescending;
               }
           }];
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    return ret;
}

// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    return ret;
}

// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}

// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = @"[图片]";
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                ret = didReceiveText;
            } break;
            case eMessageBodyType_Voice:{
                ret = @"[声音]";
            } break;
            case eMessageBodyType_Location: {
                ret = @"[位置]";
            } break;
            case eMessageBodyType_Video: {
                ret = @"[视频]";
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}

#pragma mark - TableViewDelegate & TableViewDatasource

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"chatListCell";
   
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    
    cell.indexRow = indexPath.row;
   
    cell.type = 0;
    
    cell.cdelegate = self;
    
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    NSDictionary * dictionary = [self.userInfo valueForKey:conversation.chatter];//获取用资料
  
    //////////////////解决了昵称
    NSString * nickName  = nil;
    
    if ([AppUtil isNotNull:[dictionary valueForKey:@"nick_name"]]) {
        
        nickName = [dictionary valueForKey:@"nick_name"];
        
    }else {
        
        nickName = [dictionary valueForKey:@"user_name"];
    }

   // if (nickName) {
        
        cell.name = nickName;
    
   // }else {
        
        //  cell.name = conversation.chatter;
   // }
///////////////////////////////////
    
    if (!conversation.isGroup) {
       
        if ([AppUtil isNotNull:[dictionary valueForKey:@"head_photo"]]) {
            
            cell.imageURL = [NSURL URLWithString:[dictionary valueForKey:@"head_photo"]];
        }
        
        cell.placeholderImage = [UIImage imageNamed:@"chatListCellHead.png"];
    }
    else{
   
        NSString *imageName = @"groupPublicHeader";
        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup *group in groupArray) {
            if ([group.groupId isEqualToString:conversation.chatter]) {
                cell.name = group.groupSubject;
                imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
                break;
            }
        }
        cell.placeholderImage = [UIImage imageNamed:imageName];
    }
    cell.detailMsg = [self subTitleMessageByConversation:conversation];
    cell.time = [self lastMessageTimeByConversation:conversation];
    cell.unreadCount = [self unreadMessageCountByConversation:conversation];
 
    
    /////////自己实现左滑动删除//////////
    cell.section = indexPath.section;
    cell.row = indexPath.row;
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonForDeleteWithColor:[UIColor redColor] title:@"删除"];
    cell.delegate = self;
    [cell setRightUtilityButtons:rightUtilityButtons WithButtonWidth:60.0f];
    
//////////
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    
    NSDictionary *  dictionary = [self.userInfo valueForKey:conversation.chatter];
    
    ChatViewController *chatController;
   
    /*NSString *title = conversation.chatter;
    if (conversation.isGroup) {
        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup *group in groupArray) {
            if ([group.groupId isEqualToString:conversation.chatter]) {
                title = group.groupSubject;
                break;
            }
        }
    }*/

    NSString * nickName = nil;
    
    if ([AppUtil isNotNull:[dictionary valueForKey:@"nick_name"]]) {
        
        nickName = [dictionary valueForKey:@"nick_name"];
    
    }else {
        
        nickName =[dictionary valueForKey:@"user_name"];
    }

    NSString *chatter = conversation.chatter;
   
    chatController = [[ChatViewController alloc] initWithChatter:chatter isGroup:conversation.isGroup];
    
    chatController.userID = [dictionary valueForKey:@"user_id"];
        
    chatController.nickName = nickName;
    
    if ([AppUtil isNotNull:[dictionary valueForKey:@"head_photo"]]) {
        
        chatController.avatar = [dictionary valueForKey:@"head_photo"];
    }
    
    [conversation markMessagesAsRead:YES];
    
    [self.navigationController pushViewController:chatController animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EMConversation *converation = [self.dataSource objectAtIndex:indexPath.row];
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:converation.chatter deleteMessages:NO];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark -

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    EMConversation *converation = [self.dataSource objectAtIndex:cell.row];
    [[EaseMob sharedInstance].chatManager removeConversationByChatter:converation.chatter deleteMessages:NO];
    [self.dataSource removeObjectAtIndex:cell.row];
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:cell.row inSection:cell.section];
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}


#pragma mark - ChatListDelegate

- (void)chatCell:(ChatListCell *)chatListCell DidClickAvatarWithIndexRow:(int)index  {
    
    if (chatListCell.type == 0) {
        
        if (![self checkLogin]) {
            
            return;
        }
        
        EMConversation *conversation = [self.dataSource objectAtIndex:index];
        
        NSDictionary * userInfo = [self.userInfo valueForKey:conversation.chatter];//获取用资
        
        UserCenterVC * otherUserViewController = [self getStoryBoardControllerWithControllerID:@"UserCenterVC" storyBoardName:@"Other"];
        
        if ([AppUtil isNotNull:[userInfo valueForKey:@"user_id"]]) {
            
            otherUserViewController.otherID = [userInfo valueForKey:@"user_id"];
            
        }else {
            
            otherUserViewController.otherID = @"";
        }
        
        if ([AppUtil isNotNull:[userInfo valueForKey:@"nick_name"]]) {
            otherUserViewController.nickName = [userInfo valueForKey:@"nick_name"];
        }else{
            otherUserViewController.nickName = [userInfo valueForKey:@"user_name"];
        }
        
        [self.navigationController pushViewController:otherUserViewController animated:YES];
   
    }else {
    
        if (![self checkLogin]) {
            
            return;
        }
        
        
        EMConversation *conversation = [self.searchController.resultsSource objectAtIndex:index];
        
        NSDictionary * userInfo = [self.userInfo valueForKey:conversation.chatter];//获取用资料
        
        UserCenterVC * otherUserViewController = [self getStoryBoardControllerWithControllerID:@"UserCenterVC" storyBoardName:@"Other"];
        
        if ([AppUtil isNotNull:[userInfo valueForKey:@"user_id"]]) {
            
            otherUserViewController.otherID = [userInfo valueForKey:@"user_id"];
            
        }else {
            
            otherUserViewController.otherID = @"";
        }
        
        if ([AppUtil isNotNull:[userInfo valueForKey:@"nick_name"]]) {
            otherUserViewController.nickName = [userInfo valueForKey:@"nick_name"];
        }else{
            otherUserViewController.nickName = [userInfo valueForKey:@"user_name"];
        }
        
        [self.navigationController pushViewController:otherUserViewController animated:YES];
        
    }
    
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSMutableDictionary * myDataSource = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.dataSource,@"dataSource",self.userInfo,@"userInfo", nil];
    
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:myDataSource searchText:(NSString *)searchText collationStringSelector:@selector(chatter) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.searchController.resultsSource removeAllObjects];
                [self.searchController.resultsSource addObjectsFromArray:results];
             //   self.searchDisplayController.
                [self.searchController.searchResultsTableView reloadData];
            });
        }
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate
//刷新消息列表
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self refreshDataSource];
    [_slimeView endRefresh];
}

#pragma mark - IChatMangerDelegate

-(void)didUnreadMessagesCountChanged
{
    [self refreshDataSource];
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error
{
    [self refreshDataSource];
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc{
    [self unregisterNotifications];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:K_PULL_BLACK_NOTIFICATION object:nil];
}

#pragma mark - public

-(void)refreshDataSource
{
    self.dataSource = [self loadDataSource];
    
    /////////根据用户兑现列表过去用户用户信息

    if ([self.dataSource count] > 0) {
        
        NSMutableString * userNames = [[NSMutableString alloc] initWithString:@""];
        
        for (int index = 0; index < [self.dataSource count]; index ++) {
            
            EMConversation *  conversion = self.dataSource[index];

            if ([AppUtil isNotNull:conversion.chatter]) {
                
                 [userNames appendString:conversion.chatter];
            }
        
            if (index < [self.dataSource count] - 1) {
                
                [userNames appendString:@","];
            }
        }
        
        NSNumber * memberID = [[NSUserDefaults standardUserDefaults] currentMemberID];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"contact",@"c",@"getFriendsByUsernames", @"act", userNames,@"usernames",memberID,@"loginid",nil];
        
        ///获取用户资料
        [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            Response * response = [self parseJSONValueWithJSONString:responseObject];
            
            if (_userInfo) {
                
                _userInfo = nil;
            }
            
            if ([response.result isKindOfClass:[NSArray class]]) {
                
                
            }else {
                
               _userInfo = [NSMutableDictionary dictionaryWithDictionary:response.result];
                
                [_tableView reloadData];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
     
        }];
   
    }else {
        
        [_tableView reloadData];
    }
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == eEMConnectionDisconnected) {
        _tableView.tableHeaderView = _networkStateView;
    }
    else{
        _tableView.tableHeaderView = nil;
    }
}

- (void)willReceiveOfflineMessages{
    NSLog(@"开始接收离线消息");
}

- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages{
    NSLog(@"离线消息接收成功");
    [self refreshDataSource];
}

#pragma mark - Super Method

- (void)listAction {
    
    if ([self.getSlideMenuVC isMenuOpen]){
        
        [self.getSlideMenuVC closeMenuAnimated:YES completion:nil];
        
    }else {
        
        [self.getSlideMenuVC openMenuAnimated:YES completion:nil];
        
    }
}


#pragma mark - Actions

- (void)pullBlackAction:(NSNotification *)noti {
    
    NSString * coffeeID = noti.object;
    
    int index = 0;
    
    for (index = 0; index < [self.dataSource count]; index ++) {
        
         EMConversation *converation = [self.dataSource objectAtIndex:index];
        
        if ([converation.chatter isEqualToString:coffeeID]) {
            break;
        }
    }
    
    if (index < [self.dataSource count]) {
        
        EMConversation *converation = [self.dataSource objectAtIndex:index];
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:converation.chatter deleteMessages:NO];
        [self.dataSource removeObjectAtIndex:index];
        [self.tableView reloadData];
    }

}

#pragma mark -

- (void)goHome {
    
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.leveyTabBarVC setSelectedIndex:0];
    
}

- (void)addAction {
    
    
}

@end
