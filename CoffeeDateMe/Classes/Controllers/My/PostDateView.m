//
//  PostDateView.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/24.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "PostDateView.h"

@implementation PostDateView

- (IBAction)selecteTimeAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(postDateViewDidSelectTime:)]) {
        
        [self.delegate postDateViewDidSelectTime:self];
    }
}
- (IBAction)selectAddress:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(postDateViewDidSelectAddress:)]) {
        
        [self.delegate postDateViewDidSelectAddress:self];
    }
}

- (IBAction)selectTitleAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(postDateViewDidSelectTitle)]) {
        
        [self.delegate postDateViewDidSelectTitle];
    }
}

- (IBAction)postAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(postDateViewDidSelectDidPost:)]) {
        
        [self.delegate postDateViewDidSelectDidPost:self.postDateDic];
    }
}

- (IBAction)acceptAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(postDateViewDidAcceptWithDic:)]) {
        
        [self.delegate postDateViewDidAcceptWithDic:self.postDateDic];
    }
}

- (IBAction)callAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(postDateViewDidCall)]) {
        
        [self.delegate postDateViewDidCall];
    }
}



- (IBAction)rejectAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(postDateViewDidRejectWithDic:)]) {
        
        [self.delegate postDateViewDidRejectWithDic:self.postDateDic];
    }
}

- (void)updateMyViews {
    
    self.postButton.left = 55;
    self.inviteState.left = self.postButton.right;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
