//
//  AvatarView.m
//  ModelAPP
//
//  Created by 波罗密 on 14-8-4.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "AvatarView.h"
#import <QuartzCore/QuartzCore.h>

@implementation AvatarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       
    }
    return self;
}

- (void)setConers {
    
    self.userInteractionEnabled = YES;
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.layer.borderWidth = 2.0f;
  //  self.image = TTImage(@"shop_comment_avatar");
    self.layer.masksToBounds = YES;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    

}


@end
