//
//  ButtomBarView.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-10-9.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ButtomBarView;

@protocol ButtomBarViewDelegate <NSObject>

- (void)buttomBarView:(ButtomBarView *)buttomBarView didClick:(int)type;//0.1.2 邀约 对话 拉黑

@end

@interface ButtomBarView : UIView

@property (assign, nonatomic)id<ButtomBarViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *pullBlackIcon;

@property (weak, nonatomic) IBOutlet UIButton *pullBackButton;

- (void)updatePullBlackWithFlag:(BOOL)flag;

@end
