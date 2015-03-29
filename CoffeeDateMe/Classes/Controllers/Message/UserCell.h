//
//  UserCell.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-10-19.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTURLImageView.h"
@class UserCell;

@protocol UserCellDelegate <NSObject>

- (void)userCellDidClickAdd:(UserCell *)userCell;

@end

@interface UserCell : UITableViewCell<WTURLImageViewDelegate>

@property (nonatomic,assign)id<UserCellDelegate> delegate;

@property (strong, nonatomic) NSDictionary * dic;

@property (weak, nonatomic) IBOutlet WTURLImageView *avatarView;

@property (weak, nonatomic) IBOutlet UILabel *nickName;

@property (weak, nonatomic) IBOutlet UIImageView *sexView;

@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@property (weak, nonatomic) IBOutlet UIImageView *xzBg;
@property (weak, nonatomic) IBOutlet UILabel *xingzuoLabel;

@property (weak, nonatomic) IBOutlet UILabel *coffeeLabel;

/////////////
@property (weak, nonatomic) IBOutlet UIImageView *locationView;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
//////
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end
