//
//  MyCollectVC.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/11.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "BaseViewController.h"

@interface MyCollectVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign)BOOL isRoot;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
