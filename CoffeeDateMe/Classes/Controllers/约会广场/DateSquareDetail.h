//
//  DateSquareDetail.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/14.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "BaseViewController.h"
#import "DateDetailHeader.h"
/////////////////////////////////
#import "InterestPersonView.h"
#import "DateDetailHeader.h"

@interface DateSquareDetail : BaseViewController
{
     DateDetailHeader * _dateDetailHeader;
     InterestPersonView * _interestPersonView;
}

@property (strong, nonatomic) NSMutableDictionary * activityDic;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong) NSString * eventID;

@end
