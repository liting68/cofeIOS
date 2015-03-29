//
//  UserCell.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-10-19.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell

- (void)awakeFromNib
{
    // Initialization code
}

- (IBAction)addAction:(id)sender {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(userCellDidClickAdd:)]) {
        
        [self.delegate userCellDidClickAdd:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
