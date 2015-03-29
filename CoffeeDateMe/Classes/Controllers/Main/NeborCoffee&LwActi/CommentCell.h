//
//  CommentCell.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-10-1.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTURLImageView.h"
#import "AvatarView.h"
#import "LineView.h"

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet  AvatarView *avatatView;

@property (weak, nonatomic) IBOutlet UILabel *nickName;

@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *postTime;

@property (weak, nonatomic) IBOutlet UIImageView *timeLineView;

@property (weak, nonatomic) IBOutlet LineView *lineView;

@property (weak, nonatomic) IBOutlet UIImageView *timeIcon;

@end
