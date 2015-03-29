//
//  SetViewController.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-10-17.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "BaseTableViewController.h"
//#import "AboutViewController.h"

@interface SetViewController : BaseTableViewController<UIAlertViewDelegate>

@property (nonatomic, strong)NSDictionary * resultDic;

@property (nonatomic, strong) NSString * updateUrlString;

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@property (weak, nonatomic) IBOutlet UISwitch *allowFind;//允许找到

@property (weak, nonatomic) IBOutlet UISwitch *allowAdd;//允许添加

@property (assign, nonatomic) BOOL isRoot;

- (void)updateViews;

@end
