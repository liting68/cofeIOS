//
//  ButtomBarView.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-10-9.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "ButtomBarView.h"

@implementation ButtomBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Actions


- (IBAction)inviteAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttomBarView:didClick:)]) {
        
        [self.delegate buttomBarView:self didClick:0];
    }
}

- (IBAction)chatAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttomBarView:didClick:)]) {
        
        [self.delegate buttomBarView:self didClick:1];
    }

}

- (IBAction)deleteAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttomBarView:didClick:)]) {
        
        [self.delegate buttomBarView:self didClick:2];
    }
}

//@property (weak, nonatomic) IBOutlet UIImageView *pullBlackIcon;

//@property (weak, nonatomic) IBOutlet UIButton *pullBackButton;

- (void)updatePullBlackWithFlag:(BOOL)flag {
  
    if (flag) {///YES  显示拉黑
        
        [_pullBackButton setTitle:@"拉黑" forState:UIControlStateNormal];
        
        _pullBlackIcon.image = TTImage(@"buttom3");
        
    }else {//NO  显示粉丝
       
        [_pullBackButton setTitle:@"转粉" forState:UIControlStateNormal];
        
        _pullBlackIcon.image = TTImage(@"buttom4");
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
