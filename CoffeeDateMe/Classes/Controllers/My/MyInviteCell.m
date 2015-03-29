//
//  MyInviteCell.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/27.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "MyInviteCell.h"

@implementation MyInviteCell

- (void)initInviteCell {
    
    self.avatarView.userInteractionEnabled = YES;
    self.avatarView.delegate = self;
    self.avatarView.layer.cornerRadius = self.avatarView.width/2;
  //  self.avatarView.layer.borderColor = [[UIColor whiteColor] CGColor];
  //  self.avatarView.layer.borderWidth = 2.0f;
    self.avatarView.layer.masksToBounds = YES;
}

- (IBAction)operAction:(id)sender {
    
    if (self.adelegate && [self.adelegate respondsToSelector:@selector(myInviteCellDidOpenDetail:)]) {
        
        [self.adelegate myInviteCellDidOpenDetail:self];
    }
    
}

- (IBAction)cancelAction:(id)sender {
    
    if (self.adelegate && [self.adelegate respondsToSelector:@selector(myInviteCellDidCancel:)]) {
        
        [self.adelegate myInviteCellDidCancel:self];
    }
    
}


#pragma mark - 

- (void) URLImageViewDidClicked : (WTURLImageView*)imageView {
    
    if (self.adelegate && [self.adelegate respondsToSelector:@selector(myInviteCell:didGotoUserDetail:)]) {
        
        [self.adelegate myInviteCell:self didGotoUserDetail:self.inviteInfo];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
