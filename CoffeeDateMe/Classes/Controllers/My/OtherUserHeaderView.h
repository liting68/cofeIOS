//
//  OtherUserHeaderView.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-11-29.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherUserHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *sexFlag;

@property (weak, nonatomic) IBOutlet UILabel *postTime;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *xingzuoLabel;

@property (weak, nonatomic) IBOutlet UILabel *coffeeNumber;

@property (weak, nonatomic) IBOutlet UILabel *gxqmLabel;

@property (weak, nonatomic) IBOutlet UILabel *registerDate;

@property (weak, nonatomic) IBOutlet UILabel *job;
@property (weak, nonatomic) IBOutlet UILabel *homeTown;
@property (weak, nonatomic) IBOutlet UILabel *xqahLabel;
@property (weak, nonatomic) IBOutlet UILabel *releation;


@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *otherView;

- (void)layoutWithDic:(NSDictionary *)responseObject;

@end
