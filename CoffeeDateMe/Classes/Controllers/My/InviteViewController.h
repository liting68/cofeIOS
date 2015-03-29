//
//  InviteViewController.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/9.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "BaseViewController.h" ///个人活动
#import "DateSquareDetail.h"

@interface InviteViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic)int type;// 0.我发起的 1.我参与的

//////////
@property (assign, nonatomic)BOOL isOther;
@property (strong, nonatomic) NSString * titleString;
@property (strong, nonatomic) NSString * userID;

@end
