//
//  InterestPersonView.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/3.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InterestPersonView;

@protocol InterestPersonViewDelegate <NSObject>

- (void)interestPersonView:(InterestPersonView *)interestPersonView didClickAvatarWithPersonInfo:(NSDictionary *)dic;

- (void)interestPersonViewDidClickInterestButton:(InterestPersonView *)interestPersonView;

@end

@interface InterestPersonView : UIView<WTURLImageViewDelegate>

@property (assign, nonatomic) id<InterestPersonViewDelegate> delegate;

@property (nonatomic, strong) NSDictionary * actiInfo;

@property (weak, nonatomic) IBOutlet UILabel *signNumberHint;

@property (weak, nonatomic) IBOutlet UILabel *signNumbers;

@property (weak, nonatomic) IBOutlet UIScrollView *signPersonScrollView;

@property (weak, nonatomic) IBOutlet UIButton *signButton;

@property (assign, nonatomic) int isPerson;//0        1.个人详细

- (void)layoutOutWithDic:(NSDictionary *)dic;

@end
