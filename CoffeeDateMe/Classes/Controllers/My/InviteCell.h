//
//  InviteCell.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/14.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface InviteCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet AvatarView *avatarView;//

@property (weak, nonatomic) IBOutlet UILabel *actiName;//

////////////////
@property (weak, nonatomic) IBOutlet UIImageView *drinkIcon;

@property (weak, nonatomic) IBOutlet UILabel *drinkTitle;
////////////////
@property (weak, nonatomic) IBOutlet UIImageView *dateObjectIcon;//
@property (weak, nonatomic) IBOutlet UILabel *dateObjectLabel;//
////////////发布时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//
@end
