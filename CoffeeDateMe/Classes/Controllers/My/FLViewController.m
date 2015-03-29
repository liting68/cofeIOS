//
//  FLViewController.m
//  15-QQ聊天布局
//
//  Created by Liu Feng on 13-12-3.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "FLViewController.h"
#import "MessageFrame.h"
#import "Message.h"
#import "MessageCell.h"

@interface FLViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray  * _allMessagesFrame;
}
@end

@implementation FLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ////////NAV
    [self initBackButton];
    [self initTitleViewWithTitleString:self.userName];
    
    //////////VIEW
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, K_UIMAINSCREEN_WIDTH, K_UIMAINSCREEN_HEIGHT - 64 - 40)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.allowsSelection = NO;
     _tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
  ////////////////////
    
    _btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
     _btnMore.frame = CGRectMake(130, 5,60 , 20);
    [_btnMore setTitle:@"查看更多" forState:UIControlStateNormal];
     _btnMore.titleLabel.font = [UIFont systemFontOfSize:13];
    [_btnMore addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchDown];

    ///////////TOOLBar
    _customEmojiToolbar  = [[CustomEmojiToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 40, K_UIMAINSCREEN_WIDTH, 40) superView:self.view];
    _customEmojiToolbar.delegate = self;
    
    //////////get data
    self.isMore = NO;
    page = 1;
    [self getChatRecor];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [_customEmojiToolbar addNotificatons];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [_customEmojiToolbar removeNotifications];
}

#pragma mark - CustomEmojiToolBarDelegate

- (void)emojiToolbarSendBtnDidClick:(CustomEmojiToolbar *)emojiToolbar sendString:(NSString *)sendString {
    
    if ([AppUtil isNull:sendString]) {
        
        [AppUtil HUDWithStr:@"说点什么吧" View:self.view];
    
    }else{
        
         [self sendMsgToFriendWithContent:sendString];
    }
}

#pragma mark - UITableViewDataSouce & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allMessagesFrame.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        UITableViewCell * tableCell = [tableView dequeueReusableCellWithIdentifier:@"moerCell"];
        
        if (!tableCell) {
            
            tableCell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moerCell"];
            [_btnMore setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [tableCell.contentView addSubview:_btnMore];
        }
        tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableCell.backgroundColor=[UIColor clearColor];
        return tableCell;
        
    }else {
        
        static NSString *CellIdentifier = @"Cell";
        
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        
        cell.messageFrame = _allMessagesFrame[indexPath.row - 1];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        return 30;
        
    }else{
        
        return [_allMessagesFrame[indexPath.row - 1] cellHeight];
    }
}

#pragma mark - Actions

- (void)moreAction {
    
    self.isMore = YES;
    page = page + 1;
    [self getChatRecor];
}

#pragma mark - 发送消息

- (void)sendMsgToFriendWithContent:(NSString *)content {
    
    NSNumber * memebrID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"chat",@"c",@"sendMsg",@"act",memebrID,@"from_userid", self.userID,@"to_userid",content,@"content",nil];
    
    [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            NSLog(@"%@",responseObject);
            
            [_customEmojiToolbar clearText];
            
            self.isMore = NO;
            page = 1;
            [self getChatRecor];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - 获取消息

- (void)getChatRecor {
    
    NSNumber * memebrID = [[NSUserDefaults standardUserDefaults] currentMemberID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"chat",@"c",@"getChatBySendToId",@"act",memebrID,@"from_userid", self.userID,@"to_userid",[NSString stringWithFormat:@"%d",page],@"page",nil];
    
    [manager GET:hostUrl parameters:[self commonParamsWithDictionary:parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Response * response = [self parseJSONValueWithJSONString:responseObject];
        
        if (response.err == 1) {
            
            NSArray * chats = [response.result valueForKey:@"chats"];
            
            [self dealWithChatInfo:chats];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)dealWithChatInfo:(NSArray *)chats {
    
    if (!_allMessagesFrame) {
        
         _allMessagesFrame = [NSMutableArray array];
    }
    
    if (!self.isMore) {
        
        [_allMessagesFrame removeAllObjects];
    }
    
    NSString *previousTime = nil;
    
    for (NSDictionary *dict in chats) {
        
        MessageFrame *messageFrame = [[MessageFrame alloc] init];
        Message *message = [[Message alloc] init];
        message.dict = dict;
        
        messageFrame.showTime = [self isShowTime:previousTime compareTime:message.time];
        
        messageFrame.message = message;
        
        previousTime = message.time;
        
        [_allMessagesFrame insertObject:messageFrame atIndex:0];
    }
    
    [self.tableView reloadData];
    
    if (!self.isMore) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:[_allMessagesFrame count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (BOOL)isShowTime:(NSString *)lastTime compareTime:(NSString *)showTime {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [dateFormatter setTimeZone:timeZone];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if(!lastTime) {
        
        return YES;
    
    }else {
      
        NSDate * lastTimeDate = [dateFormatter dateFromString:lastTime];
        
        NSDate * showTimeDate = [dateFormatter dateFromString:showTime];

        NSTimeInterval timeInterval = [showTimeDate timeIntervalSinceDate:lastTimeDate];

        if (timeInterval  > 10) {
            
            return YES;
        
        }else{
            
            return NO;
        }
    }
}
@end
