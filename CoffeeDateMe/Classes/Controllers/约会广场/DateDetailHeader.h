//
//  DateDetailHeader.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/14.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvatarView.h"
#import "HTCopyableLabel.h"


@protocol DateDetailHeaderDelegate <NSObject>

- (void)dateDetailHeaderDidGotoMap;

-(void)dateDetailHeaderDidGotoShop;

@end

@interface DateDetailHeader : UIView<WTURLImageViewDelegate>

@property (assign,nonatomic) id<DateDetailHeaderDelegate> delegate;

//头像
@property (weak, nonatomic) IBOutlet AvatarView *avatarView;
//咖啡名称
@property (weak, nonatomic) IBOutlet UILabel *cafeName;

@property (weak, nonatomic) IBOutlet UIImageView *postSexView;

@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@property (weak, nonatomic) IBOutlet UIImageView *xzBg;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *xzLabel;

@property (weak, nonatomic) IBOutlet UILabel *postTime;


@property (weak, nonatomic) IBOutlet UIImageView *dateObjectIcon;

///////
@property (weak, nonatomic) IBOutlet UILabel *actiLabel;
////;
@property (weak, nonatomic) IBOutlet UILabel *dateNameLabel;
@property (weak, nonatomic) IBOutlet HTCopyableLabel *dateAddr;
@property (weak, nonatomic) IBOutlet UILabel *dateTime;
@property (weak, nonatomic) IBOutlet UILabel *dateObject;

@property (weak, nonatomic) IBOutlet AvatarView *showView;



- (void)layoutWithDic:(NSDictionary *)dic;

@end
