//
//  LeftCell.h
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/7.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UIButton *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *noReadLabel;

@property (weak, nonatomic) IBOutlet UIImageView *noReadView;


@end
