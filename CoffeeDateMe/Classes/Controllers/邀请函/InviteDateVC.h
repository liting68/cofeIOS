//
//  InviteDateVC.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/24.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "BaseViewController.h"
#import "MyInviteCell.h"

@interface InviteDateVC : BaseViewController<UITableViewDataSource,UITableViewDelegate,MyInviteCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,assign) int type;//0.创建 1.参与

//////选择的信
@property (nonatomic,strong) NSDictionary * selectDicInfo;

- (void)initInviteCell;

- (void)getAboutData;

@end
