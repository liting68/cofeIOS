//
//  MenuView.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/4.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTURLImageView.h"

@class MenuView;

@protocol MenuViewDelegate <NSObject>

- (void)menuView:(MenuView *)menuView didSelectedIndex:(int)index;

@end

@interface MenuView : UIView<WTURLImageViewDelegate>

@property (assign, nonatomic)id<MenuViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet AvatarView *avatar1;
@property (weak, nonatomic) IBOutlet AvatarView *avatar2;
@property (weak, nonatomic) IBOutlet AvatarView *avatar3;
@property (weak, nonatomic) IBOutlet AvatarView *avatar4;

@property (weak, nonatomic) IBOutlet UIView *menuBack1;
@property (weak, nonatomic) IBOutlet UIView *menuBack2;
@property (weak, nonatomic) IBOutlet UIView *menuBack3;
@property (weak, nonatomic) IBOutlet UIView *menuBack4;

@property (weak, nonatomic) IBOutlet UILabel *menuLabel1;
@property (weak, nonatomic) IBOutlet UILabel *menuLabel2;
@property (weak, nonatomic) IBOutlet UILabel *menuLabel3;
@property (weak, nonatomic) IBOutlet UILabel *menuLabel4;

@property (assign,nonatomic) BOOL noContent;

- (void)layoutMenuView:(NSDictionary *)dic;

@end
