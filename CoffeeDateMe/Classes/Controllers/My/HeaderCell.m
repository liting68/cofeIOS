//
//  HeaderCell.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/9.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "HeaderCell.h"

@implementation HeaderCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)photoLibraryAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerCell:didClickAction:)]) {
        
        [self.delegate headerCell:self didClickAction:0];
    }
}

- (IBAction)dateAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerCell:didClickAction:)]) {
        
        [self.delegate headerCell:self didClickAction:1];
    }
}


- (void)initSubViewWithIsMyself:(BOOL)mySelf {
    
    if (mySelf) {//自己的
        
        [self.personInfo_my setHidden:NO];
        [self.personInfo_button_my setHidden:NO];
        [self.photo_my setHidden:NO];
        [self.photo_butotn_my setHidden:NO];
        
        [self.personIcon setHidden:YES];
        [self.personInfoButton setHidden:YES];
        
        [self.photoIcon setHidden:YES];
        [self.photoButotn setHidden:YES];
        
        [self.coffeeIcon setHidden:YES];
        [self.coffeeButton setHidden:YES];
        
    }else {
        
        [self.personInfo_my setHidden:YES];
        [self.personInfo_button_my setHidden:YES];
        [self.photo_my setHidden:YES];
        [self.photo_butotn_my setHidden:YES];
        
        [self.personIcon setHidden:NO];
        [self.personInfoButton setHidden:NO];
        
        [self.photoIcon setHidden:NO];
        [self.photoButotn setHidden:NO];
        
        [self.coffeeIcon setHidden:NO];
        [self.coffeeButton setHidden:NO];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
