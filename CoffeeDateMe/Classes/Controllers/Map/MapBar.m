//
//  MapBar.m
//  CoffeeDateMe
//
//  Created by 波罗密 on 14-11-16.
//  Copyright (c) 2014年 jensen. All rights reserved.
//

#import "MapBar.h"

@implementation MapBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)actions:(UIButton *)sender {
    
    int tag = sender.tag;
    
    NSArray * imageArr = [NSArray arrayWithObjects:@"map_action_icon_walk",@"map_action_icon_bus",@"map_action_icon_car",nil];
    NSArray * imageSelected = [NSArray arrayWithObjects:@"walk_selected",@"bus_selected",@"car_selected",nil];
    
    if (self.currentSelected == tag) {
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(mapBarDidSelectedAtIndex:)]) {
            
            [self.delegate mapBarDidSelectedAtIndex:tag];
        }
    
    }else {
        
        if (self.currentSelected > 0) {
            
            UIImageView * imgView = (UIImageView *)[self viewWithTag:10 +  self.currentSelected];
            imgView.image = TTImage(imageArr[self.currentSelected - 1]);

        }
        
        UIImageView * sView = (UIImageView *)[self viewWithTag:10 +  tag];
        sView.image = TTImage(imageSelected[tag - 1]);

        self.currentSelected = tag;
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(mapBarDidSelectedAtIndex:)]) {
            
            [self.delegate mapBarDidSelectedAtIndex:tag];
        }
    }
}



@end
