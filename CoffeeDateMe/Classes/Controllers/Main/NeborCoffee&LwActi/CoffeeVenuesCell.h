//
//  CoffeeVenuesCell.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14/12/9.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "SWTableViewCell.h"
#import "WTURLImageView.h"

@interface CoffeeVenuesCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet WTURLImageView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *apartNumber;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *locationHint;



@end
