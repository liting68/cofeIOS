//
//  CafeDetailViewController.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-9-30.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "BaseViewController.h"
#import "OfficeHeaderView.h"
#import "WTURLImageView.h"

/////////官方活动详情//////////注释//////////////

@interface CafeDetailViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString * activityID;

@property (strong, nonatomic) NSString * activityName;

@property (strong, nonatomic) NSDictionary * activityDic;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;


@end
