//
//  LeftCell.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/7.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "LeftCell.h"

@implementation LeftCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        
        self.iconButton.selected = YES;
        [self.titleLabel setTitleColor:[UIColor colorWithRed:0.788 green:0.278 blue:0.035 alpha:1.000] forState:UIControlStateNormal];
    }else {
        self.iconButton.selected = NO;
        [self.titleLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    // Configure the view for the selected state
}


@end
