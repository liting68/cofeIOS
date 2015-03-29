//
//  LoginViewController.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-9-30.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "BaseViewController.h"
#import "AvatarView.h"
#import "WTURLImageView.h"

@interface LoginViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (nonatomic, assign)BOOL isPresent;
@property (nonatomic, assign)BOOL isRoot;

@property (nonatomic, assign) int type;

@property (weak, nonatomic) IBOutlet AvatarView *headerView;

- (void)goBackAcion;

@end
