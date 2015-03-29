/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "BaseViewController.h"
#import "WTURLImageView.h"
#import <UIKit/UIKit.h>

@interface ChatViewController : BaseViewController<WTURLImageViewDelegate>

- (instancetype)initWithChatter:(NSString *)chatter isGroup:(BOOL)isGroup;

@property (nonatomic, strong) NSString * nickName;//昵称
@property (nonatomic, strong) NSString * avatar;///头像昵称
@property (nonatomic, strong) NSString * userID;//用户ID

@end
