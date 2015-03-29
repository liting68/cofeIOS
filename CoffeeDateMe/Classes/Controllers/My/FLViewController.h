//
//  FLViewController.h
//  15-QQ聊天布局
//
//  Created by Liu Feng on 13-12-3.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomEmojiToolbar.h"

@interface FLViewController : BaseViewController<EmojiToolbarDelegate>

//控件
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton * btnMore;

//参数
@property (strong,nonatomic) NSString * userID;
@property (strong, nonatomic) NSString * userName;

//分页
@property (nonatomic,assign) BOOL isMore;

//自定义
@property (strong,nonatomic)CustomEmojiToolbar * customEmojiToolbar;

@end
