//
//  CollectionCell.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/27.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "SWTableViewCell.h"
#import "AvatarView.h"

@interface CollectionCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet AvatarView *avatarView;

@property (weak, nonatomic) IBOutlet UILabel *venuesNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *axisLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *locaIcon;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *likeIcon;

@property (weak, nonatomic) IBOutlet UILabel *likeNumberLabel;


@end
