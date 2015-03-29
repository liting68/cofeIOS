//
//  MenuView.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 15/2/4.
//  Copyright (c) 2015年 jensen. All rights reserved.
//

#import "MenuView.h"

@implementation MenuView

- (void)layoutMenuView:(NSDictionary *)dic {
    
    self.avatar1.layer.cornerRadius = 6.0;
    self.avatar1.layer.masksToBounds = YES;
    
    self.avatar2.layer.cornerRadius = 6.0;
    self.avatar2.layer.masksToBounds = YES;
    
    self.avatar3.layer.cornerRadius = 6.0;
    self.avatar3.layer.masksToBounds = YES;
    
    self.avatar4.layer.cornerRadius = 6.0;
    self.avatar4.layer.masksToBounds = YES;

    NSArray * menus = [dic valueForKey:@"menus"];
    
    if([menus count] == 0) {
        
        self.noContent = YES;
        
    }else {
        
        self.noContent = NO;
        
        int count = ([menus count] > 4)?4:[menus count];
        
        for (int index = 0; index < count; index ++) {
            
            NSDictionary * menuDic = menus[index];
            
            AvatarView * avaterView = (AvatarView *)[self viewWithTag:index + 1];
            [avaterView setHidden:NO];
            
            [avaterView setURL:[menuDic valueForKey:@"img"] defaultImage:@"candan_default" type:0];
        
            avaterView.delegate = self;
            
            avaterView.userInteractionEnabled = YES;
            
            UIView * view = (UIView *)[self viewWithTag:10 * (index + 1)];
            [view setHidden:NO];
            
            NSString * title = [menuDic valueForKey:@"title"];
            
            UILabel * label = (UILabel *)[self viewWithTag:(index + 1) * 100 ];
            [label setHidden:NO];
            label.text = title;
            
        }
        
        for (int index = count; index < 4; index ++) {
            
            AvatarView * avaterView = (AvatarView *)[self viewWithTag:index + 1];
            [avaterView setHidden:YES];
            
            UIView * view = (UIView *)[self viewWithTag:10 * (index + 1)];
            [view setHidden:YES];

            UILabel * label = (UILabel *)[self viewWithTag:(index + 1) * 100 ];
            [label setHidden:YES];
          
        }
    }
    
    self.height = 262;
}

#pragma mark - WTUrlImageViewDelegate

- (void)URLImageViewDidClicked:(WTURLImageView *)imageView {
    
    int tag = imageView.tag - 1;
        
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuView:didSelectedIndex:)]) {
            
        [self.delegate menuView:self didSelectedIndex:tag];
    }
}

@end
