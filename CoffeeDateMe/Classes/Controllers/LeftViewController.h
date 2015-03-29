//
//  LeftViewController.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/1/29.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "BaseViewController.h"
#import "SetViewController.h"


@interface LeftViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;


///////////设置 & 隐身
@property (weak, nonatomic) IBOutlet UIButton *setButton;

@property (weak, nonatomic) IBOutlet UIButton *yinshen;

@property (assign, nonatomic) int noReadInviteNumber;
@property (assign, nonatomic) int noReadMessage;

- (void)setNoReadMsg:(int)number;

- (void)getInviteNoRead;

@end
