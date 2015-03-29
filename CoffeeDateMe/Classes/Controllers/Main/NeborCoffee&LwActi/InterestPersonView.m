//
//  InterestPersonView.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/3.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "InterestPersonView.h"


@implementation InterestPersonView

- (void)layoutOutWithDic:(NSDictionary *)dic {
    
    self.actiInfo = dic;
    
    for (UIView * view in self.signPersonScrollView.subviews) {
        
        [view removeFromSuperview];
    }

    NSArray * users_photo = nil;

    
    if (self.isPerson == 1) {
        
        users_photo = [dic valueForKey:@"joins"];
        
    }else {
        
        users_photo =   [dic valueForKey:@"users_photo"];;
    }

    
    if ([users_photo count] > 0) {
        
        [self.signPersonScrollView setHidden:NO];
        [self.signNumberHint setHidden:NO];
        [self.signNumbers setHidden:NO];
        
        ////选中
        [self.signButton setBackgroundImage:TTImage(@"login_button") forState:UIControlStateHighlighted];
      
        self.signNumbers.text = [NSString stringWithFormat:@"(%d)",[users_photo count]];
        
        for (int index = 0; index < [users_photo count]; index ++) {
            
            NSDictionary * photo = users_photo[index];            ///2000代表头像
            WTURLImageView * imageView = [[WTURLImageView alloc] initWithFrame:CGRectMake(index * 56, 0, 48, 48)];
            imageView.delegate = self;
            imageView.tag = 2000 +index;
            imageView.userInteractionEnabled = YES;
            
            if (self.isPerson == 1) {
                  [imageView  setURL:[photo valueForKey:@"head_path"] defaultImage:@"default_avatar" type:1];
                
            }else {
                
                  [imageView  setURL:[photo valueForKey:@"path"] defaultImage:@"default_avatar" type:1];
                
            }

            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 24.0;
            imageView.delegate = self;
            [self.signPersonScrollView addSubview:imageView];
        }
        
        NSString * signNumberStr = nil;
        
        if (self.isPerson == 1) {
            
            signNumberStr = [dic valueForKey:@"jioncount"];
            
        }else {
            
            
            signNumberStr = [dic valueForKey:@"user_count"];
        }
        
        self.signNumbers.text = [NSString stringWithFormat:@"(%@)",signNumberStr];
        
        if([users_photo count] > 5){
            
            self.signPersonScrollView.contentSize = CGSizeMake([users_photo count] * 56, self.signPersonScrollView.height);
            
            self.signPersonScrollView.contentOffset = CGPointMake ([users_photo count] * 56 - self.signPersonScrollView.width, 0);
        }
        
        self.height = self.signPersonScrollView.bottom + 10;
        
    }else {
        
        [self.signPersonScrollView setHidden:YES];
        [self.signNumberHint setHidden:YES];
        [self.signNumbers setHidden:YES];
        
        self.height = 42;
    }
}

#pragma mark - WTURLImageViewDelegate

- (void) URLImageViewDidClicked : (WTURLImageView*)imageView {
    
    int index = imageView.tag - 2000;
    
    NSArray * users_photo = nil;
    
    if (self.isPerson == 1) {
        
        users_photo = [self.actiInfo  valueForKey:@"joins"];
        
    }else {
        
        users_photo =   [self.actiInfo  valueForKey:@"users_photo"];;
    }

   // NSArray * users_photo = [self.actiInfo valueForKey:@"users_photo"];

    NSDictionary * personDic = users_photo[index];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(interestPersonView:didClickAvatarWithPersonInfo:)]) {
        
        [self.delegate interestPersonView:self didClickAvatarWithPersonInfo:personDic];
    }
}

- (IBAction)interestAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(interestPersonViewDidClickInterestButton:)]) {
        
        [self.delegate interestPersonViewDidClickInterestButton:self];
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
