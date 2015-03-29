//
//  OtherUserViewController.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-10-1.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableViewController.h"
#import "PhotoHeaderView.h"
#import "ButtomBarView.h"
#import "OtherUserHeaderView.h"

@interface OtherUserViewController : BaseTableViewController<PhotoheaderViewDelegate,ButtomBarViewDelegate>

@property (strong, nonatomic) NSDictionary * userInfo;

@property (strong, nonatomic)NSString * userID;//用户ID

@property (strong, nonatomic) NSString * nickName;//昵称

//@property (strong, nonatomic) NSString * userName;///咖啡号

@property (strong, nonatomic) IBOutlet UITableView *tableView;

//@property (weak, nonatomic) IBOutlet UIImageView *sexFlag;

//@property (weak, nonatomic) IBOutlet UILabel *postTime;

//@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

//@property (weak, nonatomic) IBOutlet UILabel *bestSpecInfo;

//@property (weak, nonatomic) IBOutlet UILabel *xingzuoLabel;

//@property (weak, nonatomic) IBOutlet UILabel *coffeeNumber;

//@property (weak, nonatomic) IBOutlet UILabel *gxqmLabel;

//@property (weak, nonatomic) IBOutlet UILabel *registerDate;

//@property (weak, nonatomic) IBOutlet UILabel *job;
//@property (weak, nonatomic) IBOutlet UILabel *homeTown;
//@property (weak, nonatomic) IBOutlet UILabel *xqahLabel;
//@property (weak, nonatomic) IBOutlet UILabel *releation;

@property (assign,nonatomic) BOOL isBlack;

@property (strong, nonatomic) NSArray *imageArr;

//@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) PhotoHeaderView * photoHeaderView;

@property(strong, nonatomic) ButtomBarView * buttomBarView;

@property (assign, nonatomic)int headID;

@property (strong, nonatomic)OtherUserHeaderView * otherUserHeaderView;


@end
