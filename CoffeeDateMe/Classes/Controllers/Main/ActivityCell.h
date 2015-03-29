//
//  ActivityCell.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-9-29.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTURLImageView.h"

@interface ActivityCell : UITableViewCell
//头像
@property (weak, nonatomic) IBOutlet WTURLImageView *activityAvatarView;
//活动名称
@property (weak, nonatomic) IBOutlet UILabel *activityName;
//加入人数
@property (weak, nonatomic) IBOutlet UILabel *partInNumber;
///月份
@property (weak, nonatomic) IBOutlet UILabel *partInTimes;
/////周
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *hintLabel;///人报名


@end
