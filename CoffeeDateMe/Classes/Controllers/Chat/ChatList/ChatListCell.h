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

#import <UIKit/UIKit.h>
#import "AvatarView.h"
#import "SWTableViewCell.h"

@class ChatListCell;

@protocol ChatListCellDelegate <NSObject>

- (void)chatCell:(ChatListCell *)chatListCell DidClickAvatarWithIndexRow:(int)index;

@end

@interface ChatListCell : SWTableViewCell<WTURLImageViewDelegate>
@property (nonatomic,assign)int indexRow;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *detailMsg;
@property (nonatomic, strong) NSString *time;
@property (nonatomic) NSInteger unreadCount;
@property (nonatomic,strong) AvatarView * avatarView;

@property (nonatomic, assign) int type;//0 正常列表  1.搜索列表

@property (nonatomic, assign)id<ChatListCellDelegate> cdelegate;

+(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
