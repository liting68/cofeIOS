//
//  PicPlaceHolderView.m
//  ModelAPP
//
//  Created by 波罗密 on 14-8-7.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "PicPlaceHolderView.h"

@implementation PicPlaceHolderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)addAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(picPlaceHlderViewDidClickAddAction)]) {
        
        [self.delegate picPlaceHlderViewDidClickAddAction];
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
