//
//  WantDrinkSubView.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-9-29.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTURLImageView.h"

@interface WantDrinkSubView : UIView<WTURLImageViewDelegate>

@property (weak, nonatomic) IBOutlet WTURLImageView *avatarView;

@property (weak, nonatomic) IBOutlet UILabel *nackName;

@property (weak, nonatomic) IBOutlet UILabel *distance;

@property (weak, nonatomic) IBOutlet UIImageView *locaView;

- (void)layoutWithData:(NSDictionary *)data;

@end
