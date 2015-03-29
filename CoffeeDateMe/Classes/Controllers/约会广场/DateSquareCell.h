//
//  DateSquareCell.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/1/31.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateSquareCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet WTURLImageView *backImageView;
@property (weak, nonatomic) IBOutlet WTURLImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *addrLabel;



@end
