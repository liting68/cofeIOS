//
//  WantDrinkSelectedVC.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/27.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "BaseViewController.h"

@class WantDrinkSelectedVC;

@protocol WantDrinkSelectedVCDelegate <NSObject>

- (void)wantDrinkSelectedVC:(WantDrinkSelectedVC *)wantDrinkSelectedVC didSelectedType:(int)type;

@end

@interface WantDrinkSelectedVC : BaseViewController

@property (assign,nonatomic) id<WantDrinkSelectedVCDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *nvSeleectIcon;

@property (weak, nonatomic) IBOutlet UIImageView *nanSelectedIcon;

@property (weak, nonatomic) IBOutlet UIImageView *tjSelectedIcon;

@property (assign,nonatomic) int type;//0 all 1 nv 2 nan 3 tongji

- (void)initWithType:(int)type;

@end
