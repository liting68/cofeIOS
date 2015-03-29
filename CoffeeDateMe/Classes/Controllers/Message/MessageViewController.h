//
//  MessageViewController.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-9-28.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "BaseViewController.h"


@interface MessageViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic)int type;//0 消息列表(废弃)  1 关注列表  2 粉丝列表 3 推荐列表(废弃)  4.搜素列表  5.通讯录列表 6.附近的好友

///搜索列表
@property (strong, nonatomic) NSString * keyword;
///
@property (strong, nonatomic) NSString * mobile;

@property (nonatomic,strong)NSMutableArray * searchResults;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerContraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerContraint;

@property (assign, nonatomic) int count;

@end
