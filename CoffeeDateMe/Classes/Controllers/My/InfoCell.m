//
//  InfoCell.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/16.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "InfoCell.h"

@implementation InfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)textContentChanage:(id)sender {
    
    NSLog(@"%@",sender);
    
    UITextField * textField = (UITextField *)sender;
    NSString * text = textField.text;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(infoCell:didChangeValue:)]) {
        
        
        [self.delegate infoCell:self didChangeValue:text];
    }
}


@end
