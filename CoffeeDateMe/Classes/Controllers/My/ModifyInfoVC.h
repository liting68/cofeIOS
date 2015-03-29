//
//  ModifyInfoVC.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/3/2.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "BaseViewController.h"

@class ModifyInfoVC;

@protocol ModifyInfoVCDelegate <NSObject>

- (void)modifyInfoVC:(ModifyInfoVC *)modifyInfoVC didModifySuccessWithTitle:(NSString *)title;

@end

@interface ModifyInfoVC : BaseViewController

@property (assign,nonatomic) id<ModifyInfoVCDelegate> delegate;

@property (strong, nonatomic) NSString * beizhuTitle;

@property (strong, nonatomic) NSString * keyName;

@property (strong, nonatomic) NSString * keyValue;

@property (strong, nonatomic) NSString * orignValue;

@property (assign, nonatomic) int index;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UITextField *textField;


@end
