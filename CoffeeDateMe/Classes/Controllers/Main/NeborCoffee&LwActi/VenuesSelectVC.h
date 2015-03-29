//
//  VenuesSelectVC.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/14.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "BaseViewController.h"
#import "AddrSelectView.h"

@class VenuesSelectVC;

@protocol VenuesSelectVCDelegate <NSObject>

- (void)veneusSelectVC:(VenuesSelectVC *)venuesSelectVC isAll:(BOOL)isAll didSelectWith:(NSString *)city bussiness:(NSString *)business bus:(NSString *)bus title:(NSString *)title;

- (void)veneusSelectVC:(VenuesSelectVC *)venuesSelectVC didSelectWithProvinceID:(NSString *)provinceID cityID:(NSString *)cityID townID:(NSString *)townID circleID:(NSString *)circleID title:(NSString *)title;

- (void)veneusSelectVC:(VenuesSelectVC *)venuesSelectVC didSearchWithKeyName:(NSString *)keyName;

@end

@interface VenuesSelectVC : BaseViewController

@property (assign, nonatomic) id<VenuesSelectVCDelegate> delegate;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@property (weak, nonatomic) IBOutlet UIButton *cityButton;

@property (weak, nonatomic) IBOutlet UIButton *businessButton;
@property (weak, nonatomic) IBOutlet UIButton *busButton;


@end
